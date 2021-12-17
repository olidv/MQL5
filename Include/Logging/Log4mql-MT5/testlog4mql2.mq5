//+------------------------------------------------------------------+
//|                                                 testlog4mql2.mq5 |
//|                                    Copyright 2020, Jens Lippmann |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Jens Lippmann"
#property link      "https://www.mql5.com/en/users/lippmaje"
#property version   "1.00"
#property strict

/*
    More usages example of Log4mql
    ---

    Step 1:
     - put log4mqllib.mqh into the Include folder and log4mqllib.ex4 into the Libraries folder
     - include the header file in your code like below

    Step 2:
     - place the input section (and the LogManager variable) next to your inputs

    Step 3:
     - use LOG_TRACE, LOG_DEBUG, LOG_INFO, LOG_WARN, LOG_ERROR, or LOG_FATAL like below
     
    For classes it's advised to use an own logger for each class, see CTest/CTest2 how to do it.

    Note, the GET_LOGGER macro requires a method to run within.
    If you need to define a logger outside a class, use:
       CLogger *logger = LogManager.GetLogger(my_id);

    (For an example see the TestStatic logger below.)

    Methods available for a logger:
      ENUM_LOG_LEVEL GetLevel()
      string         GetName()
      bool           IsEnabled(ENUM_LOG_LEVEL level)
      bool           ASSERT(condition)
      void           LOG_TRACE(string)
      void           LOG_DEBUG(string)
      void           LOG_INFO(string)
      void           LOG_WARN(string)
      void           LOG_ERROR(string)
      void           LOG_FATAL(string)
      void           TRACE_ENTRY(string)
      void           TRACE_EXIT(string)
*/

#include <log4mqllib.mqh>

//+------------------------------------------------------------------+
//| class CTest                                                      |
//+------------------------------------------------------------------+
class CTest
  {
private:
   CLogger           *m_logger;
public:
                     CTest(string name=NULL)
     {
      m_logger=GET_LOGGER();
     }
   void              DoSomething()
     {
      m_logger.LOG_INFO("called");
     }
  };

//+------------------------------------------------------------------+
//| class CTest2                                                     |
//+------------------------------------------------------------------+
class CTest2 : public CTest
  {
private:
   CLogger           *m_logger;
public:
                     CTest2()
     {
      m_logger=GET_LOGGER();
     }
   void              DoSomethingMore()
     {
      m_logger.TRACE_ENTRY();
      m_logger.LOG_INFO("doing something");
      DoSomething();
      m_logger.TRACE_EXIT();
     }
  };


//+------------------------------------------------------------------+
//| class CTestStatic                                                |
//+------------------------------------------------------------------+
class CTestStatic
  {
private:
   static CLogger    *s_Logger;
public:
   static void       StaticMethod()
     {
      s_Logger.LOG_INFO("called");
     }
  };

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
sinput ENUM_LOG_LEVEL       InpLogLevel       = LOGLEVEL_TRACE;            // Loglevel
sinput ENUM_LOG_MODE        InpLogMode        = LOG_MODE_CONSFILE_APPEND;  // Logmode
sinput string               InpLogPattern     = "%-5level %method - %msg"; // Message pattern
sinput string               InpLogFileSpec    = "%prgname";                // Logfile name
sinput ENUM_LOGFILE_TXTMODE InpLogFileTxtMode = LOGFILEMODE_ANSI;          // Logfile text mode
sinput ENUM_LOG_ROLLMODE    InpLogFileRoll    = LOG_ROLLMODE_DAILY;        // Logfile roll policy
sinput string               InpRollFileSpec   = "%prgname-%02i";           // File roll pattern
CLogManager   LogManager(Logger,InpLogLevel,InpLogMode,InpLogPattern,InpLogFileSpec,InpLogFileTxtMode,InpLogFileRoll,InpRollFileSpec);

CLogger *CTestStatic::s_Logger = LogManager.GetLogger("CTestStatic");

CTest2 Test;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   TRACE_ENTRY();
   Test.DoSomethingMore();
   CTestStatic::StaticMethod();
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
