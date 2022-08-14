/*
 * MIT License
 *
 * Log4Mql5  .:.  https://github.com/olidv/Log4Mql5
 * Copyright (c) 2021 by Oliveira Developer at Brazil
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
*/
#property library

//--- Injecao das dependencias.
#include "Logger.mqh"


//+------------------------------------------------------------------+
//| Lib LogManager.                                                  |
//|                                                                  |
//| Usage: Relacao de funcoes para manipulacao e configuração da     |
//|        da classe CLogger e suas dependencias.                    |
//+------------------------------------------------------------------+

//--- Apenas uma instancia eh utilizada por programas em execucao:
CLogger *LOG = new CLogger();


//+------------------------------------------------------------------+
// Inicializa os parametros internos do logger LOG.                  |
//+------------------------------------------------------------------+
void LogInit(const string name) export
   {
    LOG.setName(name);
   }


//+------------------------------------------------------------------+
//| Encerra os recursos alocados e fecha appenders, se necessario.   |
//+------------------------------------------------------------------+
void LogDeinit() export
   {
    delete(LOG);
    LOG = NULL;
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo ConsoleAppender ao logger LOG.    |
//+------------------------------------------------------------------+
void LogOnConsole(const ENUM_LOG_LEVEL level) export
   {
    LOG.addConsoleAppender(level);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo AlertAppender ao logger LOG.    |
//+------------------------------------------------------------------+
void LogOnAlert(const ENUM_LOG_LEVEL level) export
   {
    LOG.addAlertAppender(level);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo ChartAppender ao logger LOG.      |
//+------------------------------------------------------------------+
void LogOnChart(const ENUM_LOG_LEVEL level) export
   {
    LOG.addChartAppender(level);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo PushAppender ao logger LOG.       |
//+------------------------------------------------------------------+
void LogOnPush(const ENUM_LOG_LEVEL level) export
   {
    LOG.addPushAppender(level);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo MailAppender ao logger LOG.       |
//+------------------------------------------------------------------+
void LogOnMail(const ENUM_LOG_LEVEL level) export
   {
    LOG.addMailAppender(level);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo FileAppender ao logger LOG.       |
//+------------------------------------------------------------------+
void LogOnFile(const ENUM_LOG_LEVEL level, const string fileName) export
   {
    LOG.addFileAppender(level, fileName);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo SoundAppender ao logger LOG.       |
//+------------------------------------------------------------------+
void LogOnSound(const ENUM_LOG_LEVEL level) export
   {
    LOG.addSoundAppender(level);
   }


//+------------------------------------------------------------------+
//| Obtem o nome/identificacao do logger.                            |
//+------------------------------------------------------------------+
string LogName() export
   {
    return LOG.getName();
   }


//+------------------------------------------------------------------+
//| Obtem o nivel de logging entre os appenders internos de LOG.     |
//+------------------------------------------------------------------+
ENUM_LOG_LEVEL LogLevel() export
   {
    return LOG.getLevel();
   }


//+------------------------------------------------------------------+
//| Verifica se algum appender ira printar o nivel de logging TRACE. |
//+------------------------------------------------------------------+
bool isTraceEnabled() export
   {
    return LOG.getLevel() <= LOG_LEVEL_TRACE;
   }


//+------------------------------------------------------------------+
//| Verifica se algum appender ira printar o nivel de logging DEBUG. |
//+------------------------------------------------------------------+
bool isDebugEnabled() export
   {
    return LOG.getLevel() <= LOG_LEVEL_DEBUG;
   }


//+------------------------------------------------------------------+
//| Verifica se algum appender ira printar o nivel de logging INFO. |
//+------------------------------------------------------------------+
bool isInfoEnabled() export
   {
    return LOG.getLevel() <= LOG_LEVEL_INFO;
   }


//+------------------------------------------------------------------+
//| Verifica se algum appender ira printar o nivel de logging WARN. |
//+------------------------------------------------------------------+
bool isWarnEnabled() export
   {
    return LOG.getLevel() <= LOG_LEVEL_WARN;
   }


//+------------------------------------------------------------------+
//| Verifica se algum appender ira printar o nivel de logging ERROR. |
//+------------------------------------------------------------------+
bool isErrorEnabled() export
   {
    return LOG.getLevel() <= LOG_LEVEL_ERROR;
   }


//+------------------------------------------------------------------+
//| Verifica se algum appender ira printar o nivel de logging FATAL. |
//+------------------------------------------------------------------+
bool isFatalEnabled() export
   {
    return LOG.getLevel() <= LOG_LEVEL_FATAL;
   }


//+------------------------------------------------------------------+
//| Facilita a utilizacao do logging com macros representativas.     |
//+------------------------------------------------------------------+
#define LogTrace  if(isTraceEnabled()) LOG += LogRecordTrace(__PATH__, __FILE__, __FUNCTION__, __LINE__) +
#define LogTracef if(isTraceEnabled()) LOG += LogRecordTrace(__PATH__, __FILE__, __FUNCTION__, __LINE__) + StringFormat

#define LogDebug  if(isDebugEnabled()) LOG += LogRecordDebug(__PATH__, __FILE__, __FUNCTION__, __LINE__) +
#define LogDebugf if(isDebugEnabled()) LOG += LogRecordDebug(__PATH__, __FILE__, __FUNCTION__, __LINE__) + StringFormat

#define LogInfo   if(isInfoEnabled())  LOG += LogRecordInfo(__PATH__, __FILE__, __FUNCTION__, __LINE__) +
#define LogInfof  if(isInfoEnabled())  LOG += LogRecordInfo(__PATH__, __FILE__, __FUNCTION__, __LINE__) + StringFormat

#define LogWarn   if(isWarnEnabled())  LOG += LogRecordWarn(__PATH__, __FILE__, __FUNCTION__, __LINE__) +
#define LogWarnf  if(isWranEnabled())  LOG += LogRecordWarn(__PATH__, __FILE__, __FUNCTION__, __LINE__) + StringFormat

#define LogError  if(isErrorEnabled()) LOG += LogRecordError(__PATH__, __FILE__, __FUNCTION__, __LINE__) +
#define LogErrorf if(isErrorEnabled()) LOG += LogRecordError(__PATH__, __FILE__, __FUNCTION__, __LINE__) + StringFormat

#define LogFatal  if(isFatalEnabled()) LOG += LogRecordFatal(__PATH__, __FILE__, __FUNCTION__, __LINE__) +
#define LogFatalf if(isFatalEnabled()) LOG += LogRecordFatal(__PATH__, __FILE__, __FUNCTION__, __LINE__) + StringFormat


//+------------------------------------------------------------------+
