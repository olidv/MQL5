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
#include "AbstractAppender.mqh"


//+------------------------------------------------------------------+
//| Class CConsoleAppender.                                          |
//|                                                                  |
//| Usage: Definicao de metodos para as classes concretas que        |
//|        efetuam a formatacao das mensagens de logging.            |
//+------------------------------------------------------------------+
class CConsoleAppender: public CAbstractAppender
   {
protected:
    //--- Grava o registro de logging.
    virtual bool      doAppend(const SLogRecord &record);

public:
    //--- Construtores: Inicializa o layout utilizado internamente na formatacao.
    void              CConsoleAppender(string name,
                                       ENUM_LOG_LEVEL level,
                                       IFormatter *formatter) : CAbstractAppender(name, level, formatter) {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");};
   };


//+------------------------------------------------------------------+
//| Grava o registro de logging.                                     |
//+------------------------------------------------------------------+
bool CConsoleAppender::doAppend(const SLogRecord &record)
   {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
// formata a mensagem utilizando o formatter interno:
    string msg = getFormatter().formatMessage(record);

    Print(msg);

    return true;
   };


//+------------------------------------------------------------------+