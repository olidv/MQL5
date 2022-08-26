/*
 ***********************************************************************************************
 Este programa de  computador contem informacoes  confidenciais de propriedade da ALARA CAPITAL,
 e esta  protegido pela lei de copyright. Voce nao  deve divulgar tais informacoes confidenciais 
 e  deve usa-las somente em  conformidade com os termos  do contrato de licenca  definidos  pela 
 ALARA CAPITAL. A reproducao ou distribuicao nao autorizada deste programa, ou de qualquer parte
 dele,  resultara na  imposicao de  rigorosas penas  civis e  criminais,  e sera  objeto de acao 
 judicial promovida na maxima extensao possivel, nos termos da lei.

 Parte integrante do repositorio de componentes, rotinas e artefatos  criados pela ALARA CAPITAL
 para o desenvolvimento de Trading Algorítmico na plataforma MetaQuotes MetaTrader for Desktop.
 ***********************************************************************************************
*/
#property copyright    "Copyright (C) 2020-2022, ALARA CAPITAL. Todos os direitos reservados."
#property link         "https://www.Alara.com.BR/"

//program file         LogManager.mqh
//program package      MQL5/Include/ALARA/Logging/
#property version	   "1.000"
#property description  "..."

//**********************************************************************************************  

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
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
void LogOnConsole(const ELogLevel level) export
   {
    LOG.addConsoleAppender(level);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo AlertAppender ao logger LOG.    |
//+------------------------------------------------------------------+
void LogOnAlert(const ELogLevel level) export
   {
    LOG.addAlertAppender(level);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo ChartAppender ao logger LOG.      |
//+------------------------------------------------------------------+
void LogOnChart(const ELogLevel level) export
   {
    LOG.addChartAppender(level);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo PushAppender ao logger LOG.       |
//+------------------------------------------------------------------+
void LogOnPush(const ELogLevel level) export
   {
    LOG.addPushAppender(level);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo MailAppender ao logger LOG.       |
//+------------------------------------------------------------------+
void LogOnMail(const ELogLevel level) export
   {
    LOG.addMailAppender(level);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo FileAppender ao logger LOG.       |
//+------------------------------------------------------------------+
void LogOnFile(const ELogLevel level, const string fileName) export
   {
    LOG.addFileAppender(level, fileName);
   }


//+------------------------------------------------------------------+
//| Adiciona novo appender do tipo SoundAppender ao logger LOG.       |
//+------------------------------------------------------------------+
void LogOnSound(const ELogLevel level) export
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
ELogLevel LogLevel() export
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
//| Funcoes para formatacao, delegate para StringFormat().           |
//+------------------------------------------------------------------+
//--- Sem parametros de formatacao.
string LogFormat(const string msg) { return msg; }

//--- Formatacao com 1 parametro.
template<typename T1>
string LogFormat(const string msg, T1 p1) { return StringFormat(msg,p1); }

//--- Formatacao com 2 parametros.
template<typename T1, typename T2>
string LogFormat(const string msg, T1 p1, T2 p2) { return StringFormat(msg,p1,p2); }

//--- Formatacao com 3 parametros.
template<typename T1, typename T2, typename T3>
string LogFormat(const string msg, T1 p1, T2 p2, T3 p3) { return StringFormat(msg,p1,p2,p3); }

//--- Formatacao com 4 parametros.
template<typename T1, typename T2, typename T3, typename T4>
string LogFormat(const string msg, T1 p1, T2 p2, T3 p3, T4 p4) { return StringFormat(msg,p1,p2,p3,p4); }

//--- Formatacao com 5 parametros.
template<typename T1, typename T2, typename T3, typename T4, typename T5>
string LogFormat(const string msg, T1 p1, T2 p2, T3 p3, T4 p4, T5 p5) { return StringFormat(msg,p1,p2,p3,p4,p5); }

//--- Formatacao com 6 parametros.
template<typename T1, typename T2, typename T3, typename T4, typename T5, typename T6>
string LogFormat(const string msg, T1 p1, T2 p2, T3 p3, T4 p4, T5 p5, T6 p6) { return StringFormat(msg,p1,p2,p3,p4,p5,p6); }

//--- Formatacao com 7 parametros.
template<typename T1, typename T2, typename T3, typename T4, typename T5, typename T6, typename T7>
string LogFormat(const string msg, T1 p1, T2 p2, T3 p3, T4 p4, T5 p5, T6 p6, T7 p7) { return StringFormat(msg,p1,p2,p3,p4,p5,p6,p7); }

//--- Formatacao com 8 parametros.
template<typename T1, typename T2, typename T3, typename T4, typename T5, typename T6, typename T7, typename T8>
string LogFormat(const string msg, T1 p1, T2 p2, T3 p3, T4 p4, T5 p5, T6 p6, T7 p7, T8 p8) { return StringFormat(msg,p1,p2,p3,p4,p5,p6,p7,p8); }

//--- Formatacao com 9 parametros.
template<typename T1, typename T2, typename T3, typename T4, typename T5, typename T6, typename T7, typename T8, typename T9>
string LogFormat(const string msg, T1 p1, T2 p2, T3 p3, T4 p4, T5 p5, T6 p6, T7 p7, T8 p8, T9 p9) { return StringFormat(msg,p1,p2,p3,p4,p5,p6,p7,p8,p9); }

//--- Formatacao com 10 parametros.
template<typename T1, typename T2, typename T3, typename T4, typename T5, typename T6, typename T7, typename T8, typename T9, typename T0>
string LogFormat(const string msg, T1 p1, T2 p2, T3 p3, T4 p4, T5 p5, T6 p6, T7 p7, T8 p8, T9 p9, T0 p0) { return StringFormat(msg,p1,p2,p3,p4,p5,p6,p7,p8,p9,p0); }


//+------------------------------------------------------------------+
//| Facilita a utilizacao do logging com macros representativas.     |
//+------------------------------------------------------------------+
#define LogTrace if(isTraceEnabled()) LOG += LogRecordTrace(__PATH__, __FILE__, __FUNCTION__, __LINE__) + LogFormat
#define LogDebug if(isDebugEnabled()) LOG += LogRecordDebug(__PATH__, __FILE__, __FUNCTION__, __LINE__) + LogFormat
#define LogInfo  if(isInfoEnabled())  LOG += LogRecordInfo (__PATH__, __FILE__, __FUNCTION__, __LINE__) + LogFormat
#define LogWarn  if(isWarnEnabled())  LOG += LogRecordWarn (__PATH__, __FILE__, __FUNCTION__, __LINE__) + LogFormat
#define LogError if(isErrorEnabled()) LOG += LogRecordError(__PATH__, __FILE__, __FUNCTION__, __LINE__) + LogFormat
#define LogFatal if(isFatalEnabled()) LOG += LogRecordFatal(__PATH__, __FILE__, __FUNCTION__, __LINE__) + LogFormat


//+------------------------------------------------------------------+
