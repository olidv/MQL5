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
#include "AbstractAppender.mqh"


//+------------------------------------------------------------------+
//| Class CFileAppender.                                             |
//|                                                                  |
//| Usage: Registro das mensagens de logging em arquivo.             |
//+------------------------------------------------------------------+
class CFileAppender: public CAbstractAppender
   {
private:
    //--- Declaracao das variaveis de instancia (propriedades):
    int              hndLogFile;   // handle para arquivo de logging gerado.

protected:
    //--- Grava o registro de logging.
    virtual bool      doAppend(const SLogRecord &record);

public:
    //--- Construtores: Inicializa o layout utilizado internamente na formatacao.
    void              CFileAppender(const string name,
                                    const ENUM_LOG_LEVEL level,
                                    IFormatter *formatter) : CAbstractAppender(name, level, formatter) {};

    //--- Informa o tipo de processamento e destinatario do appender:
    virtual ENUM_APPEND_TYPE  getAppendType();

    //--- Executa procedimentos de inicializacao para o appender.
    virtual bool      start();

    //--- Salva os registros de logging ainda em cache.
    virtual bool      flush(const bool closing);

    //--- Encerra os recursos alocados e fecha arquivos, se necessario.
    virtual bool      close();
   };


//+------------------------------------------------------------------+
//| Informa o tipo deste appender.                                   |
//+------------------------------------------------------------------+
ENUM_APPEND_TYPE  CFileAppender::getAppendType()
   {
    return APPEND_FILE;
   }


//+------------------------------------------------------------------+
//| Executa procedimentos de inicializacao para o appender.          |
//+------------------------------------------------------------------+
bool CFileAppender::start()
   {
    this.hndLogFile = INVALID_HANDLE;
    return true;
   }


//+------------------------------------------------------------------+
//| Salva os registros de logging ainda em cache.                    |
//+------------------------------------------------------------------+
bool CFileAppender::flush(const bool closing)
   {
    return true;
   }


//+------------------------------------------------------------------+
//| Encerra os recursos alocados e fecha arquivos, se necessario.    |
//+------------------------------------------------------------------+
bool CFileAppender::close()
   {
    return true;
   }


//+------------------------------------------------------------------+
//| Grava o registro de logging em arquivo.                          |
//+------------------------------------------------------------------+
bool CFileAppender::doAppend(const SLogRecord &record)
   {
// formata a mensagem utilizando o formatter interno:
    string msg = getFormatter().formatMessage(record);

// este appender apenas printa a mensagem formatada na console:
    Print(msg);

    return true;
   }


//+------------------------------------------------------------------+
