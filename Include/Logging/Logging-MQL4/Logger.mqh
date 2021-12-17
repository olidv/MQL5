//+------------------------------------------------------------------+
//|                                                       Logger.mqh |
//|                                Copyright 2021, Chamal Abayaratne |
//|                                      https://github.com/ChamalAB |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Chamal Abayaratne"
#property link      "https://github.com/ChamalAB"
#property strict

#include <stdlib.mqh>

//--- Logging format
// [time, except LOGGER_PRINT,LOGGER_ALERT] [level] [prefix] [message] [last error, only Logger::Error]

//--- Logging options
/*
You will not be able to able to use logging options
defines unless must be shifted to another header file that
must be included before this file
*/
#define LOGGER_PRINT    1     // print to log
#define LOGGER_ALERT    2     // trigger alert
#define LOGGER_FILE     4     // write to a file
#define LOGGER_NOTIFY   8     // send a notification


//--- Logging defaults - level configs
#ifndef LOGGER_SET_DEBUG
#define LOGGER_SET_DEBUG 0
#endif

#ifndef LOGGER_SET_INFO
#define LOGGER_SET_INFO LOGGER_PRINT
#endif

#ifndef LOGGER_SET_ERROR
#define LOGGER_SET_ERROR LOGGER_ALERT
#endif

//--- Logging defaults - Prefix
#ifndef LOGGER_PREFIX
#define LOGGER_PREFIX __FUNCTION__
#endif

//--- Logging defaults - log file name
#ifndef LOGGER_FILENAME
#define LOGGER_FILENAME "Logger.log"
#endif

//--- logging levels
#define LOGGER_DEBUG 0
#define LOGGER_INFO  1
#define LOGGER_ERROR 3

//-- Easy Functions to use
#define  DEBUG(text)  Logger::Debug(LOGGER_PREFIX,text)
#define  INFO(text) Logger::Info(LOGGER_PREFIX,text)
#define  ERROR(text) Logger::Error(LOGGER_PREFIX,text)

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Logger
  {
public:
   static void       Debug(string prefix,string msg);
   static void       Info(string prefix,string msg);
   static void       Error(string prefix,string msg);

private:
   static void       log_(int level,string msg);
   static void       file_(string msg);
   static string     prepend_time(string msg);
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Logger::Debug(string prefix,string msg)
  {
   if((LOGGER_SET_DEBUG)!=0)
      log_(LOGGER_DEBUG,StringFormat("Debug | %s | %s",prefix,msg));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Logger::Info(string prefix,string msg)
  {
   if((LOGGER_SET_INFO)!=0)
      log_(LOGGER_INFO,StringFormat("Info | %s | %s",prefix,msg));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Logger::Error(string prefix,string msg)
  {
   if((LOGGER_SET_ERROR)!=0)
      log_(LOGGER_ERROR,StringFormat("Error | %s | %s | %s",prefix,msg,ErrorDescription(GetLastError())));
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Logger::log_(int level,string msg)
  {
   int options;
   switch(level)
     {
      case LOGGER_DEBUG:
         options = LOGGER_SET_DEBUG;
         break;
      case LOGGER_INFO:
         options = LOGGER_SET_INFO;
         break;
      case LOGGER_ERROR:
         options = LOGGER_SET_ERROR;
         break;
      default:
         options = 0;
         break;
     }

   if((options & LOGGER_PRINT) == LOGGER_PRINT)
      Print(msg);

   if((options & LOGGER_ALERT) == LOGGER_ALERT)
      Alert(msg);

   if((options & LOGGER_FILE) == LOGGER_FILE)
      file_(prepend_time(msg));

   if((options & LOGGER_NOTIFY) == LOGGER_NOTIFY)
      SendNotification(prepend_time(msg));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Logger::file_(string msg)
  {
   int handle = FileOpen(LOGGER_FILENAME,FILE_READ|FILE_WRITE|FILE_TXT);
   if(handle==INVALID_HANDLE)
     {
      Print("Logger Error: Log File Open Failed");
      return;
     }

   if(!FileSeek(handle,0,SEEK_END))
     {
      Print("Logger Error: Log File Seek Failed");
      FileClose(handle);
      return;
     }

   if(FileWrite(handle,msg)==0)
     {
      Print("Logger Error: Log File Write Failed");
      FileClose(handle);
      return;
     }
   FileClose(handle);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Logger::prepend_time(string msg)
  {
   return TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS) + " | " + msg;
  }
//+------------------------------------------------------------------+
