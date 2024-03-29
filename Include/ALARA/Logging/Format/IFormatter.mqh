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
#include "..\LogRecord.mqh"


//+------------------------------------------------------------------+
//| Interface IFormatter.                                            |
//|                                                                  |
//| Usage: Definicao de metodos para as classes concretas que        |
//|        efetuam a formatacao das mensagens de logging.            |
//+------------------------------------------------------------------+
interface IFormatter
   {
//--- Formata um registro de logging de acordo com o layout interno.
    string           formatMessage(const SLogRecord &record);
   };


//+------------------------------------------------------------------+
//| A especificação do formato do layout segue o padrao para         |
//| formatacao de strings:  %word                                    |
//+------------------------------------------------------------------+
//
// word       Campo de SLogRecord
// -------    ---------------------
// %time    = SLogRecord.timestamp
// %name    = SLogRecord.name
// %pack    = SLogRecord.package
// %prog    = SLogRecord.program
// %func    = SLogRecord.function
// %line    = SLogRecord.line
// %level   = SLogRecord.level
// %msg     = SLogRecord.message


//+------------------------------------------------------------------+
//| Definicoes dos layouts padroes para cada classe formatter        |
//| que utiliza uma formatacao textual simples (linha unica).        |
//+------------------------------------------------------------------+
#define LAYOUT_TEXT_SIMPLE        "%level %msg"
#define LAYOUT_TEXT_CHART         "%time %level %msg"
#define LAYOUT_TEXT_STREAM        "%time %level [%name] %pack->%func<%line>  %msg"
#define LAYOUT_TEXT_NOTIFICATION  "[%prog] %level: %msg"


//+------------------------------------------------------------------+
//| Definicoes de layout padrao para classe formatter que utiliza    |
//| uma formatacao em HTML (trecho inserido no BODY).                |
//+------------------------------------------------------------------+
#define LAYOUT_HTML_TABLE         "<p>%time %level [%name] %pack->%func<%line>  %msg</p>"


//+------------------------------------------------------------------+
