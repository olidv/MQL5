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
//| Class CPushAppender.                                             |
//|                                                                  |
//| Usage: Registro das mensagens de logging em notifacao Push.      |
//+------------------------------------------------------------------+
class CPushAppender: public CAbstractAppender
   {
protected:
    //--- Grava o registro de logging.
    virtual bool      doAppend(const SLogRecord &record);

public:
    //--- Construtores: Inicializa o layout utilizado internamente na formatacao.
    void              CPushAppender(const string name,
                                    const ENUM_LOG_LEVEL level,
                                    IFormatter *formatter) : CAbstractAppender(name, level, formatter) {};

    //--- Informa o tipo de processamento e destinatario do appender:
    virtual ENUM_APPEND_TYPE  getAppendType();
   };


//+------------------------------------------------------------------+
//| Informa o tipo deste appender.                                   |
//+------------------------------------------------------------------+
ENUM_APPEND_TYPE  CPushAppender::getAppendType()
   {
    return APPEND_PUSH;
   }


//+------------------------------------------------------------------+
//| Imprime o registro de logging em notificacao Push (mobile app).  |
//+------------------------------------------------------------------+
bool CPushAppender::doAppend(const SLogRecord &record)
   {
// formata a mensagem utilizando o formatter interno:
    string msg = getFormatter().formatMessage(record);

// notificacoes push possuem limite de 1000 caracteres (trunca o resto):
    int size_msg = StringLen(msg);
    if(size_msg > 1000)
       {
        msg = StringSubstr(msg, 0, 1000);
       }

// este appender apenas envia a mensagem formatada para notificacao push:
    SendNotification(msg);

    return true;
   }


//+------------------------------------------------------------------+
