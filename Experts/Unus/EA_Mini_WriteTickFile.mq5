//+------------------------------------------------------------------+
//|                                         EA_WIN_WriteTickFile.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <Unus\wintime.mqh>

//--- Funcoes para processamento conforme a B3
#include <Unus\B3_Info.mqh>

//+------------------------------------------------------------------+

#define EA_TIMER    60    // timer em segundos = 1 minuto

#define DATA_SIZE   6000  // limite de 100 por segundo (minimo a cada 10 milisegundos)

//+------------------------------------------------------------------+

//---
static const string FILE_SUFFIX_TICK = "_Tick.csv";
static int          csvHandleTick;

//---
static int          tickCont = 0;
static MqlTick      tickData[DATA_SIZE];
static MqlTick      copyTickData[DATA_SIZE];  // buffer temporario

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    Print("EA [",_Symbol,"] :  WRITE-TICK-FILE  com  TIMER = ",EA_TIMER," seg");
    Print("----------------------------------------------------------------------");

    //--- inicializa o arquivo CSV:
    string fileName = TimeToString(TimeLocal(), TIME_DATE) + "_" + _Symbol + FILE_SUFFIX_TICK;
    bool fileExist = FileIsExist(fileName);
    
    ResetLastError();
    csvHandleTick = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                              : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI); 
    if (csvHandleTick == INVALID_HANDLE) {
        Print("EA [",_Symbol,"] :  Operação 'FileOpen(",fileName,")' falhou! Erro = ", GetLastError()); 
        return (INIT_FAILED);

    } else if (fileExist) {
       FileSeek(csvHandleTick, 0, SEEK_END);

    } else {
        FileWrite(csvHandleTick, "TIME","LOCAL_TIME","BID","ASK","LAST","VOLUME","FLAG_BID","FLAG_ASK","FLAG_LAST","FLAG_VOLUME","FLAG_BUY","FLAG_SELL");
    }

    //--- create timer
    EventSetTimer(EA_TIMER);
    
    //---
    return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
    //---
    if (SymbolInfoTick(_Symbol, tickData[tickCont])) {
        tickData[tickCont++].volume_real = (double) GetMillisecondsTime();
    }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {
    static int totalTickCont = 0, copyTickCont = 0;

    //---
    bool endPregao = EncerrouPregaoB3() || _StopFlag;
    if (endPregao) {
        EventKillTimer();  //--- destroy timer
    }

    //---
    if (tickCont > 0) {
        //---
        copyTickCont = tickCont;
        ArrayCopy(copyTickData, tickData, 0, 0, tickCont);
        totalTickCont += tickCont;

        //--- zera valores atuais
        tickCont = 0;
        ZeroMemory(tickData);
        
        //--- gravar dados no arquivo
        for (int i = 0; i < copyTickCont; i++) {
           MqlTick tick = copyTickData[i];
           
           bool flag_bid = tick.flags & TICK_FLAG_BID;
           bool flag_ask = tick.flags & TICK_FLAG_ASK;
           bool flag_last = tick.flags & TICK_FLAG_LAST;
           bool flag_volume = tick.flags & TICK_FLAG_VOLUME;
           bool flag_buy = tick.flags & TICK_FLAG_BUY;
           bool flag_sell = tick.flags & TICK_FLAG_SELL;

           //--- chamar função de escrever 
           FileWrite(csvHandleTick, tick.time_msc, DoubleToString(tick.volume_real,0), DoubleToString(tick.bid,SIMBOLO_DIGITOS), DoubleToString(tick.ask,SIMBOLO_DIGITOS), DoubleToString(tick.last,SIMBOLO_DIGITOS), DoubleToString(tick.volume,0), 
                                    flag_bid, flag_ask, flag_last, flag_volume, flag_buy, flag_sell);
        }
    
        //--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
        FileFlush(csvHandleTick);
    }

    //Print("EA [",_Symbol,"] :  TICKs Gravados = ", IntegerToString(copyCont,5));
    //Print("----------------------------------------------------------------------");

    //---
    if (endPregao) {
        //--- fechar o arquivo 
        FileClose(csvHandleTick); 
        csvHandleTick = INVALID_HANDLE;  // invalida handle

        Print("----------------------------------------------------------------------");
        Print("EA [",_Symbol,"] :  Pregão Encerrado! Total de TICKs Obtidos = ", totalTickCont);
    }    
}
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- destroy timer
    EventKillTimer();
    
    //--- fechar o arquivo, se ja nao foi fechado
    if (csvHandleTick != INVALID_HANDLE) {
        FileFlush(csvHandleTick);
        FileClose(csvHandleTick); 
        csvHandleTick = INVALID_HANDLE;  // invalida handle
    }
}

//+------------------------------------------------------------------+
