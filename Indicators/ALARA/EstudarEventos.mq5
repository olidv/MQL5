//+------------------------------------------------------------------+
//|                                               EstudarEventos.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

#property indicator_chart_window

//+------------------------------------------------------------------+
//| Custom indicator initialization function: executado apenas 1x, ao |
//| adicionar o indicador ao gráfico.                                 |
//+------------------------------------------------------------------+
int OnInit()
{
    //--- indicator buffers mapping
    Print("OnInit ", TimeCurrent());
   
    EventSetTimer(3);
    
    //---
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function: disparado periodicamente.   |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    //---
    Print("OnCalculate ", TimeCurrent());
   
    //--- return value of prev_calculated for next call
    return(rates_total);
}

//+------------------------------------------------------------------+
//| Timer function: disparado conforme o temporizador configurado.   |
//+------------------------------------------------------------------+
void OnTimer()
{
    //---
    Print("OnTimer ", TimeCurrent());
   
}

//+------------------------------------------------------------------+
//| ChartEvent function: quando interage com gráfico, click, key...  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
    //---
    Print("OnChartEvent ", TimeCurrent());
   
}

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Quando o indicador é removido (excluido) do gráfico.             |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    //---
    Print("OnDeinit ", TimeCurrent());
    
    EventKillTimer();
}

//+------------------------------------------------------------------+
