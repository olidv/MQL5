//+------------------------------------------------------------------+
//|                                                       Maxima.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

#property indicator_separate_window // Sinaliza que o indicador será em janela separada do gráfico
#property indicator_buffers 3       // Quantos buffers serão utilizados pelo indicador
#property indicator_plots   3       // Quantos indicadores serão plotados

//--- plot Maxima (1º indicador - uma seção 'plot' por indicador)
#property indicator_label1  "Maxima"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrGreenYellow
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

//--- plot Maxima (2º indicador)
#property indicator_label2  "Minima"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_DASH
#property indicator_width2  2

//--- plot Maxima (3º indicador)
#property indicator_label3  "Media"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrBlueViolet
#property indicator_style3  STYLE_DOT
#property indicator_width3  2

//--- indicator buffers
double         MaximaBuffer[]; // buffer utilizado para manter os valores a serem plotados
double         MinimaBuffer[];
double         MediaBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    // pega os dados do indicador e faz o mapeamento para o buffer.
    SetIndexBuffer(0, MaximaBuffer, INDICATOR_DATA);
    SetIndexBuffer(1, MinimaBuffer, INDICATOR_DATA);
    SetIndexBuffer(2, MediaBuffer, INDICATOR_DATA);

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
    //--- Cálculo a ser representado no gráfico = indicador
    
    for (int index = 0; index < rates_total-1; index++) 
    {
        MaximaBuffer[index] = high[index]; // o valor máximo para cada candle
        MinimaBuffer[index] = low[index]; // o valor mínimo para cada candle
        MediaBuffer[index] = (high[index] + low[index]) / 2.0; // o valor mínimo para cada candle
    }
   
    //--- return value of prev_calculated for next call
    return(rates_total);
}
//+------------------------------------------------------------------+
