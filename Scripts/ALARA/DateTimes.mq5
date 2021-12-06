//+------------------------------------------------------------------+
//|                                                     OlaMundo.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

void OnStart() {
   MqlDateTime STime;

   datetime time_current=TimeCurrent(STime);   
   Print("Time Current ",time_current," day of week ",EnumToString((ENUM_DAY_OF_WEEK)STime.day_of_week));
   
   datetime time_local=TimeLocal(STime);
   Print("Time Local ",time_local," day of week ",EnumToString((ENUM_DAY_OF_WEEK)STime.day_of_week));
   
   Print("day_of_week = ",STime.day_of_week);
   Print("day_of_week = ",WEDNESDAY);
}

//+------------------------------------------------------------------+
