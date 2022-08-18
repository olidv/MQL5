//+------------------------------------------------------------------+
//|                                                     OlaMundo.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

//--- Funcoes para acesso, configuracao e registro de logging.
#include <ALARA\Logging\LogManager.mqh>


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int OnInit()
   {

    LogInit("main");
    Print("Vai adicionar appender CONSOLE...");
    LogOnConsole(LOG_LEVEL_TRACE);
    Print("Vai adicionar appender FILE...");
    LogOnFile(LOG_LEVEL_TRACE, "log4mql5");
    Print("Vai adicionar appender MAIL...");
    LogOnMail(LOG_LEVEL_TRACE);
    Print("Vai adicionar appender ALERT...");
    LogOnAlert(LOG_LEVEL_ERROR);
    Print("Vai adicionar appender CHART...");
    LogOnChart(LOG_LEVEL_WARN);
    Print("Vai adicionar appender PUSH...");
    LogOnPush(LOG_LEVEL_FATAL);
    Print("Vai adicionar appender SOUND...");
    LogOnSound(LOG_LEVEL_INFO);


    /*
        Print("__LINE__ = ", __LINE__);
        Print("__FILE__ = ", __FILE__);
        Print("__PATH__ = ", __PATH__);
        Print("__FUNCTION__ = ", __FUNCTION__);
        Print("__FUNCSIG__ = ", __FUNCSIG__);
        Print("TERMINAL_PATH = ",TerminalInfoString(TERMINAL_PATH));
        Print("TERMINAL_DATA_PATH = ",TerminalInfoString(TERMINAL_DATA_PATH));
        Print("TERMINAL_NAME = ",TerminalInfoString(TERMINAL_NAME));
        Print("TERMINAL_COMMONDATA_PATH = ",TerminalInfoString(TERMINAL_COMMONDATA_PATH));
        Print("---------------------------------------------");
    */

    Sleep(5000);
    LogTrace("Este é um texto qualquer de TRACE");
    Sleep(5000);
    LogDebug("Este é um texto qualquer de DEBUG");
    Sleep(5000);
    LogInfo("Este é um texto qualquer de INFO");
    Sleep(5000);
    LogWarn("Este é um texto qualquer de WARN");
    Sleep(5000);
    LogError("Este é um texto qualquer de ERROR");
    Sleep(5000);
    LogFatal("Este é um texto qualquer de FATAL");
    Sleep(5000);
    LogInfo("Este é um texto qualquer de %s...", "teste");
    Sleep(5000);

//---
    Print("-------------------------------------------------------------------------------------------\n");
    return(INIT_SUCCEEDED);
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
    LogDeinit();
   }


//+------------------------------------------------------------------+
