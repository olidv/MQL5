/*
 * MIT License
 *
 * Log4Mq5  .:.  https://github.com/olidv/Log4Mq5
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
#include "..\Format\IFormatter.mqh"
#include "IAppender.mqh"


//+------------------------------------------------------------------+
//| Class CAbstractAppender.                                         |
//|                                                                  |
//| Usage: Definicao de metodos para as classes concretas que        |
//|        efetuam a formatacao das mensagens de logging.            |
//+------------------------------------------------------------------+
class CAbstractAppender: public IAppender
   {
private:
    //--- Declaracao das variaveis de instancia (propriedades):
    string            m_name;
    ENUM_LOG_LEVEL    m_level;
    IFormatter*       m_formatter;

protected:
    //--- Obtem o nome do appender.
    string            getName();

    //--- Obtem o level para o appender.
    ENUM_LOG_LEVEL    getLevel();

    //--- Obtem o formatador utilizado neste appender.
    IFormatter*       getFormatter();

    //--- Executa procedimentos de inicializacao para o appender.
    virtual bool      start();

    //--- Verifica se o appender ira considerar o registro de logging.
    virtual bool      isLoggable(const SLogRecord &record);

    //--- Grava o registro de logging.
    virtual bool      doAppend(const SLogRecord &record) = NULL;

    //--- Salva os registros de logging ainda em cache.
    virtual bool      flush();

    //--- Encerra os recursos alocados e fecha arquivos, se necessario.
    virtual bool      close();

public:
    //--- Construtor: Inicializa parametros internos e configura o appender.
    void              CAbstractAppender(string name,
                                        ENUM_LOG_LEVEL level,
                                        IFormatter *formatter);

    //--- Destrutor: Encerra e libera quaisquer recursos em uso pelo appender.
    void             ~CAbstractAppender(void);

    //--- Grava o registro de logging.
    virtual bool      write(const SLogRecord &record);
   };


//+------------------------------------------------------------------+
//| Construtor: Inicializa parametros internos e configura o         |
//|             appender.                                            |
//+------------------------------------------------------------------+
void CAbstractAppender::CAbstractAppender(
    string name,
    ENUM_LOG_LEVEL level,
    IFormatter *formatter)
   {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
// inicializa os parametros internos:
    m_name = name;
    m_level = level;
    m_formatter = formatter;

// executa os procedimentos necessarios para iniciar o uso do appender:
    start();
   };


//+------------------------------------------------------------------+
//| Destrutor: Encerra e libera quaisquer recursos em uso pelo       |
//|            appender.                                             |
//+------------------------------------------------------------------+
void CAbstractAppender::~CAbstractAppender()
   {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
// Se ainda houver registros de logging no cache, grava uma ultima vez:
    flush();

// elimina / fecha os recursos utilizados no appender:
    close();
   };


//+------------------------------------------------------------------+
//| Obtem o nome do appender.                                        |
//+------------------------------------------------------------------+
string CAbstractAppender::getName()
   {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
    return m_name;
   };


//+------------------------------------------------------------------+
//| Obtem o level para o appender.                                   |
//+------------------------------------------------------------------+
ENUM_LOG_LEVEL CAbstractAppender::getLevel()
   {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
    return m_level;
   };


//+------------------------------------------------------------------+
//| Obtem o formatador utilizado neste appender.                     |
//+------------------------------------------------------------------+
IFormatter* CAbstractAppender::getFormatter()
   {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
    return m_formatter;
   };


//+------------------------------------------------------------------+
//| Executa procedimentos de inicializacao para o appender.          |
//+------------------------------------------------------------------+
bool CAbstractAppender::start()
   {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
// nao ha o que processar aqui...
    return true;
   };


//+------------------------------------------------------------------+
//| Verifica se o appender ira processar o registro de logging.      |
//+------------------------------------------------------------------+
bool CAbstractAppender::isLoggable(const SLogRecord &record)
   {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
// somente ira permitir o registro de logging se o evento tiver maior prioridade.
    return record.level >= getLevel();
   }


//+------------------------------------------------------------------+
//| Formata um registro de logging de acordo com o layout interno.   |
//+------------------------------------------------------------------+
bool CAbstractAppender::write(const SLogRecord &record)
   {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
    static bool lock = false;  // Inicializado ao executar o programa (uma unica vez).

// se o flag lock estiver ativo, entao ha um registro de loggin em processamento...
    if(lock)
       {
        return false;  // informa que o registro de logging nao foi processado.
       }

// neste ponto, ativa o lock e impede novas chamadas ao metodo:
    lock = true;

// efetua o processamento do registro de logging:
    doAppend(record);

// ao final, inativa o flag de lock:
    lock = false;

// o registro de logging foi processado com sucesso.
    return true;
   };


//+------------------------------------------------------------------+
//| Salva os registros de logging ainda em cache.                    |
//+------------------------------------------------------------------+
bool CAbstractAppender::flush()
   {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
// nao ha o que processar aqui...
    return true;
   };


//+------------------------------------------------------------------+
//| Encerra os recursos alocados e fecha arquivos, se necessario.    |
//+------------------------------------------------------------------+
bool CAbstractAppender::close()
   {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
// apenas limpa as variaveis internas:
    m_name = NULL;
    //m_level = NULL;

// eh preciso excluir a referencia do objeto formatter interno:
    delete(m_formatter);
    m_formatter = NULL;

    return true;
   };


//+------------------------------------------------------------------+
