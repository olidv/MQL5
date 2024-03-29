//+------------------------------------------------------------------+
//|                                                    InfoTimer.mq5 |
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

#define TIMER_MILLISECONDS 1      // timer = 1 milissegundo

#define DIFF_SIZE          1000   // 0 a 999 milisegundos
#define DIFF_QTDE          999.0  // para calculo da media em double

#define TIMES_SIZE         1000   // máximo de 100 por segundo (cada 10 milisegundos)

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    SYSTEMTIME st;
    GetLocalTime(st);
    PrintFormat("LocalTime: [%d] %04d/%02d/%02d %02d:%02d:%02d:%03d",st.wDayOfWeek,
                st.wYear,st.wMonth,st.wDay,
                st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);

    datetime dt = GetDatetime(st);
    Print("Datetime: ", dt, " / Long: ", (long) dt);
    
    long millis = GetMillisecondsTime(st);
    Print("Time Milissegundos: ", millis);

    //--- setup timer
    EventSetMillisecondTimer(TIMER_MILLISECONDS);
  
    //---
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {
    //---
    static int cont = 0;
    static SYSTEMTIME system_time[TIMES_SIZE];

    //---
    GetLocalTime(system_time[cont++]);

    //--- Aguarda coletar TIMES_SIZE vezes
    if (cont % TIMES_SIZE == 0) {
        //--- destroy timer
        EventKillTimer();

        int diff[DIFF_SIZE];
        int inc = 0, som = 0, prevMils = 0, nextMils = 0;

        ArrayFill(diff, 0, DIFF_SIZE, 0);
        prevMils = GetMillisecondsTime(system_time[0]);
        for (int i = 0; i < TIMES_SIZE; i++) {
            nextMils = GetMillisecondsTime(system_time[i]);
            inc = nextMils - prevMils;
            diff[inc] += 1;
            som += inc;
            prevMils = nextMils;
        
            PrintFormat("Data: [%d] %04d/%02d/%02d %02d:%02d:%02d:%03d  (+%d)",system_time[i].wDayOfWeek,
                        system_time[i].wYear,system_time[i].wMonth,system_time[i].wDay,
                        system_time[i].wHour,system_time[i].wMinute,system_time[i].wSecond,system_time[i].wMilliseconds,
                        inc);
            // Data: [0] 2020/05/24 12:07:01:016  (+16)
        }
        
        for(int i = 0; i < DIFF_SIZE; i++) {
            if (diff[i] > 0)
                Print("Contador Diff[",i,"] = ", diff[i]);
        }
        
        double media = som/DIFF_QTDE;
        Print("Contador Geral = ", cont, " / Media = ", DoubleToString(media, 10));
        // Contador = 1000 / Media = 15.00
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
