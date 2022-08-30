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

//program file         SA_QuantModerator.mqh
//program package      MQL5/Services/ALARA/Common/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************

#property service


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include <ALARA\BR_EvE.mqh>  // Funcoes utilitarias de uso geral (Enumerators e Evaluators).
#include <ALARA\GlobalVar.mqh>  // Manutencao de variaveis globais no terminal.
#include <ALARA\Trading\TradeHelper.mqh>  // Funcoes helpers para auxilio as operacoes de trading.


//+------------------------------------------------------------------+
//--- timer em segundos e/ou milissegundos
#define TIMER_SECONDS       15
#define TIMER_MILLISECONDS  14999  // compensa por eventuais atrasos


//+------------------------------------------------------------------+
//--- Helper para manutencao da variavel global referenciada:
CGlobalVar*       gVar = NULL;
const string      nVar = "SA_" + "EURUSD" + "_01";  // nome da g-variavel deste service-advisor
const string  quantVar = "EURUSD_";                 // prefixo dos quant-advisors que fazem analise tecnica
const string brokerVar = "EA_EURUSD_";              // onde o respectivo expert-advisor ira registrar seu status

//--- Informacoes coletadas dos robos quants com analise tecnica do ativo:
SQuantVar  quantVars[];


//+------------------------------------------------------------------+
//| Funcao executada na inicializacao do service.                    |
//+------------------------------------------------------------------+
void OnStart()
   {
//--- Inicializa os recursos utilizados pelo service-advisor.
    gVar = new CGlobalVar(nVar, GLOBAL_VAR_TEMP);

//--- Loop continuo para varredura das variaveis globais:
    while(! IsStopped())
       {
        //--- Executa o processamento interno e principal do servico.
        if(! OnLoop())
            break;  // se nao ira mais executar, entao sai do loop.

        //--- aguarda alguns segundos antes da proxima iteracao:
        Sleep(TIMER_MILLISECONDS);
       }

//--- Liberacao dos recursos para encerramento do service-advisor.
    OnStop();
    return;
   }


//+------------------------------------------------------------------+
//| Funcao para a execucao do processamento principal do servico.    |
//+------------------------------------------------------------------+
bool OnLoop()
   {
    Print("Seviço esta em execução");

//--- a cada iteracao, efetua coleta dos valores das respectivas variaveis globais:
    if(updateQuantVars(quantVars))
       {
        ArrayPrint(quantVars);
       }

//--- se tudo ok ainda, informa que o loop pode/deve continuar...
    return true;
   }


//+------------------------------------------------------------------+
//| Funcao executada no encerramento do service.                     |
//+------------------------------------------------------------------+
void OnStop()
   {
//--- Liberacao dos recursos para encerramento do service-advisor.
    if(gVar != NULL)
       {
        delete gVar;
        gVar = NULL;
       }
   }


//+------------------------------------------------------------------+
//| Efetua nova coleta de valores das variaveis globais e verifica   |
//| se novas variaveis foram criadas ou se alguma foi excluida.      |
//+------------------------------------------------------------------+
bool updateQuantVars(SQuantVar& quant_array[])
   {
//--- registra o ultimo contador de microsegundos, para calculo do "lapseTime":
    static ulong lastMicroseconds = 0;

//--- obtem todas as variaveis globais relativas a este service-moderator:
    string listNames[];
    const bool retOk = gVar.Names(listNames, quantVar);
    const int qtdNames = ArraySize(listNames);

//--- se nao encontrar as respectivas variaveis globais, nada mais a fazer aqui
    if(! retOk || qtdNames == 0)
       {
        ArrayFree(quant_array);  // elimina os dados coletados anteriormente, ja nao servem mais
        return false;  // se nao coleta variveis, nao atualiza quant-array
       }

//--- cria novo quant-array, pois variaveis podem ser incluidas, alteradas e excluidas:
    SQuantVar listVars[];
    ArrayResize(listVars, qtdNames);

//--- coleta as variaveis globais no novo array, ja pegando os dados anteriores:
    lastMicroseconds = GetMicrosecondCount() - lastMicroseconds;
    const int qaSize = ArraySize(quant_array);
    for(int i = 0; i < qtdNames; i++)
       {
        const string name = listNames[i];
        listVars[i].name = name;
        listVars[i].lasttime = gVar.LastTime(name);
        listVars[i].lastValue = gVar.Get(name);
        listVars[i].lapsetime = lastMicroseconds;

        // inicializa apenas para o caso de nao achar a variavel no array anterior...
        listVars[i].guessAdv = ADVICE_HOLD;  // == 0
        listVars[i].matchFator = 0.0;

        // procura no array principal se a variavel ja foi coletada antes:
        for(int j = 0; j < qaSize; j++)
           {
            if(name == quant_array[j].name)
               {
                listVars[i].guessAdv = quant_array[j].guessAdv;
                listVars[i].matchFator = quant_array[j].matchFator;
               }
           }
        // se nao achou a variavel no array anterior, apenas ignora...
       }

//--- realizada a coleta, transfere o novo array para o quant-array principal:
    ArrayFree(quant_array);
    ArrayResize(quant_array, qtdNames);
    for(int i = 0; i < qtdNames; i++)
        quant_array[i] = listVars[i];

//---
    return true;
   }


//+------------------------------------------------------------------+
