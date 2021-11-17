/*
===============================================================================

 package: MQL5\Include\_ALARA

 module : Logger.mqh
 
===============================================================================
*/
#property copyright   "Copyright 2021, ALARA Investimentos"
#property link        "http://www.alara.com.br"
#property version     "1.00"
#property description ""
#property description ""

#property library

//+------------------------------------------------------------------+
//| Enumeration para nivels de logging.                              |
//+------------------------------------------------------------------+
enum SLOG_LEVEL {
    ALL   = 0,
    
    TRACE = 1,
    DEBUG = 2,
    INFO  = 3,
    WARN  = 4,
    ERROR = 5,
    FATAL = 6,
    
    NONE  = 10
};
  
//--- O comportamento default eh logar tudo...
SLOG_LEVEL  _level = ALL;

//+------------------------------------------------------------------+
//| Define o nivel atual de logging.                                 |
//+------------------------------------------------------------------+
void Log_SetLevel(const SLOG_LEVEL value) {
    _level = value;
}

//+------------------------------------------------------------------+
//| Funcoes para printar logging na console (aba Experts), por nivel.|
//| Apos fechar o MT5, o loging eh salvo em arquivo.                 |
//+------------------------------------------------------------------+

void Log_Trace(const string msg, const string funcName = NULL, const int lineNumber = NULL) {
    //--- verifica se pode logar neste nivel
    if (_level > TRACE) return;
    
    //--- formata o local da chamada do logging
    Print("TRACE ", _formatLocal(funcName, lineNumber), msg);
}

void Log_Debug(const string msg, const string funcName = NULL, const int lineNumber = NULL) {
    //--- verifica se pode logar neste nivel
    if (_level > DEBUG) return;
    
    //--- formata o local da chamada do logging
    Print("DEBUG ", _formatLocal(funcName, lineNumber), msg);
}

void Log_Info(const string msg, const string funcName = NULL, const int lineNumber = NULL) {
    //--- verifica se pode logar neste nivel
    if (_level > INFO) return;
    
    //--- formata o local da chamada do logging
    Print("INFO  ", _formatLocal(funcName, lineNumber), msg);
}

void Log_Warn(const string msg, const string funcName = NULL, const int lineNumber = NULL) {
    //--- verifica se pode logar neste nivel
    if (_level > WARN) return;
    
    //--- formata o local da chamada do logging
    Print("WARN  ", _formatLocal(funcName, lineNumber), msg);
}

void Log_Error(const string msg, const string funcName = NULL, const int lineNumber = NULL) {
    //--- verifica se pode logar neste nivel
    if (_level > ERROR) return;
    
    //--- formata o local da chamada do logging
    Print("ERROR ", _formatLocal(funcName, lineNumber), msg);
}

void Log_Fatal(const string msg, const string funcName = NULL, const int lineNumber = NULL) {
    //--- verifica se pode logar neste nivel
    if (_level > FATAL) return;
    
    //--- formata o local da chamada do logging
    Print("FATAL ", _formatLocal(funcName, lineNumber), msg);
}

//+------------------------------------------------------------------+
//| Formata o local da chamada do logging.                           |
//+------------------------------------------------------------------+
string _formatLocal(const string funcName = NULL, const int lineNumber = NULL) {
    //--- 
    string local = "";
    if (funcName != NULL || lineNumber != NULL) {
        local = "{" + 
                ((funcName == NULL) ? "" : funcName) + 
                ((lineNumber == NULL) ? "" : ":" + IntegerToString(lineNumber)) + 
                "} ";
    }
    
    return local;
}

//+------------------------------------------------------------------+
