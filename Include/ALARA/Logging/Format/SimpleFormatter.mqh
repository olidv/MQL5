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
#include "AbstractFormatter.mqh"


//+------------------------------------------------------------------+
//| Class CSimpleFormatter.                                          |
//|                                                                  |
//| Usage: Definicao de metodos para as classes concretas que        |
//|        efetuam a formatacao das mensagens de logging.            |
//+------------------------------------------------------------------+
class CSimpleFormatter: public CAbstractFormatter
   {
public:
    //--- Construtores: Inicializa o layout utilizado internamente na formatacao.
    void              CSimpleFormatter(string layout) : CAbstractFormatter(layout) {Print(__FILE__,"->",__FUNCTION__,"<",__LINE__,">");};

    //--- Formata um registro de logging de acordo com o layout interno.
    virtual string    formatMessage(const SLogRecord &record);
   };


//+------------------------------------------------------------------+
//| Formata um registro de logging de acordo com o layout interno.   |
//+------------------------------------------------------------------+
string CSimpleFormatter::formatMessage(const SLogRecord &record)
   {Print(__PATH__,"//",__FILE__,"->",__FUNCTION__,"<",__LINE__,">");
// este metodo interno ja efetua toda a validacao necessaria:
    string msg = compilePattern(getLayout(), record);

// retorna a mensagem de logging em uma unica linha (texto simples).
    return msg;
   };


//+------------------------------------------------------------------+
