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
#include <ALARA\Logging\LogRecord.mqh>
#include <ALARA\Logging\Format\SimpleFormatter.mqh>
#include <ALARA\Logging\Append\ConsoleAppender.mqh>

#define ERROR(i,j) Print(i,j,s)
#define PRINT LOG.Print(1)
#define DEBUG Print

struct SRec {
   string level;
   string path;
   string msg;
   
   SRec operator + (const string text) { 
     this.msg = text;
     return this;
   }
};


struct SLog {
   SRec rec;
   
   SLog operator += (SRec& st_rec) { 
     this.rec = st_rec;
     Print("SLog: ", this.rec.level,", ", this.rec.path, ", ", this.rec.msg);
     return this;
   }
};

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

void OnStart() {

SRec rec = {"debug","package"};
Print("SRec: ", rec.level,", ", rec.path, ", ", rec.msg);

rec = rec + "mensagem qualquer";
Print("SRec: ", rec.level,", ", rec.path, ", ", rec.msg);


SLog log;

log += rec + "outra mensagem qualquer";

string t = Formatf("Nome = s");
Print("Resultado: ", t);


Print("__LINE__ = ", __LINE__);
Print("__FILE__ = ", __FILE__);
Print("__PATH__ = ", __PATH__);
Print("__FUNCTION__ = ", __FUNCTION__);
Print("__FUNCSIG__ = ", __FUNCSIG__);
Print("TERMINAL_PATH = ",TerminalInfoString(TERMINAL_PATH)); 
Print("TERMINAL_DATA_PATH = ",TerminalInfoString(TERMINAL_DATA_PATH)); 
Print("TERMINAL_NAME = ",TerminalInfoString(TERMINAL_NAME)); 
Print("TERMINAL_COMMONDATA_PATH = ",TerminalInfoString(TERMINAL_COMMONDATA_PATH)); 



SLogRecord srec = LogRecordDebug(__PATH__, __FUNCTION__, __LINE__);
Print("SRec: ", EnumToString(srec.level),", ", srec.timestamp, ", ", srec.package, ", ", srec.function, ", ", srec.line);


/*
string s = "111";
ERROR(1, 2);

DEBUG( 1);



enum TESTE { a, b, c };
    
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
/*
   record.timestamp = TimeCurrent();
   record.level = LOG_LEVEL_DEBUG;
   record.function = __FUNCTION__;
   record.line= __LINE__;
   record.name = __FILE__;
   record.message = "Simples teste de logging";
*/  

//CSimpleFormatter *formatter = new CSimpleFormatter(LAYOUT_TEXT_SIMPLE);
//CConsoleAppender *appender = new CConsoleAppender("", LOG_LEVEL_TRACE, formatter);

   
//   string msg = formatter.formatMessage(record);
//   Print("Mensagem formatada = ", msg);
//
//    appender.write(record);
//    
////delete(formatter);
//delete(appender);
}

//+------------------------------------------------------------------+



string Formatf(string v) {
    string u = v;
    StringToUpper(u);
    return u;
}


string Formatf(string v, string s) {
    return (v + s);
}


string Formatf(string v, string s, string fx) {
    return (v + s + fx);
}






 
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