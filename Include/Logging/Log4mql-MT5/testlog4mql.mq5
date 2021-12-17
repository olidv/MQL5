//+------------------------------------------------------------------+
//|                                                  testlog4mql.mq5 |
//|                                    Copyright 2020, Jens Lippmann |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Jens Lippmann"
#property link      "https://www.mql5.com/en/users/lippmaje"
#property version   "1.00"
#property strict

/*
    Simple usage example of Log4mql
    ---

    Step 1:
     - put log4mqllib.mqh into the Include folder and log4mqllib.ex4 into the Libraries folder
     - include the header file in your code like below

    Step 2:
     - place the input section (and the LogManager variable) next to your inputs

    Step 3:
     - use LOG_TRACE, LOG_DEBUG, LOG_INFO, LOG_WARN, LOG_ERROR, or LOG_FATAL like below
     - that's it

    If you need more loggers, use:
       CLogger *logger = GET_LOGGER();
       logger.LOG_DEBUG("debugging");
       logger.LOG_INFO("some info");

    See also the other sample code for more complex usages.
*/

#include <log4mqllib.mqh>

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
sinput ENUM_LOG_LEVEL       InpLogLevel       = LOGLEVEL_INFO;             // Loglevel
sinput ENUM_LOG_MODE        InpLogMode        = LOG_MODE_CONSFILE_APPEND;  // Logmode
sinput string               InpLogPattern     = "%-5level %method - %msg"; // Message pattern
sinput string               InpLogFileSpec    = "%prgname";                // Logfile name
sinput ENUM_LOGFILE_TXTMODE InpLogFileTxtMode = LOGFILEMODE_ANSI;          // Logfile text mode
sinput ENUM_LOG_ROLLMODE    InpLogFileRoll    = LOG_ROLLMODE_DAILY;        // Logfile roll policy
sinput string               InpRollFileSpec   = "%prgname-%02i";           // File roll pattern
CLogManager   LogManager(Logger,InpLogLevel,InpLogMode,InpLogPattern,InpLogFileSpec,InpLogFileTxtMode,InpLogFileRoll,InpRollFileSpec);


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   TRACE_ENTRY();
   LOG_INFO("Log level: "+EnumToString(InpLogLevel));
   LOG_INFO("Log pattern: "+InpLogPattern);
   TRACE_EXIT();
   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   TRACE_ENTRY();
   LOG_INFO("Deinit reason: "+string(reason));
   TRACE_EXIT();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   MqlTick tick;
   SymbolInfoTick(_Symbol,tick);
   LOG_DEBUG("quitting at: "+string(TimeCurrent())+" symbol: "+_Symbol+" bid: "+DoubleToString(tick.bid,_Digits));
   ExpertRemove();
  }
//+------------------------------------------------------------------+
