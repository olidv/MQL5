//+------------------------------------------------------------------+
//|                                                     OlaMundo.mq5 |
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
//| Script program start function                                    |
//+------------------------------------------------------------------+

void OnStart() {
    datetime start_time = GetHoje();
    datetime stop_time = start_time + DIA_END;

    MqlRates rates[]; 
    ArraySetAsSeries(rates, true); 

    ResetLastError();
    int copied = CopyRates(_Symbol, PERIOD_M1, start_time, stop_time, rates); 
    Print("MqlRates do Periodo: ", start_time, " ate ", stop_time, " = ", copied);
    Print("    Erro: ",  GetLastError());
    
    MqlTick ticks[];
    ArraySetAsSeries(ticks, true); 
    ArrayResize(ticks, 10000);

    ResetLastError();
    copied = CopyTicksRange(_Symbol, ticks, COPY_TICKS_ALL, start_time, stop_time);
    Print("MqkTicks do Periodo: ", start_time, " ate ", stop_time, " = ", copied);
    Print("    Erro: ",  GetLastError());

    ResetLastError();
    copied = CopyTicks(_Symbol, ticks, COPY_TICKS_ALL, start_time);
    Print("MqkTicks do Periodo: ", start_time, " ate ", stop_time, " = ", copied);
    Print("    Erro: ",  GetLastError());
}

//+------------------------------------------------------------------+
