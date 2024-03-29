//+------------------------------------------------------------------+
//|                                             HistogramaVolume.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   2

//--- plot Buy
#property indicator_label1  "Buy"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrLime
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

//--- plot Sell
#property indicator_label2  "Sell"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrDeepPink
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

//--- indicator buffers
double         BuyBuffer[];
double         SellBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    //--- indicator buffers mapping
    SetIndexBuffer(0,BuyBuffer,INDICATOR_DATA);
    SetIndexBuffer(1,SellBuffer,INDICATOR_DATA);
   
    //---
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated, // Contém o valor de rates_total da chamada anterior.
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
    int start = 0;
    
    if (prev_calculated != 0) 
    {
        start = prev_calculated-1;
    }
    
    for (int index = start; index < rates_total; index++)
    {
        if (open[index] < close[index]) // sinaliza candle de alta
        {
            BuyBuffer[index] = (double) volume[index];
        }
        else // candle de baixa
        {
            SellBuffer[index] = (double) volume[index];
        }
    }
    
    Print("Raes: ", rates_total, " Prev : ", prev_calculated);
    
    //--- return value of prev_calculated for next call
    return(rates_total);
}
//+------------------------------------------------------------------+
