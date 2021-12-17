//+------------------------------------------------------------------+
//|                                                   log4mqllib.mqh |
//|                                    Copyright 2020, Jens Lippmann |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Jens Lippmann"
#property link      "https://www.mql5.com/en/users/lippmaje"
#property strict

/*
 Copyright notice:

    This file is part of Log4mql.

    Log4mql is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Log4mql is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Log4mql.  If not, see "https://www.gnu.org/licenses/".
    

 Official location:  
    MQL5 Codebase https://www.mql5.com/en/code/31425 Log4mql(MT4)
    MQL5 Codebase https://www.mql5.com/en/code/31452 Log4mql(MT5)
*/

//+------------------------------------------------------------------+
//| enum ENUM_LOG_LEVEL                                              |
//+------------------------------------------------------------------+
enum ENUM_LOG_LEVEL
  {
   LOGLEVEL_OFF   =   0,             // Off
   LOGLEVEL_FATAL = 100,             // Fatal
   LOGLEVEL_ERROR = 200,             // Error
   LOGLEVEL_WARN  = 300,             // Warn
   LOGLEVEL_INFO  = 400,             // Info
   LOGLEVEL_DEBUG = 500,             // Debug
   LOGLEVEL_TRACE = 600,             // Trace
   LOGLEVEL_ALL   = INT_MAX          // All
  };

//+------------------------------------------------------------------+
//| enum ENUM_LOG_MODE                                               |
//+------------------------------------------------------------------+
enum ENUM_LOG_MODE
  {
   LOG_MODE_CONSOLE,                 // Journal only
   LOG_MODE_CONSFILE_APPEND,         // File append&Journal
   LOG_MODE_CONSFILE_REWRITE,        // File rewrite&Journal
   LOG_MODE_FILE_APPEND,             // File only, append
   LOG_MODE_FILE_REWRITE             // File only, rewrite
  };

//+------------------------------------------------------------------+
//| enum ENUM_LOGFILE_TXTMODE                                        |
//+------------------------------------------------------------------+
enum ENUM_LOGFILE_TXTMODE
  {
   LOGFILEMODE_ANSI = FILE_ANSI,     // Ansi 8-bit
   LOGFILEMODE_UNI  = FILE_UNICODE   // Unicode 16-bit
  };

//+------------------------------------------------------------------+
//| enum ENUM_LOG_ROLLMODE                                           |
//+------------------------------------------------------------------+
enum ENUM_LOG_ROLLMODE
  {
   LOG_ROLLMODE_OFF = 0,             // roll-over off
   LOG_ROLLMODE_DAILY,               // daily
   LOG_ROLLMODE_100K,                // size 100K
  };

#ifdef __MQL4__
#import "log4mqllib.ex4"
#else
#import "log4mqllib.ex5"
#endif
void Logger_Log(int handle,ENUM_LOG_LEVEL level,string func,string funcsig,string file,int line,string msg,int lerr);
int  LogManager_Init(ENUM_LOG_LEVEL loglevel,ENUM_LOG_MODE logmode,string logpattern,string logfilespec,ENUM_LOGFILE_TXTMODE filetxtmode,ENUM_LOG_ROLLMODE logrollmode,string rollfilespec);
void LogManager_Deinit(int handle=0);
bool LogManager_Exists(int handle,string name);
int  LogManager_GetLogger(int handle,string sig,string id=NULL);
int  LogManager_GetRootLogger(int handle);
#import

//+------------------------------------------------------------------+
//| interface ILoggerInterface                                       |
//+------------------------------------------------------------------+
interface ILoggerInterface
  {
   bool              Assert(ENUM_LOG_LEVEL level,string func,string funcsig,string file,int line,bool cond,string text=NULL);
   ENUM_LOG_LEVEL    GetLevel();
   string            GetName();
   bool              IsEnabled(ENUM_LOG_LEVEL level);
   void              Log(ENUM_LOG_LEVEL level,string func,string funcsig,string file,int line,string msg,int lerr);
   void              LogFatal(string func,string funcsig,string file,int line,string msg,int lerr);
   void              LogError(string func,string funcsig,string file,int line,string msg,int lerr);
   void              LogWarn(string func,string funcsig,string file,int line,string msg,int lerr);
   void              LogInfo(string func,string funcsig,string file,int line,string msg,int lerr);
   void              LogDebug(string func,string funcsig,string file,int line,string msg,int lerr);
   void              LogTrace(string func,string funcsig,string file,int line,string msg,int lerr);
   void              TraceEntry(string func,string funcsig,string file,int line,string msg,int lerr);
   void              TraceExit(string func,string funcsig,string file,int line,string msg,int lerr);
  };

