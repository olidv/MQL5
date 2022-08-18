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
#include "..\Format\Formatter.mqh"
#include "Appender.mqh"


//+------------------------------------------------------------------+
//| Class CAbstractAppender.                                         |
//|                                                                  |
//| Usage: Definicao de metodos para as classes concretas que        |
//|        efetuam a impressao/registro das mensagens de logging.    |
//+------------------------------------------------------------------+
class CAbstractAppender: public IAppender
   {
private:
    //--- Declaracao das variaveis de instancia (propriedades):
    string              m_name;
    ELogLevel           m_level;
    IFormatter*         m_formatter;

protected:
    //--- Obtem o nome/identificacao do appender.
    string              getName();

    //--- Obtem o formatador utilizado neste appender.
    IFormatter*         getFormatter();

    //--- Grava o registro de logging.
    virtual bool        doAppend(const SLogRecord &record) = NULL;

    //--- Salva os registros de logging ainda em cache.
    virtual bool        flush(const bool closing);

public:
    //--- Construtor: Inicializa parametros internos e configura o appender.
    void                CAbstractAppender(const string name,
                                          const ELogLevel level);
    void                CAbstractAppender(const string name,
                                          const ELogLevel level,
                                          IFormatter *formatter);

    //--- Destrutor: Encerra e libera quaisquer recursos em uso pelo appender.
    void               ~CAbstractAppender(void);

    //--- Informa o tipo de processamento e destinatario do appender:
    virtual EAppendType getAppendType() = NULL;

    //--- Obtem o level para o appender.
    virtual ELogLevel   getLevel();

    //--- Verifica se o appender ira considerar o registro de logging.
    virtual bool        isLoggable(const SLogRecord &record);

    //--- Executa procedimentos de inicializacao para o appender.
    virtual bool        start();

    //--- Grava o registro de logging.
    virtual bool        write(const SLogRecord &record);

    //--- Encerra os recursos alocados e fecha arquivos, se necessario.
    virtual bool        close();
   };


//+------------------------------------------------------------------+
//| Construtor: Inicializa parametros internos e configura o         |
//|             appender.                                            |
//+------------------------------------------------------------------+
void CAbstractAppender::CAbstractAppender(const string name, const ELogLevel level)
   {
// inicializa os parametros internos:
    this.m_name = name;
    this.m_level = level;
    this.m_formatter = NULL;
   }


//+------------------------------------------------------------------+
//| Construtor: Inicializa parametros internos e configura o         |
//|             appender.                                            |
//+------------------------------------------------------------------+
void CAbstractAppender::CAbstractAppender(const string name, const ELogLevel level, IFormatter *formatter)
   {
// inicializa os parametros internos:
    this.m_name = name;
    this.m_level = level;
    this.m_formatter = formatter;
   }


//+------------------------------------------------------------------+
//| Destrutor: Encerra e libera quaisquer recursos em uso pelo       |
//|            appender.                                             |
//+------------------------------------------------------------------+
void CAbstractAppender::~CAbstractAppender()
   {
// apenas limpa as variaveis internas:
    this.m_name = NULL;
// this.m_level = NULL;

// eh preciso excluir a referencia do objeto formatter interno:
    if(this.m_formatter != NULL)    // alguns appenders nao precisam de formatter...
       {
        delete(this.m_formatter);
        this.m_formatter = NULL;
       }
   }


//+------------------------------------------------------------------+
//| Obtem o nome/identificacao do appender.                          |
//+------------------------------------------------------------------+
string CAbstractAppender::getName()
   {
    return this.m_name;
   }


//+------------------------------------------------------------------+
//| Obtem o formatador utilizado neste appender.                     |
//+------------------------------------------------------------------+
IFormatter* CAbstractAppender::getFormatter()
   {
    return this.m_formatter;
   }


//+------------------------------------------------------------------+
//| Obtem o level para o appender.                                   |
//+------------------------------------------------------------------+
ELogLevel CAbstractAppender::getLevel()
   {
    return this.m_level;
   }


//+------------------------------------------------------------------+
//| Verifica se o appender ira processar o registro de logging.      |
//+------------------------------------------------------------------+
bool CAbstractAppender::isLoggable(const SLogRecord &record)
   {
// somente ira permitir o registro de logging se o evento tiver maior prioridade.
    return record.level >= this.m_level;
   }


//+------------------------------------------------------------------+
//| Executa procedimentos de inicializacao para o appender.          |
//+------------------------------------------------------------------+
bool CAbstractAppender::start()
   {
//--- ao inicializar o appender, tambem inicializa o formatter incluso, se existir.
    if(this.m_formatter != NULL)    // alguns appenders nao precisam de formatter...
       {
        this.m_formatter.start();
       }

    return true;
   }


//+------------------------------------------------------------------+
//| Formata um registro de logging de acordo com o layout interno.   |
//+------------------------------------------------------------------+
bool CAbstractAppender::write(const SLogRecord &record)
   {
    static bool lock = false;  // Inicializado ao executar o programa (uma unica vez).

// se o flag lock estiver ativo, entao ha um registro de logging em processamento...
    if(lock)
       {
        return false;  // informa que o registro de logging nao foi processado.
       }

// neste ponto, ativa o lock e impede novas chamadas ao metodo:
    lock = true;

// efetua o processamento do registro de logging:
    this.doAppend(record);

// realiza a logica interna do flushing, caso seja necessario:
    this.flush(false);  // avisa que ainda nao esta encerrando o appender...

// ao final, inativa o flag de lock:
    lock = false;

// o registro de logging foi processado com sucesso.
    return true;
   }


//+------------------------------------------------------------------+
//| Salva os registros de logging ainda em cache.                    |
//+------------------------------------------------------------------+
bool CAbstractAppender::flush(const bool closing)
   {
// nao ha o que processar aqui...
    return true;
   }


//+------------------------------------------------------------------+
//| Encerra os recursos alocados e fecha arquivos, se necessario.    |
//+------------------------------------------------------------------+
bool CAbstractAppender::close()
   {
// Se ainda houver registros de logging no cache, grava uma ultima vez:
    this.flush(true);  // agora sim, esta encerrando o appender.

//--- ao encerrar o appender, tambem notifica o formatter incluso para encerrar.
    if(this.m_formatter != NULL)    // alguns appenders nao precisam de formatter...
       {
        this.m_formatter.close();
       }

    return true;
   }


//+------------------------------------------------------------------+
