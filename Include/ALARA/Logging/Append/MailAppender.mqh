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
//| Class CMailAppender.                                             |
//|                                                                  |
//| Usage: Envio das mensagens de logging por mensagem de e-mail.    |
//+------------------------------------------------------------------+
class CMailAppender: public CAbstractAppender
   {
protected:
    //--- Grava o registro de logging.
    virtual bool      doAppend(const SLogRecord &record);

public:
    //--- Construtores: Inicializa o layout utilizado internamente na formatacao.
    void              CMailAppender(const string name,
                                    const ENUM_LOG_LEVEL level,
                                    IFormatter *formatter) : CAbstractAppender(name, level, formatter) {};

    //--- Informa o tipo de processamento e destinatario do appender:
    virtual ENUM_APPEND_TYPE  getAppendType();
   };


//+------------------------------------------------------------------+
//| Informa o tipo deste appender.                                   |
//+------------------------------------------------------------------+
ENUM_APPEND_TYPE  CMailAppender::getAppendType()
   {
    return APPEND_MAIL;
   }


//+------------------------------------------------------------------+
//| Envia o registro de logging por mensagem de e-mail.              |
//+------------------------------------------------------------------+
bool CMailAppender::doAppend(const SLogRecord &record)
   {
// formata a mensagem utilizando o formatter interno:
    string message = getFormatter().formatMessage(record);
    string subject = "Programa MQL5: " + record.program;

// este appender apenas envia a mensagem formatada por e-mail:

    SendMail(subject, message);

    return true;
   }


//+------------------------------------------------------------------+
