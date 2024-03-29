//+------------------------------------------------------------------+
//|                                                        Hello.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

// o indicador estara no grafico
#property indicator_chart_window

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
// sera executado ao iniciar no grafico                              |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
int teste = 1145;

//---
   Comment("Olá Mundo !");
   Print("_Symbol ", _Symbol, " .:. _Point = ", _Point, " .:. _Digits = ", _Digits);
   
   MqlTick myTick;
   SymbolInfoTick(_Symbol,myTick);
   Print(myTick.time, " : Bid = ", myTick.bid, 
                      " : Ask = ", myTick.ask,
                      " : Volume = ", myTick.volume); 
   
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
// funcao de calculo para pegar informacoes do grafico               |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
//---

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
