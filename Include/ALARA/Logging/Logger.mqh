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
#property copyright   "Copyright (c) 2021 by Oliveira Developer at Brazil"
#property link        "https://github.com/olidv/Log4Mql5"
#property version     "1.00"
#property description ""
#property description ""

#property library

namespace Log4Mql5 {







//--- O comportamento default eh logar tudo...
SLOG_LEVEL  _level = ALL;

//+------------------------------------------------------------------+
//| Define o nivel atual de logging.                                 |
//+------------------------------------------------------------------+
void Log_SetLevel(const SLOG_LEVEL value)
   {
    _level = value;
   }

//+------------------------------------------------------------------+
//| Funcoes para printar logging na console (aba Experts), por nivel.|
//| Apos fechar o MT5, o loging eh salvo em arquivo.                 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Log_Trace(const string msg, const string funcName = NULL, const int lineNumber = NULL)
   {
//--- verifica se pode logar neste nivel
    if(_level > TRACE)
        return;

//--- formata o local da chamada do logging
    Print("TRACE ", _formatLocal(funcName, lineNumber), msg);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Log_Debug(const string msg, const string funcName = NULL, const int lineNumber = NULL)
   {
//--- verifica se pode logar neste nivel
    if(_level > DEBUG)
        return;

//--- formata o local da chamada do logging
    Print("DEBUG ", _formatLocal(funcName, lineNumber), msg);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Log_Info(const string msg, const string funcName = NULL, const int lineNumber = NULL)
   {
//--- verifica se pode logar neste nivel
    if(_level > INFO)
        return;

//--- formata o local da chamada do logging
    Print("INFO  ", _formatLocal(funcName, lineNumber), msg);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Log_Warn(const string msg, const string funcName = NULL, const int lineNumber = NULL)
   {
//--- verifica se pode logar neste nivel
    if(_level > WARN)
        return;

//--- formata o local da chamada do logging
    Print("WARN  ", _formatLocal(funcName, lineNumber), msg);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Log_Error(const string msg, const string funcName = NULL, const int lineNumber = NULL)
   {
//--- verifica se pode logar neste nivel
    if(_level > ERROR)
        return;

//--- formata o local da chamada do logging
    Print("ERROR ", _formatLocal(funcName, lineNumber), msg);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Log_Fatal(const string msg, const string funcName = NULL, const int lineNumber = NULL)
   {
//--- verifica se pode logar neste nivel
    if(_level > FATAL)
        return;

//--- formata o local da chamada do logging
    Print("FATAL ", _formatLocal(funcName, lineNumber), msg);
   }

//+------------------------------------------------------------------+
//| Formata o local da chamada do logging.                           |
//+------------------------------------------------------------------+
string _formatLocal(const string funcName = NULL, const int lineNumber = NULL)
   {
//---
    string local = "";
    if(funcName != NULL || lineNumber != NULL)
       {
        local = "{" +
                ((funcName == NULL) ? "" : funcName) +
                ((lineNumber == NULL) ? "" : ":" + IntegerToString(lineNumber)) +
                "} ";
       }

    return local;
   }


//+------------------------------------------------------------------+

}