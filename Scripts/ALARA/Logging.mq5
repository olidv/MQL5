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
#include <ALARA\Logging\Format\SimpleFormatter.mqh>
#include <ALARA\Logging\Append\ConsoleAppender.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

enum TESTE { a, b, c };
    
void OnStart() {

SLogRecord record = {0};
/*
Print("SLogRecord.timestamp = ", record.timestamp);
Print("SLogRecord.loggerName = ", record.loggerName);
Print("SLogRecord.methodName = ", record.methodName);
Print("SLogRecord.lineNumber = ", record.lineNumber);
Print("SLogRecord.level = ", record.level);
Print("SLogRecord.message = ", record.message);

Print(record.loggerName == NULL);
Print(record.loggerName == "");
Print(record.level == NULL);
Print(record.level == 0);
*/
   record.timestamp = TimeCurrent();
   record.level = LOG_LEVEL_DEBUG;
   record.methodName = __FUNCTION__;
   record.lineNumber = __LINE__;
   record.loggerName = __FILE__;
   record.message = "Simples teste de logging";
  

CSimpleFormatter *formatter = new CSimpleFormatter(LAYOUT_TEXT_SIMPLE);
CConsoleAppender *appender = new CConsoleAppender("", LOG_LEVEL_TRACE, formatter);

   
   string msg = formatter.formatMessage(record);
   Print("Mensagem formatada = ", msg);

    appender.write(record);
    
//delete(formatter);
delete(appender);
}

//+------------------------------------------------------------------+









 
    //---
    //Log_SetLevel(ALL);
    //Log_SetLevel(TRACE);
    //Log_SetLevel(DEBUG);
    //Log_SetLevel(INFO);
    //Log_SetLevel(WARN);
    //Log_SetLevel(ERROR);
    //Log_SetLevel(FATAL);
    //Log_SetLevel(NONE);
    
    //---
//    datetime hoje = D'01.01.2016 13:43:23';
//    
//    Log_Trace("trace enter... ", __FUNCTION__, __LINE__);
//    Log_Debug("value debug ", __FUNCTION__);
//    Log_Info("informacao ", "", __LINE__);
//    Log_Warn("aviso ");
//    Log_Error("erro ");
//    Log_Fatal("critico ");