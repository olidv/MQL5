//+------------------------------------------------------------------+
//|                                                  testclogger.mq5 |
//|                                                             ProF |
//|                                                          http:// |
//+------------------------------------------------------------------+
#property copyright "ProF"
#property link      "http://"
#property version   "1.00"

#include <Clogger.mqh>

CLogger logger;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   logger.SetSetting("proj","lfile");        // Settings
   logger.init();                            // Initialization
   logger.write("Start script","system");
   for(int i=0;i<100000;i++)                 // Write 100000 messages to the log
     {
      logger.write("log: "+(string)i,"Comment",100,222,100,__FILE__,__LINE__);
     }
   logger.write("Stop script","system");
   logger.flush();                           // Flush buffer
   logger.deinit();                          // Deinitialization
  }
//+------------------------------------------------------------------+
