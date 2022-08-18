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

enum TESTE { a, b, c };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
   {
//---
//    datetime hoje = D'01.01.2016 13:43:23';
//
//    Alert("titulo qualquer", 234, false, TimeCurrent());
//
//    Sleep(5000);
//
//    Alert("segundo titulo", 2, true, TimeCurrent());

//int i = NULL;
//PrintFormat("Teste PrintFormat: %d", NULL);


    int i = 0;
    Print(LogFormat("Teste 1 de logging: %s %f %d", "i", 6.7, TimeLocal()));
    Print(LogFormat("Teste 2 de logging: %d %d %d", i));
    Print(LogFormat("Teste 3 de logging: %d %f %d ", i, 6.7));

   }


//+------------------------------------------------------------------+
