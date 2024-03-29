//+------------------------------------------------------------------+
//|                                                FastTickEvent.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <ALARA\WinAPI_Time.mqh>

//+------------------------------------------------------------------+

#define TIMER       10       // timer em segundos

#define DIFF_SIZE   1000    // 0 a 999 milisegundos
#define DIFF_QTDE   999.0   // para calculo da media em double

#define DATA_SIZE   300000  // media de 100 por segundo (disparando cada 10 milisegundos)

SYSTEMTIME startTimer, stopTimer, lastTickTime;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    GetLocalTime(startTimer);

    Print("EA: FAST-TICK-EVENT com TIMER = ",TIMER," seg");
    Print("----------------------------------------------------------------------");

    //--- setup timer
    EventSetTimer(TIMER);

    //---
    return(INIT_SUCCEEDED);
}

//---
static int tickCont = 0;
static SYSTEMTIME tickTimes[DATA_SIZE];

//+------------------------------------------------------------------+
//| Price Tick Event Function                                        |
//+------------------------------------------------------------------+
void OnTick() {
    //---
    static bool result = false;

    //---
    MqlTick tickInfo;
        // datetime time;       : Hora da última atualização de preços
        // double   bid;        : Preço corrente de venda
        // double   ask;        : Preço corrente de compra
        // double   last;       : Preço da última operação (preço último)
        // ulong    volume;     : Volume para o preço último corrente
        // long     time_msc;   : Tempo do "Last" preço atualizado em  milissegundos
        // uint     flags;      : Flags de tick
        // double   volume_real : Volume para o preço Last atual com maior precisão

    result = SymbolInfoTick(_Symbol, tickInfo);
    if (result) {
        GetLocalTime(tickTimes[tickCont]);
        lastTickTime = tickTimes[tickCont];
        tickCont++;
    }
}

//+------------------------------------------------------------------+
//| Timer Event Function: 60 segundos = 1 minuto                     |
//+------------------------------------------------------------------+
void OnTimer() {
    GetLocalTime(stopTimer);
    
    //--- apenas executa 1 unica vez.
    EventKillTimer();

    Print("  startTimer : ",SystemTimeToString(startTimer));
    Print("   stopTimer : ",SystemTimeToString(stopTimer));
    Print("");
    Print("lastTickTime : ",SystemTimeToString(lastTickTime));
    Print("----------------------------------------------------------------------");

    //---
    if (tickCont > 0) {
        int tickDiffs[DIFF_SIZE];

        double media = DiffMedia(tickCont, tickTimes, tickDiffs);
        //for (int i = 0; i < DIFF_SIZE; i++) {
        //    if (tickDiffs[i] > 0)
        //        Print("TICK Diff[",i,"] = ", tickDiffs[i]);
        //}
        
        Print("TICKs Obtidos = ", tickCont, " / Media de Tempo = ", DoubleToString(media, 4), " milissegundos");
        Print("----------------------------------------------------------------------");

        //---
        tickCont = 0;
    } else {
        Print("TICKs Obtidos = 0");
        Print("----------------------------------------------------------------------");
    }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- destroy timer
    EventKillTimer();
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
