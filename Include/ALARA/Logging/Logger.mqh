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

//program file         
//program package      MQL5/Include/ALARA/
#property version	   "1.000"
#property description  "..."

//**********************************************************************************************  

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include <Object.mqh>
#include "LogRecord.mqh"
#include "Format\HtmlFormatter.mqh"
#include "Format\TextFormatter.mqh"
#include "Append\AlertAppender.mqh"
#include "Append\ChartAppender.mqh"
#include "Append\ConsoleAppender.mqh"
#include "Append\FileAppender.mqh"
#include "Append\MailAppender.mqh"
#include "Append\PushAppender.mqh"
#include "Append\SoundAppender.mqh"


//+------------------------------------------------------------------+
//| Class CLogger.                                                   |
//|                                                                  |
//| Usage: Classe principal para gerenciamento e execucao da         |
//|        impressao/registro das mensagens de logging.              |
//+------------------------------------------------------------------+
class CLogger : public CObject
   {
private:
    //--- Declaracao das variaveis de instancia (propriedades):
    string           m_name;
    ELogLevel        m_level;   // menor nivel de logging entre os appenders internos.
    IAppender*       m_appenders[];
    int              m_asize;  // mantem o numero de appenders internos.

    void             addAppender(IAppender &appender);

    //--- Encerra os recursos alocados e fecha appenders, se necessario.
    bool             close();

public:
    //--- Construtor: Inicializa parametros internos e inicializa os appenders.
    void             CLogger(void);
    void             CLogger(const CLogger &) {}

    //--- Destrutor: Encerra e libera quaisquer recursos em uso pelo logger.
    void             ~CLogger(void);

    //--- Adiciona cada tipo de appender ao logger criado.
    bool             addConsoleAppender(const ELogLevel level);
    bool             addAlertAppender(const ELogLevel level);
    bool             addChartAppender(const ELogLevel level);
    bool             addSoundAppender(const ELogLevel level);
    bool             addPushAppender(const ELogLevel level);
    bool             addMailAppender(const ELogLevel level);
    bool             addFileAppender(const ELogLevel level, const string fileName);

    //--- Define e obtem o nome/identificacao do logger.
    void             setName(const string name);
    string           getName();

    //--- Obtem o menor nivel de logging entre os appenders internos.
    ELogLevel        getLevel();

    //--- Operacoes para registro/impressao de mensagem de logging.
    void             log(SLogRecord &record);

    void             CLogger::operator+= (SLogRecord &record)
       {
        this.log(record);
       }
   };


//+------------------------------------------------------------------+
//| Construtor: Inicializa parametros internos do logger.            |
//+------------------------------------------------------------------+
void CLogger::CLogger()
   {
// inicializa os parametros internos:
    m_name = "root";
    m_level = LOG_LEVEL_OFF;  // o maior nivel de prioridade de logging.
   }


//+------------------------------------------------------------------+
//| Destrutor: Encerra e libera quaisquer recursos em uso pelo       |
//|            logger.                                             |
//+------------------------------------------------------------------+
void CLogger::~CLogger()
   {
// elimina / fecha os recursos utilizados pelos appenders:
    close();
   }


