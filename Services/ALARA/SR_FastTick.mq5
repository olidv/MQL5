//+------------------------------------------------------------------+
//|                                                  SR_FastTick.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

#property service

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <ALARA\WinAPI_Time.mqh>

//+------------------------------------------------------------------+

#define ATIVO       "WINM21"
#define TIMER       1       // timer em milissegundos

#define DIFF_SIZE   1000    // 0 a 999 milisegundos
#define DIFF_QTDE   999.0   // para calculo da media em double

#define DATA_SIZE   300000  // media de 100 por segundo (disparando cada 10 milisegundos)

//---
static int          tickCont = 0;
static MqlTick      tickData[DATA_SIZE];
static SYSTEMTIME   tickTimes[DATA_SIZE];
static SYSTEMTIME   startTimer, stopTimer, lastTickTime;

//+------------------------------------------------------------------+
//| Service program start function                                   |
//+------------------------------------------------------------------+
void OnStart() {
    GetLocalTime(startTimer);
    
    Print("SERVICE: FAST-TICK  para ",ATIVO, "  com TIMER = ",TIMER," milissegundos");
    Print("----------------------------------------------------------------------");

    //---
    while (true) {
        // MqlTick tickInfo:
            // datetime time;       : Hora da última atualização de preços
            // double   bid;        : Preço corrente de venda
            // double   ask;        : Preço corrente de compra
            // double   last;       : Preço da última operação (preço último)
            // ulong    volume;     : Volume para o preço último corrente
            // long     time_msc;   : Tempo do "Last" preço atualizado em  milissegundos
            // uint     flags;      : Flags de tick
            // double   volume_real : Volume para o preço Last atual com maior precisão

        bool result = SymbolInfoTick(ATIVO, tickData[tickCont]);
        if (result) {
            GetLocalTime(tickTimes[tickCont]);
            lastTickTime = tickTimes[tickCont];
            tickCont++;
        }
        
        if (tickCont % 1000 == 0) break;
    }
    
    //---
    GetLocalTime(stopTimer);

    Print("  startTimer : ",SystemTimeToString(startTimer));
    Print("   stopTimer : ",SystemTimeToString(stopTimer));
    Print("");
    Print("lastTickTime : ",SystemTimeToString(lastTickTime));
    Print("----------------------------------------------------------------------");

    //---
    if (tickCont > 0) {
        int tickDiffs[DIFF_SIZE];

        double media = DiffMedia(tickCont, tickTimes, tickDiffs);
        for (int i = 0; i < DIFF_SIZE; i++) {
            if (tickDiffs[i] > 0)
                Print("TICK Diff[",i,"] = ", tickDiffs[i]);
        }
        
        Print("TICKs Obtidos = ", tickCont, " / Media de Tempo = ", DoubleToString(media, 4), " milissegundos");
        Print("----------------------------------------------------------------------");

        Print("TICK DATA:  TIME   BID   ASK   LAST   VOLUME   FLAGS");
        for (int i = 0; i < tickCont; i++) {
            MqlTick tick = tickData[i];
            Print("[",i,"]",tick.time,", ",tick.bid,", ",tick.ask,", ",tick.last,", ",tick.volume,", ",tick.flags);
        }
        Print("----------------------------------------------------------------------");


        //---
        tickCont = 0;
    } else {
        Print("TICKs Obtidos = 0");
        Print("----------------------------------------------------------------------");
    }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double DiffMedia(int cont, SYSTEMTIME &times[], int &diffs[]) {
    int inc = 0, som = 0, prevMils = 0, nextMils = 0;

    ArrayFill(diffs, 0, DIFF_SIZE, 0);
    prevMils = GetMillisecondsTime(times[0]);
    for (int i = 0; i < cont; i++) {
        nextMils = GetMillisecondsTime(times[i]);
        inc = nextMils - prevMils;
        if(inc < DIFF_SIZE)
            diffs[inc] += 1;
        else
            diffs[DIFF_SIZE-1] += 1;

        som += inc;
        prevMils = nextMils;
    }

    // manipula em double para melhor precisao:
    return (som / DIFF_QTDE); // ignora a 1ª posicao.
}
   
//+------------------------------------------------------------------+
