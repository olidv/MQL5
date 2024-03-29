//+------------------------------------------------------------------+
//|                                                   IndexForce.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1

//--- plot iForce
#property indicator_label1  "iForce"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

//-- parametros de entrada
input group               "Parâmetros de Entrada" 
input int                 InputNroPeriodos = 13;          // # de Períodos
input ENUM_MA_METHOD      InputEnumMetodo  = MODE_SMA;    // Tipo do Método
input ENUM_APPLIED_VOLUME InputApplyVolume = VOLUME_REAL; // Tipo de Dado

//--- indicator buffers
double         iForceBuffer[];
int            handleIF;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    //--- indicator buffers mapping
    SetIndexBuffer(0,iForceBuffer,INDICATOR_DATA);
    
    handleIF = iForce(_Symbol, _Period, InputNroPeriodos, InputEnumMetodo, InputApplyVolume);
       
    //---
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
    CopyBuffer(handleIF, 0, 0, rates_total, iForceBuffer);
   
    //--- return value of prev_calculated for next call
    return(rates_total);
}
//+------------------------------------------------------------------+
