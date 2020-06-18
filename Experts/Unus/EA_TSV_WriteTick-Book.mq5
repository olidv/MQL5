//+------------------------------------------------------------------+
//|                                         EA_CSV_WriteTickBook.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <ALARA\WinAPI_Time.mqh>

//--- Funcoes para processamento conforme a B3
#include <ALARA\B3_Info.mqh>

//+------------------------------------------------------------------+

#define EA_TIMER    5     // timer em segundos

#define DATA_SIZE   5000  // limite de 1000 registros p/ segundo (1 evento a cada 1 milisegundo)

//+------------------------------------------------------------------+

//---
struct STickBook {
    int          idTick;
    int          localTime;
    MqlTick      tickInfo;    // informacoes sobre o ultimo tick
    MqlBookInfo  bookInfo[];  // Ofertas de venda e compra do book
};

//+------------------------------------------------------------------+

//---
const string FILE_SUFFIX_TICK = "_Tick-Book.csv";
int          csvHandleTick;

//---
int          tickCont = 0,
             idLastTick = 0;  // corresponde ao total de registros de tick e book coletados
STickBook    tickData[DATA_SIZE];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    Print("EA [", _Symbol, "] :  WRITE TICK & BOOK CSV FILE  |  TIMER = ", EA_TIMER, " seg");
    Print("----------------------------------------------------------------------");

    //--- inicializa o arquivo CSV para TICKs:
    string fileName = TimeToString(TimeLocal(), TIME_DATE) + "_" + _Symbol + FILE_SUFFIX_TICK;
    bool fileExist = FileIsExist(fileName);
    
    ResetLastError();
    csvHandleTick = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                              : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI); 
    if (csvHandleTick == INVALID_HANDLE) {
        Print("EA [", _Symbol, "] :  Operação 'FileOpen(", fileName, ")' falhou! Erro = ", GetLastError()); 
        return (INIT_FAILED);

    } else if (fileExist) {
       FileSeek(csvHandleTick, 0, SEEK_END);

    } else {
        string bookHead = "";
        for (int i = 0; i < BOOK_SIZE; i++)
            bookHead += StringFormat("PRICE_%d\tVOLUME_%d\t", i, i);
        // elimina o ultimo tab
        bookHead = StringSubstr(bookHead, 0, StringLen(bookHead) - 1);

        FileWrite(csvHandleTick, "ID_TICK", "LOCAL_TIME", "TIME", "BID", "ASK", "LAST", "VOLUME",
                                 "FLAG_BID", "FLAG_ASK", "FLAG_LAST", "FLAG_VOLUME", "FLAG_BUY", "FLAG_SELL",
                                 bookHead);
    }
    
    // É preciso abrir o acesso aos dados do book
    if (! MarketBookAdd(_Symbol))  // Abertura da Profundidade de Mercado (DOM = Depth of Market)
        return(INIT_FAILED);

    //--- create timer
    if (! EventSetTimer(EA_TIMER)) 
        return(INIT_FAILED);
    
    //---
    return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//| Este evento/funcao gasta em torno de 10 a 20 microsegundos para  |
//| ser executado, sendo disparado a cada 10 a 20 milisegundos.      |
//+------------------------------------------------------------------+
void OnTick() {
    //--- identifica o proximo registro do array de ticks
    ++tickCont;

    // ultima mudanca no price tick
    if (MarketBookGet(_Symbol, tickData[tickCont].bookInfo) && SymbolInfoTick(_Symbol, tickData[tickCont].tickInfo)
                                                            && ArraySize(tickData[tickCont].bookInfo) == BOOK_SIZE) {
        // data-hora local no momento da obtencao do tick
        tickData[tickCont].localTime = GetMillisecondsTime(); // soh a parte hora, em milissegundos

        // mais um registro de alteracao de preco (tick)
        tickData[tickCont].idTick = ++idLastTick;

    } else {
        // se ocorrer algum problema, restaura o ultimo contador valido.
        --tickCont;
    }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//| Foi definido um timer de 5 segundos, pois este evento/funcao     |
//| esta gastando entre 4 a 8 milisegundos para executar. Se o timer |
//| for definido em intervalo de tempo maior que 5 segundos, este    |
//| evento pode gastar mais que 10 milisegundos para executar, o que |
//| pode prejudicar / atrasar o disparo de OnBookEvent() e OnTick(). |
//+------------------------------------------------------------------+
void OnTimer() {
    int copyTickCont = 0;
    
    //---
    bool endPregao = EncerrouPregaoB3() || _StopFlag;
    if (endPregao) {
        EventKillTimer();  //--- destroy timer
        MarketBookRelease(_Symbol);
    }

    //---
    if (tickCont > 0) {
        //---
        copyTickCont = tickCont;

        //--- zera o index da estrutura de dados para coleta:
        tickCont = 0;

        //--- gravar dados no arquivo
        for (int i = 1; i <= copyTickCont; i++) {
            STickBook tick = tickData[i];

            bool flag_bid = tick.tickInfo.flags & TICK_FLAG_BID;
            bool flag_ask = tick.tickInfo.flags & TICK_FLAG_ASK;
            bool flag_last = tick.tickInfo.flags & TICK_FLAG_LAST;
            bool flag_volume = tick.tickInfo.flags & TICK_FLAG_VOLUME;
            bool flag_buy = tick.tickInfo.flags & TICK_FLAG_BUY;
            bool flag_sell = tick.tickInfo.flags & TICK_FLAG_SELL;

            //--- formata o book em uma unica linha tabulada para gravacao
            string lineBook = "";
            for (int j = 0; j < BOOK_SIZE; j++) {
                //--- formata os dados como inteiro para facilitar a analise:
               lineBook += StringFormat("%d\t%d\t", PrecoInteiro(tick.bookInfo[j].price), tick.bookInfo[j].volume);
            }
            // elimina o ultimo tab
            lineBook = StringSubstr(lineBook, 0, StringLen(lineBook) - 1);

            //--- chamar função de escrever 
            FileWrite(csvHandleTick, tick.idTick, (HOJE_MILISSEGUNDOS + tick.localTime), tick.tickInfo.time_msc, 
                                     PrecoInteiro(tick.tickInfo.bid), PrecoInteiro(tick.tickInfo.ask), PrecoInteiro(tick.tickInfo.last), tick.tickInfo.volume,
                                     flag_bid, flag_ask, flag_last, flag_volume, flag_buy, flag_sell,
                                     lineBook);
        }
   
        //--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
        FileFlush(csvHandleTick);
    }

    //---
    if (endPregao) {
        //--- fechar o arquivo 
        FileClose(csvHandleTick); 
        csvHandleTick = INVALID_HANDLE;  // invalida handle

        Print("----------------------------------------------------------------------");
        Print("EA [", _Symbol, "] :  Programa Encerrado! Total de TICKs e BOOKs Obtidos = ", IntegerToString(idLastTick,7));
        
        //Interrompe o Expert Advisor e o descarrega do gráfico
        ExpertRemove();

    //} else {
    //    Print("EA [", _Symbol, "] :  TICKs e BOOKs Gravados = ", IntegerToString(copyTickCont,7));
    //    Print("----------------------------------------------------------------------");
    }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- grava os ultimos registros:
    OnTimer();  // aqui o valor de _StopFlag = false
}

//+------------------------------------------------------------------+
