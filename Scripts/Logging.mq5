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
#include <ALARA\Logger.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

enum TESTE { a, b, c };
    
void OnStart() {
    //---
    Log_SetLevel(ALL);
    //Log_SetLevel(TRACE);
    //Log_SetLevel(DEBUG);
    //Log_SetLevel(INFO);
    //Log_SetLevel(WARN);
    //Log_SetLevel(ERROR);
    //Log_SetLevel(FATAL);
    //Log_SetLevel(NONE);
    
    //---
    datetime hoje = D'01.01.2016 13:43:23';
    
    Log_Trace("trace enter... ", __FUNCTION__, __LINE__);
    Log_Debug("value debug ", __FUNCTION__);
    Log_Info("informacao ", "", __LINE__);
    Log_Warn("aviso ");
    Log_Error("erro ");
    Log_Fatal("critico ");
}

//+------------------------------------------------------------------+
