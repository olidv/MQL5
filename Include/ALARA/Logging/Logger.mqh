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
#include "LogRecord.mqh"
#include "Format\SimpleFormatter.mqh"
#include "Append\ConsoleAppender.mqh"
#include "Append\AlertAppender.mqh"
#include "Append\ChartAppender.mqh"
#include "Append\SoundAppender.mqh"
#include "Append\PushAppender.mqh"
#include "Append\MailAppender.mqh"
#include "Append\FileAppender.mqh"


//+------------------------------------------------------------------+
//| Class CLogger.                                                   |
//|                                                                  |
//| Usage: Classe principal para gerenciamento e execucao da         |
//|        impressao/registro das mensagens de logging.              |
//+------------------------------------------------------------------+
class CLogger
   {
private:
    //--- Declaracao das variaveis de instancia (propriedades):
    string             m_name;
    ENUM_LOG_LEVEL     m_level;   // menor nivel de logging entre os appenders internos.
    IAppender*         m_appenders[];
    int                m_asize;  // mantem o numero de appenders internos.

protected:
    //--- Encerra os recursos alocados e fecha appenders, se necessario.
    virtual bool      close();

public:
    //--- Construtor: Inicializa parametros internos e inicializa os appenders.
    void              CLogger(void);
    void              CLogger(const CLogger &) {}

    //--- Destrutor: Encerra e libera quaisquer recursos em uso pelo logger.
    void             ~CLogger(void);

    //--- Adiciona cada tipo de appender ao logger criado.
    bool             addConsoleAppender(const ENUM_LOG_LEVEL level);
    bool             addAlertAppender(const ENUM_LOG_LEVEL level);
    bool             addChartAppender(const ENUM_LOG_LEVEL level);
    bool             addSoundAppender(const ENUM_LOG_LEVEL level);
    bool             addPushAppender(const ENUM_LOG_LEVEL level);
    bool             addMailAppender(const ENUM_LOG_LEVEL level);
    bool             addFileAppender(const ENUM_LOG_LEVEL level, const string fileName);

    //--- Define e obtem o nome/identificacao do logger.
    void             setName(const string name);
    string           getName();

    //--- Obtem o menor nivel de logging entre os appenders internos.
    ENUM_LOG_LEVEL   getLevel();

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
//| Adiciona appender do tipo ConsoleAppender ao logger a ser criado.|
//+------------------------------------------------------------------+
bool CLogger::addConsoleAppender(const ENUM_LOG_LEVEL level)
   {
//--- considera sempre o menor nivel de logging...
    if(this.m_level > level)
       {
        this.m_level = level;
       }

// inicializa o appender com valores convencionais:
    CSimpleFormatter *formatter = new CSimpleFormatter(LAYOUT_TEXT_SIMPLE);
    CConsoleAppender *appender = new CConsoleAppender(this.m_name, level, formatter);

// prepara array interno para conter mais um appender:
    int idx = this.m_asize;
    this.m_asize++;
    ArrayResize(this.m_appenders, m_asize);
    this.m_appenders[idx] = appender;

    formatter = NULL;
    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo AlertAppender ao logger a ser criado.  |
//+------------------------------------------------------------------+
bool CLogger::addAlertAppender(const ENUM_LOG_LEVEL level)
   {
//--- considera sempre o menor nivel de logging...
    if(this.m_level > level)
       {
        this.m_level = level;
       }

// inicializa o appender com valores convencionais:
    CSimpleFormatter *formatter = new CSimpleFormatter(LAYOUT_TEXT_SIMPLE);
    CAlertAppender *appender = new CAlertAppender(this.m_name, level, formatter);

// prepara array interno para conter mais um appender:
    int idx = this.m_asize;
    this.m_asize++;
    ArrayResize(this.m_appenders, m_asize);
    this.m_appenders[idx] = appender;

    formatter = NULL;
    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo ChartAppender ao logger a ser criado.  |
//+------------------------------------------------------------------+
bool CLogger::addChartAppender(const ENUM_LOG_LEVEL level)
   {
//--- considera sempre o menor nivel de logging...
    if(this.m_level > level)
       {
        this.m_level = level;
       }

// inicializa o appender com valores convencionais:
    CSimpleFormatter *formatter = new CSimpleFormatter(LAYOUT_TEXT_COMMENT);
    CChartAppender *appender = new CChartAppender(this.m_name, level, formatter);

// prepara array interno para conter mais um appender:
    int idx = this.m_asize;
    this.m_asize++;
    ArrayResize(this.m_appenders, m_asize);
    this.m_appenders[idx] = appender;

    formatter = NULL;
    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo SoundAppender ao logger a ser criado.  |
//+------------------------------------------------------------------+
bool CLogger::addSoundAppender(const ENUM_LOG_LEVEL level)
   {
//--- considera sempre o menor nivel de logging...
    if(this.m_level > level)
       {
        this.m_level = level;
       }

// inicializa o appender com valores convencionais:
    CSoundAppender *appender = new CSoundAppender(this.m_name, level);

// prepara array interno para conter mais um appender:
    int idx = this.m_asize;
    this.m_asize++;
    ArrayResize(this.m_appenders, m_asize);
    this.m_appenders[idx] = appender;

    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo PushAppender ao logger a ser criado.   |
//+------------------------------------------------------------------+
bool CLogger::addPushAppender(const ENUM_LOG_LEVEL level)
   {
//--- considera sempre o menor nivel de logging...
    if(this.m_level > level)
       {
        this.m_level = level;
       }

// inicializa o appender com valores convencionais:
    CSimpleFormatter *formatter = new CSimpleFormatter(LAYOUT_TEXT_NOTIFICATION);
    CPushAppender *appender = new CPushAppender(this.m_name, level, formatter);

// prepara array interno para conter mais um appender:
    int idx = this.m_asize;
    this.m_asize++;
    ArrayResize(this.m_appenders, m_asize);
    this.m_appenders[idx] = appender;

    formatter = NULL;
    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo MailAppender ao logger a ser criado.   |
//+------------------------------------------------------------------+
bool CLogger::addMailAppender(const ENUM_LOG_LEVEL level)
   {
//--- considera sempre o menor nivel de logging...
    if(this.m_level > level)
       {
        this.m_level = level;
       }

// inicializa o appender com valores convencionais:
    CSimpleFormatter *formatter = new CSimpleFormatter(LAYOUT_HTML_MESSAGE);
    CMailAppender *appender = new CMailAppender(this.m_name, level, formatter);

// prepara array interno para conter mais um appender:
    int idx = this.m_asize;
    this.m_asize++;
    ArrayResize(this.m_appenders, m_asize);
    this.m_appenders[idx] = appender;

    formatter = NULL;
    appender = NULL;
    return true;
   }


//+------------------------------------------------------------------+
//| Adiciona appender do tipo FileAppender ao logger a ser criado.   |
//+------------------------------------------------------------------+
bool CLogger::addFileAppender(const ENUM_LOG_LEVEL level, const string fileName)
   {
//--- considera sempre o menor nivel de logging...
    if(this.m_level > level)
       {
        this.m_level = level;
       }

// inicializa o appender com valores convencionais:
    CSimpleFormatter *formatter = new CSimpleFormatter(LAYOUT_TEXT_STREAM);
    CFileAppender *appender = new CFileAppender(this.m_name, level, formatter);

// prepara array interno para conter mais um appender:
    int idx = this.m_asize;
    this.m_asize++;
    ArrayResize(this.m_appenders, m_asize);
    this.m_appenders[idx] = appender;

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
ENUM_LOG_LEVEL CLogger::getLevel()
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
