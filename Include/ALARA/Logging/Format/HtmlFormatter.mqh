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
#include "..\LogRecord.mqh"


//+------------------------------------------------------------------+
//| Class CHtmlFormatter.                                            |
//|                                                                  |
//| Usage: Definicao de metodos para as classes concretas que        |
//|        efetuam a formatacao das mensagens de logging.            |
//+------------------------------------------------------------------+
class CHtmlFormatter: public CAbstractFormatter
   {
private:
    //--- Declaracao das variaveis de instancia (propriedades):
    string            m_layout;  // Padrao (Pattern) de formatacao do registro de logging.

public:
    //--- Construtores: Inicializa o layout utilizado internamente na formatacao.
    void              CHtmlFormatter(void) : m_layout(LAYOUT_HTML_TABLE) {};
    void              CHtmlFormatter(string layout) : m_layout(layout) {};

    //--- Destrutores: Nao ha nenhum recurso em uso que necessite ser liberado/fechado.
    void             ~CHtmlFormatter(void) {};

    //--- Formata um registro de logging de acordo com o layout interno.
    string            formatMessage(SLogRecord &record);
   };


//+------------------------------------------------------------------+
//| Formata um registro de logging de acordo com o layout interno.   |
//+------------------------------------------------------------------+
string CHtmlFormatter::formatMessage(SLogRecord &record)
   {
// este metodo interno ja efetua toda a validacao necessaria:
    string msg = compilePattern(m_layout, record);

// retorna a mensagem de logging em um trecho HTML - para inserir no BODY.
    return msg;
   };


//+------------------------------------------------------------------+