//+------------------------------------------------------------------+
//| class CLogger                                                    |
//+------------------------------------------------------------------+
class CLogger : public ILoggerInterface
  {
protected:
   bool              m_isactive;

public:
   void              LOG_FATAL(string msg)  {}
   void              LOG_ERROR(string msg)  {}
   void              LOG_WARN(string msg)   {}
   void              LOG_INFO(string msg)   {}
   void              LOG_DEBUG(string msg)  {}
   void              LOG_TRACE(string msg)  {}
   void              TRACE_ENTRY(void)      {}
   void              TRACE_EXIT(void)       {}
   void              TRACE_ENTRY(string msg){}
   void              TRACE_EXIT(string msg) {}

#define ASSERT(cond)     Logger.Assert(LOGLEVEL_ERROR,__FUNCTION__,__FUNCSIG__,__FILE__,__LINE__,cond,#cond)
#define LOG_(level,msg)  Logger.Log(level,__FUNCTION__,__FUNCSIG__,__FILE__,__LINE__,msg,_LastError)
#define LOG_FATAL(msg)   LOG_(LOGLEVEL_FATAL,msg)
#define LOG_ERROR(msg)   LOG_(LOGLEVEL_ERROR,msg)
#define LOG_WARN(msg)    LOG_(LOGLEVEL_WARN,msg)
#define LOG_INFO(msg)    LOG_(LOGLEVEL_INFO,msg)
#define LOG_DEBUG(msg)   LOG_(LOGLEVEL_DEBUG,msg)
#define LOG_TRACE(msg)   LOG_(LOGLEVEL_TRACE,msg)
#define TRACE_ENTRY(msg) Logger.TraceEntry(__FUNCTION__,__FUNCSIG__,__FILE__,__LINE__,string(msg),_LastError)
#define TRACE_EXIT(msg)  Logger.TraceExit (__FUNCTION__,__FUNCSIG__,__FILE__,__LINE__,string(msg),_LastError)

   ILoggerInterface  *Logger;
                     CLogger(ILoggerInterface *logger)
     {
      this.Logger=logger;
      m_isactive=true;
     }

   // LoggerInterface
   ENUM_LOG_LEVEL    GetLevel()
     {
      return this.Logger.GetLevel();
     }
   string            GetName()
     {
      return this.Logger.GetName();
     }
   bool              IsEnabled(ENUM_LOG_LEVEL level)
     {
      return this.Logger.IsEnabled(level);
     }
   bool              Assert(ENUM_LOG_LEVEL level,string func,string funcsig,string file,int line,bool cond,string text)
     {
      return this.Logger.Assert(level,func,funcsig,file,line,cond,text);
     }
   void              Log(ENUM_LOG_LEVEL loglevel,string func,string funcsig,string file,int line,string msg,int lerr)
     {
      if(m_isactive)
         this.Logger.Log(loglevel,func,funcsig,file,line,msg,lerr);
     }
   void              LogFatal(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      if(m_isactive)
         this.Logger.LogFatal(func,funcsig,file,line,msg,lerr);
     }
   void              LogError(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      if(m_isactive)
         this.Logger.LogError(func,funcsig,file,line,msg,lerr);
     }
   void              LogWarn(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      if(m_isactive)
         this.Logger.LogWarn(func,funcsig,file,line,msg,lerr);
     }
   void              LogInfo(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      if(m_isactive)
         this.Logger.LogInfo(func,funcsig,file,line,msg,lerr);
     }
   void              LogDebug(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      if(m_isactive)
         this.Logger.LogDebug(func,funcsig,file,line,msg,lerr);
     }
   void              LogTrace(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      if(m_isactive)
         this.Logger.LogTrace(func,funcsig,file,line,msg,lerr);
     }
   void              TraceEntry(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      if(m_isactive)
         this.Logger.TraceEntry(func,funcsig,file,line,msg,lerr);
     }
   void              TraceExit(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      if(m_isactive)
         this.Logger.TraceExit(func,funcsig,file,line,msg,lerr);
     }
   // /LoggerInterface
  };

