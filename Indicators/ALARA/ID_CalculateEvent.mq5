//+------------------------------------------------------------------+
//|                                            ID_CalculateEvent.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

// o indicador estara no grafico
//#property indicator_chart_window

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <ALARA\WinAPI_Time.mqh>

//+------------------------------------------------------------------+

#define TIMER       10       // timer em segundos

#define DIFF_SIZE   1000    // 0 a 999 milisegundos
#define DIFF_QTDE   999.0   // para calculo da media em double

#define DATA_SIZE   300000  // media de 100 por segundo (disparando cada 10 milisegundos)

//---
static int calcCont = 0;
static SYSTEMTIME calcTimes[DATA_SIZE];

SYSTEMTIME startTimer, stopTimer, lastCalcTime;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    GetLocalTime(startTimer);

    Print("EA: ID_CALCULATE-EVENT com TIMER = ",TIMER," seg");
    Print("----------------------------------------------------------------------");

    //--- setup timer
    EventSetTimer(TIMER);

    //---
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//| funcao de calculo para pegar informacoes do grafico              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[]) {
    //---
    GetLocalTime(calcTimes[calcCont]);
    lastCalcTime = calcTimes[calcCont];
    calcCont++;                
    
    //Print("  ",rates_total,"  ",prev_calculated,"  ",begin,"  ",ArraySize(price));
    string prices = "";
    for (int i = 0; i < ArraySize(price); i++) prices += DoubleToString(price[i], 1) + "  ";
    Print("[",rates_total,"]  ",prices);
    
    //--- return value of prev_calculated for next call
    return(0);  // para nao exibir os valores calculados aqui
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
    Print("lastCalcTime : ",SystemTimeToString(lastCalcTime));
    Print("----------------------------------------------------------------------");

    //---
    if (calcCont > 0) {
        int calcDiffs[DIFF_SIZE];

        double media = DiffMedia(calcCont, calcTimes, calcDiffs);
        //for (int i = 0; i < DIFF_SIZE; i++) {
        //    if (calcDiffs[i] > 0)
        //        Print("OnCalculate Diff[",i,"] = ", calcDiffs[i]);
        //}
        
        Print("Eventos OnCalculate Executados = ",calcCont,"  /  Media de Tempo = ", DoubleToString(media, 4), " milissegundos");
        Print("----------------------------------------------------------------------");

        //---
        calcCont = 0;
    } else {
        Print("TICKs Obtidos = ", calcCont);
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
