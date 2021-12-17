//+------------------------------------------------------------------+
//|                                                   testlogger.mq4 |
//|                                Copyright 2021, Chamal Abayaratne |
//|                                      https://github.com/ChamalAB |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Chamal Abayaratne"
#property link      "https://github.com/ChamalAB"
#property version   "1.00"
#property strict

// You need to do the customization before the include statement

// Logger level customization
#define LOGGER_SET_DEBUG 1       // Print
#define LOGGER_SET_INFO  1|2     // Print and alert
#define LOGGER_SET_ERROR 1|2|4   // Print, alert and file write 

// Logger prefix custmization
#define LOGGER_PREFIX __FILE__ + " | Line:" + IntegerToString(__LINE__) // [filename] | [Line number]

// Logger file name customization
#define LOGGER_FILENAME "backtest_debug.log"
#include <Logger.mqh>


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {

    // *** NO CUSTOMIZATION ***
    DEBUG("This will not produce any action");
    INFO("This info will generate a line in the expert tab");
       
    // close non-existant trade
    if(!OrderClose(-999999,0.01,1,1))
        ERROR("This error will generate an alert with the error description instead of error number");
  
  
    // *** WITH CUSTOMIZATION ***
    DEBUG("This will not produce line in the expert tab");
    INFO("This info will generate a line in the expert tab and an alert");
   
    // close non-existant trade
    if(!OrderClose(-999999,0.01,1,1))
        ERROR("This error will generate an alert and a custom log file in Files directory");
   
  }
//+------------------------------------------------------------------+