//+------------------------------------------------------------------+
//| class CLoggerProxy                                               |
//+------------------------------------------------------------------+
class CLoggerProxy : public ILoggerInterface
  {
protected:
   string            m_name;
   ENUM_LOG_LEVEL    m_loglevel;
public:
                     CLoggerProxy(string name,ENUM_LOG_LEVEL level) : m_name(name),m_loglevel(level) {}
   // LoggerInterface
   virtual ENUM_LOG_LEVEL  GetLevel() { return m_loglevel; }
   virtual string    GetName() { return m_name; }
   virtual bool      IsEnabled(ENUM_LOG_LEVEL level) { return level<=m_loglevel; }

   virtual bool      Assert(ENUM_LOG_LEVEL level,string func,string funcsig,string file,int line,bool cond,string text=NULL)
     {
      if(!cond)
        {
         Log(level,func,funcsig,file,line,"assertion failed"+(StringLen(text)?": "+text:""),_LastError);
        }
      return cond;
     }
   virtual void      Log(ENUM_LOG_LEVEL level,string func,string funcsig,string file,int line,string msg,int lerr)
     {
      if(level<=m_loglevel)
        {
         Print(StringSubstr(EnumToString(level),9)," ",func,"(",file,":",line,") ",msg,(lerr?" (error "+string(lerr)+")":""));
        }
     }
   virtual void      LogFatal(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      Log(LOGLEVEL_FATAL,func,funcsig,file,line,msg,lerr);
     }
   virtual void      LogError(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      Log(LOGLEVEL_ERROR,func,funcsig,file,line,msg,lerr);
     }
   virtual void      LogWarn(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      Log(LOGLEVEL_WARN,func,funcsig,file,line,msg,lerr);
     }
   virtual void      LogInfo(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      Log(LOGLEVEL_INFO,func,funcsig,file,line,msg,lerr);
     }
   virtual void      LogDebug(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      Log(LOGLEVEL_DEBUG,func,funcsig,file,line,msg,lerr);
     }
   virtual void      LogTrace(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      Log(LOGLEVEL_TRACE,func,funcsig,file,line,msg,lerr);
     }
   virtual void      TraceEntry(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      Log(LOGLEVEL_TRACE,func,funcsig,file,line,(StringLen(msg) ? "Enter "+msg : "Enter"),lerr);
     }
   virtual void      TraceExit(string func,string funcsig,string file,int line,string msg,int lerr)
     {
      Log(LOGLEVEL_TRACE,func,funcsig,file,line,(StringLen(msg) ? "Exit with ("+msg+")" : "Exit"),lerr);
     }
   // /LoggerInterface
  };

//+------------------------------------------------------------------+
//| class CLogRouter                                                 |
//+------------------------------------------------------------------+
class CLogRouter : public CLoggerProxy
  {
protected:
   int               m_handle;
   string            m_classname;
   string            m_srcfilename;

public:
                     CLogRouter(string name,string classname,string srcfilename,ENUM_LOG_LEVEL level,int handle) : CLoggerProxy(name,level)
     {
      m_handle=handle;
      m_classname=classname;
      m_srcfilename=srcfilename;
     };

   virtual void      Log(ENUM_LOG_LEVEL level,string func,string funcsig,string file,int line,string msg,int lerr) override
     {
      if(level<=m_loglevel)
        {
         Logger_Log(m_handle,level,func,funcsig,file,line,msg,lerr);
        }
     }

   virtual void      TraceEntry(string func,string funcsig,string file,int line,string msg,int lerr) override
     {
      if(LOGLEVEL_TRACE<=m_loglevel)
        {
         Logger_Log(m_handle,LOGLEVEL_TRACE,func,funcsig,file,line,(StringLen(msg) ? "Enter "+msg : "Enter"),lerr);
        }
     }

   virtual void      TraceExit(string func,string funcsig,string file,int line,string msg,int lerr) override
     {
      if(LOGLEVEL_TRACE<=m_loglevel)
        {
         Logger_Log(m_handle,LOGLEVEL_TRACE,func,funcsig,file,line,(StringLen(msg) ? "Exit with ("+msg+")" : "Exit"),lerr);
        }
     }
  };

