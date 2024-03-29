//+------------------------------------------------------------------+
//|                                                       Maxima.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

#property indicator_chart_window // Sinaliza que o indicador será na mesma janela do gráfico
#property indicator_buffers 1    // Quantos buffers serão utilizados pelo indicador
#property indicator_plots   1    // Quantos indicadores serão plotados

//--- plot Maxima (1º indicador - uma seção 'plot' por indicador)
#property indicator_label1  "Maxima"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRoyalBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

//--- indicator buffers
double         MaximaBuffer[]; // buffer utilizado para manter os valores a serem plotados

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    // pega os dados do indicador e faz o mapeamento para o buffer.
    SetIndexBuffer(0, MaximaBuffer, INDICATOR_DATA);

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
    }
   
    //--- return value of prev_calculated for next call
    return(rates_total);
}
//+------------------------------------------------------------------+