//+------------------------------------------------------------------+
//| Inclui o appender na lista interna de appenders e o inicializa.  |
//+------------------------------------------------------------------+
void CLogger::addAppender(IAppender &appender)
   {
// executa os procedimentos necessarios para iniciar o uso do appender:
    appender.start();

//--- considera sempre o menor nivel de logging...
    ELogLevel level = appender.getLevel();
    if(this.m_level > level)
       {
        this.m_level = level;
       }

// prepara array interno para conter mais um appender:
    int idx = this.m_asize;
    this.m_asize++;
    ArrayResize(this.m_appenders, m_asize);
    this.m_appenders[idx] = &appender;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo ConsoleAppender ao logger a ser criado.|
//+------------------------------------------------------------------+
bool CLogger::addConsoleAppender(const ELogLevel level)
   {
// inicializa o appender com valores convencionais:
    CTextFormatter *formatter = new CTextFormatter(LAYOUT_TEXT_SIMPLE);
    CConsoleAppender *appender = new CConsoleAppender(this.m_name, level, formatter);

// adiciona o appender a lista interna de appenders:
    this.addAppender(appender);

    formatter = NULL;
    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo AlertAppender ao logger a ser criado.  |
//+------------------------------------------------------------------+
bool CLogger::addAlertAppender(const ELogLevel level)
   {
// inicializa o appender com valores convencionais:
    CTextFormatter *formatter = new CTextFormatter(LAYOUT_TEXT_SIMPLE);
    CAlertAppender *appender = new CAlertAppender(this.m_name, level, formatter);

// adiciona o appender a lista interna de appenders:
    this.addAppender(appender);

    formatter = NULL;
    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo ChartAppender ao logger a ser criado.  |
//+------------------------------------------------------------------+
bool CLogger::addChartAppender(const ELogLevel level)
   {
// inicializa o appender com valores convencionais:
    CTextFormatter *formatter = new CTextFormatter(LAYOUT_TEXT_COMMENT);
    CChartAppender *appender = new CChartAppender(this.m_name, level, formatter);

// adiciona o appender a lista interna de appenders:
    this.addAppender(appender);

    formatter = NULL;
    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo SoundAppender ao logger a ser criado.  |
//+------------------------------------------------------------------+
bool CLogger::addSoundAppender(const ELogLevel level)
   {
// inicializa o appender com valores convencionais:
    CSoundAppender *appender = new CSoundAppender(this.m_name, level);

// adiciona o appender a lista interna de appenders:
    this.addAppender(appender);

    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo PushAppender ao logger a ser criado.   |
//+------------------------------------------------------------------+
bool CLogger::addPushAppender(const ELogLevel level)
   {
// inicializa o appender com valores convencionais:
    CTextFormatter *formatter = new CTextFormatter(LAYOUT_TEXT_NOTIFICATION);
    CPushAppender *appender = new CPushAppender(this.m_name, level, formatter);

// adiciona o appender a lista interna de appenders:
    this.addAppender(appender);

    formatter = NULL;
    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo MailAppender ao logger a ser criado.   |
//+------------------------------------------------------------------+
bool CLogger::addMailAppender(const ELogLevel level)
   {
// inicializa o appender com valores convencionais:
    CTextFormatter *formatter = new CTextFormatter(LAYOUT_HTML_MESSAGE);
    CMailAppender *appender = new CMailAppender(this.m_name, level, formatter);

// adiciona o appender a lista interna de appenders:
    this.addAppender(appender);

    formatter = NULL;
    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo FileAppender ao logger a ser criado.   |
//+------------------------------------------------------------------+
bool CLogger::addFileAppender(const ELogLevel level, const string fileName)
   {
// inicializa o appender com valores convencionais:
    CTextFormatter *formatter = new CTextFormatter(LAYOUT_TEXT_STREAM);
    CFileAppender *appender = new CFileAppender(fileName, level, formatter);

// adiciona o appender a lista interna de appenders:
    this.addAppender(appender);

    formatter = NULL;
    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Define o nome/identificacao do logger.                                        |
//+------------------------------------------------------------------+
void CLogger::setName(const string name)
   {
    this.m_name = name;
   }


//+------------------------------------------------------------------+
//| Obtem o nome/identificacao do logger.                                        |
//+------------------------------------------------------------------+
string CLogger::getName()
   {
    return this.m_name;
   }


//+------------------------------------------------------------------+
//| Obtem o menor nivel de logging entre os appenders internos.      |
//+------------------------------------------------------------------+
ELogLevel CLogger::getLevel()
   {
    return this.m_level;
   }


//+------------------------------------------------------------------+
//| Encerra os recursos alocados e fecha appenders, se necessario.   |
//+------------------------------------------------------------------+
bool CLogger::close()
   {
//--- envia sinal aos appenders para encerrarem e liberarem os recursos internos:
    for(int i = 0; i < this.m_asize; i++)
       {
        this.m_appenders[i].close();
        delete(this.m_appenders[i]);
        this.m_appenders[i] = NULL;
       }

    return true;
   }


//+------------------------------------------------------------------+
//| Operacao para registro/impressao de mensagem de logging.         |
//+------------------------------------------------------------------+
void CLogger::log(SLogRecord &record)
   {
//--- repassa a identificacao do logger aos appenders:
    record.name = this.m_name;

//--- envia o registro de logging a cada um dos appenders...
    for(int i = 0; i < this.m_asize; i++)
       {
        // mas somente irao tratar o logging aqueles com prioridade menor ou igual.
        if(this.m_appenders[i].isLoggable(record))
           {
            this.m_appenders[i].write(record);
           }
       }
   }


//+------------------------------------------------------------------+