//+------------------------------------------------------------------+
//| class CLogManager                                                |
//+------------------------------------------------------------------+
class CLogManager
  {
protected:
   int               m_myhandle;
   string            m_srcfilename;
   string            m_srcfilepath;
   int               m_loghandles[];
   CLogger           *m_loggers[];
   CLogRouter        *m_logrouters[];
   CLogger           *m_rootlogger;
   ENUM_LOG_LEVEL    m_loglevel;
   ENUM_LOG_MODE     m_logmode;
   string            m_logpattern;
   string            m_logfilespec;
   ENUM_LOGFILE_TXTMODE m_filetxtmode;
   ENUM_LOG_ROLLMODE m_filerollmode;
   string            m_rollfilespec;
   string            GetClassNameFromSig(string funcsig)
     {
      int i=StringFind(funcsig,"::");
      if(i==-1)
         return "";
      int len=0;
      while(--i>0 && funcsig[i]!=' ')
         len++;
      return StringSubstr(funcsig,i+1,len);
     }

public:
   void              GET_LOGGER(void)     {}
   void              GET_LOGGER(string id){}
#define GET_LOGGER(id)   LogManager.GetLogger(__FILE__+"::"+__FUNCSIG__,#id)

   CLogManager       *LogManager;
                     CLogManager(CLoggerProxy *&logger,ENUM_LOG_LEVEL loglevel,ENUM_LOG_MODE logmode,string logpattern,string logfilespec,ENUM_LOGFILE_TXTMODE filetxtmode,ENUM_LOG_ROLLMODE filerollmode,string rollfilespec)
     {
      ResetLastError();
      LogManager=GetPointer(this);
      m_loglevel=loglevel;
      m_logmode=logmode;
      m_logpattern=logpattern;
      m_logfilespec=logfilespec;
      m_filetxtmode=filetxtmode;
      m_filerollmode=filerollmode;
      m_rollfilespec=rollfilespec;
      CLoggerProxy *bootlogger=new CLoggerProxy("boot",LOGLEVEL_INFO);
      CLoggerProxy *prevproxy=logger;
      logger=bootlogger;
      m_srcfilename=MQLInfoString(MQL_PROGRAM_NAME);
      m_srcfilepath=MQLInfoString(MQL_PROGRAM_PATH);
      string name="root";
      string classname="";
      m_myhandle=LogManager_Init(m_loglevel,m_logmode,m_logpattern,m_logfilespec,m_filetxtmode,m_filerollmode,m_rollfilespec);
      int loghandle=LogManager_GetRootLogger(m_myhandle);
      logger=new CLogRouter(name,classname,m_srcfilename,m_loglevel,loghandle);
      m_rootlogger=new CLogger(logger);
      if(CheckPointer(bootlogger)==POINTER_DYNAMIC)
        {
         delete bootlogger;
        }
      //m_rootlogger.LOG_DEBUG("Log session started");
     }

                    ~CLogManager()
     {
      //m_rootlogger.LOG_TRACE("deallocating "+string(ArraySize(m_loggers))+" loggers");
      for(int i=ArraySize(m_loggers)-1; i>=0; i--)
        {
         delete m_loggers[i];
        }
      for(int i=ArraySize(m_logrouters)-1; i>=0; i--)
        {
         delete m_logrouters[i];
        }
      //m_rootlogger.LOG_DEBUG("Log session (lib) stopped");
      delete m_rootlogger.Logger;
      delete m_rootlogger;
      LogManager_Deinit(m_myhandle);
     }

   bool               Exists(string name)
     {
      return LogManager_Exists(m_myhandle,name);
     }

   CLogger           *GetLogger(string sig,string id=NULL)
     {
      ResetLastError();
      string name=id;
      if(name==NULL)
        {
         name=sig;
        }
      else
         if(name=="")
           {
            string filename="";
            int pos=StringFind(sig,"::");
            if(pos>0)
              {
               filename=StringSubstr(sig,0,pos);
               string ssig=StringSubstr(sig,pos+2);
               name=GetClassNameFromSig(ssig);
              }
           }
      if(StringLen(name)==0)
        {
         // get root logger if name is set but empty
         return m_rootlogger;
        }
      string classname=name;
      int loghandle=LogManager_GetLogger(m_myhandle,sig,id);
      int size=ArraySize(m_loghandles);
      int i=size;
      while(--i>=0 && m_loghandles[i]!=loghandle);
      if(i<0)
        {
         CLogRouter *logrouter=new CLogRouter(name,classname,m_srcfilename,m_loglevel,loghandle);
         CLogger *logger=new CLogger(logrouter);
         i=size;
         ArrayResize(m_loghandles,size+1);
         ArrayResize(m_loggers,size+1);
         ArrayResize(m_logrouters,size+1);
         m_loghandles[i]=loghandle;
         m_loggers[i]=logger;
         m_logrouters[i]=logrouter;
        }
      return m_loggers[i];
     }

   CLogger           *GetRootLogger()
     {
      return m_rootlogger;
     }
  };

//+------------------------------------------------------------------+
//| Globals                                                          |
//+------------------------------------------------------------------+
CLoggerProxy *Logger;
//+------------------------------------------------------------------+
