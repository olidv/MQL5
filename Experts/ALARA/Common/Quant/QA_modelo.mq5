/*
 ***********************************************************************************************
 Este programa de  computador contem informacoes  confidenciais de propriedade da ALARA CAPITAL,
 e esta  protegido pela lei de copyright. Voce nao  deve divulgar tais informacoes confidenciais
 e  deve usa-las somente em  conformidade com os termos  do contrato de licenca  definidos  pela
 ALARA CAPITAL. A reproducao ou distribuicao nao autorizada deste programa, ou de qualquer parte
 dele,  resultara na  imposicao de  rigorosas penas  civis e  criminais,  e sera  objeto de acao
 judicial promovida na maxima extensao possivel, nos termos da lei.

 Parte integrante do repositorio de componentes, rotinas e artefatos  criados pela ALARA CAPITAL
 para o desenvolvimento de Trading Algorítmico na plataforma MetaQuotes MetaTrader for Desktop.
 ***********************************************************************************************
*/
#property copyright    "Copyright (C) 2020-2022, ALARA CAPITAL. Todos os direitos reservados."
#property link         "https://www.Alara.com.BR/"

//program file         QA_modelo.mqh
//program package      MQL5/Experts/ALARA/Common/Quant/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include <ALARA\BR_EvE.mqh>  // Funcoes utilitarias de uso geral (Enumerators e Evaluators).
#include <ALARA\GlobalVar.mqh>  // Manutencao de variaveis globais no terminal.
#include <ALARA\Trading\TradeHelper.mqh>  // Funcoes helpers para auxilio as operacoes de trading.


//+------------------------------------------------------------------+
//--- timer em segundos e/ou milissegundos:
#define TIMER_SECONDS       5
#define TIMER_MILLISECONDS  5000

//--- limite de 2000 registros coletados a cada 5 segundos (2 eventos a cada 1 milisegundo):
#define DATA_SIZE   10000


//+------------------------------------------------------------------+
//--- Helper para manutencao da varivael global referenciada:
CGlobalVar* gVar = NULL;
string      sVar = Symbol();


//+------------------------------------------------------------------+
//--- controle dos dados coletados de precos praticados para analise tecnica (quant):
ulong        idLastTick = 0;  // corresponde ao total de registros de tick coletados
ulong        tickNext = 0;
SPriceTick   tickData[DATA_SIZE];

//--- controle dos dados coletados do livro de ofertas para analise tecnica (quant):
ulong        idLastBook = 0;  // corresponde ao total de registros de book coletados
ulong        bookNext = 0;
SOfferBook   bookData[DATA_SIZE];


//+------------------------------------------------------------------+
//| Funcao executada na inicializacao do expert-advisor.             |
//+------------------------------------------------------------------+
int OnInit()
   {
//--- Inicializa os recursos utilizados pelo expert-advisor.
    gVar = new CGlobalVar(sVar, GLOBAL_VAR_TEMP);

//--- Configura e inicia timer, para disparo a cada periodo de segundos:
    if(! EventSetTimer(TIMER_SECONDS))
        return(INIT_FAILED);

//--- Inicializacao do quant-advisor efetuada com sucesso.
    return INIT_SUCCEEDED;
   }


//+------------------------------------------------------------------+
//| Funcao executada na alteracao da profundidade (book) do mercado. |
//+------------------------------------------------------------------+
void OnBookEvent(const string& symbol)
   {
//--- registra o ultimo contador de microsegundos, para calculo do "lapseTime":
    static ulong lastMicroseconds = GetMicrosecondCount();

//--- nao deixa passar alem do tamanho do array, evitando erro out-of-bounds
    if(bookNext >= DATA_SIZE)
        return;

//--- coleta a ultima mudanca no book de ofertas:
    if(MarketBookGet(_Symbol, bookData[bookNext].bookInfo))
       {
        // microsegundos desde a ultima coleta do tick
        bookData[bookNext].lapseTime = GetMicrosecondCount() - lastMicroseconds;

        // mais um regitro do livro de ofertas (order book):
        bookData[bookNext].idBook = ++idLastBook;
        //--- ja salva o ultimo/respectivo registro do tick p/ referencia
        bookData[bookNext].idLastTick = idLastTick;

        // ja posiciona no proximo registro do array de book:
        ++bookNext;
       }
   }


//+------------------------------------------------------------------+
//| Funcao executada quando novo preço eh recebido pelo gráfico.     |
//+------------------------------------------------------------------+
void OnTick()
   {
//--- registra o ultimo contador de microsegundos, para calculo do "lapseTime":
    static ulong lastMicroseconds = GetMicrosecondCount();

//--- nao deixa passar alem do tamanho do array, evitando erro out-of-bounds.
    if(tickNext >= DATA_SIZE)
        return;

//--- coleta a ultima mudanca no price tick:
    if(SymbolInfoTick(_Symbol, tickData[tickNext].tickInfo))
       {
        // microsegundos desde a ultima coleta do tick
        tickData[tickNext].lapseTime = GetMicrosecondCount() - lastMicroseconds;

        // mais um registro de alteracao de preco (tick)
        tickData[tickNext].idTick = ++idLastTick;
        //--- ja salva o ultimo/respectivo registro do book p/ referencia
        tickData[tickNext].idLastBook = idLastBook;

        // ja posiciona no proximo registro do array de ticks:
        ++tickNext;
       }
   }


//+------------------------------------------------------------------+
//| Funcao executada no disparo do evento timer do relogio interno.  |
//+------------------------------------------------------------------+
void OnTimer()
   {
//--- Processa os registros coletados do times and trades:
    if(tickNext > 0)
       {
        SPriceTick priceTick;
        MqlTick tickInfo;
        for(ulong i = 0; i < tickNext; i++)
           {
            priceTick = tickData[i];
            tickInfo = priceTick.tickInfo;

            //--- ...
           }

        //--- zera o index da estrutura de dados para coleta:
        tickNext = 0;
       }

//--- Processa os registros coletados do book de ofertas:
    if(bookNext > 0)
       {
        SOfferBook offerBook;
        MqlBookInfo bookInfo;
        for(ulong i = 1; i <= bookNext; i++)
           {
            offerBook = bookData[i];

            //--- ...

            //--- para cada book de ofertas, processa toda a profundidade:
            int bookSize = ArraySize(offerBook.bookInfo);
            for(int j = 0; j < bookSize; j++)
               {
                bookInfo = offerBook.bookInfo[j];

                //--- ...
               }
           }

        //--- zera o index da estrutura de dados para coleta:
        bookNext = 0;
       }
   }


//+------------------------------------------------------------------+
//| Funcao executada no encerramento do expert-advisor.              |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
//--- Imediatamente cancela timer para nao ser mais disparado.
    EventKillTimer();

//--- Liberacao dos recursos para encerramento do expert-advisor.
    if(gVar != NULL)
       {
        delete gVar;
        gVar = NULL;
       }
   }


//+------------------------------------------------------------------+
