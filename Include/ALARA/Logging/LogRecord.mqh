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
#include "LogLevel.mqh"


//+------------------------------------------------------------------+
//| Structure SLogRecord.                                            |
//|                                                                  |
//| Usage: Registro das informacoes utilizadas no registro do        |
//|        do logging para formatacao e publicacao.                  |
//+------------------------------------------------------------------+
struct SLogRecord
   {
    datetime         timestamp;   // [%time]    Data-hora no momento da chamada
    string           loggerName;  // [%logger]  Nome do logger que foi executado
    string           fileName;    // [%file]    Nome do arquivo onde foi feita a chamada
    string           methodName;  // [%method]  Nome do metodo onde foi feita a chamada
    int              lineNumber;  // [%line]    Numero da linha onde foi feita a chamada
    ENUM_LOG_LEVEL   level;       // [%level]   Level da mensagem de logging
    string           message;     // [%msg]     Texto original da mensagem
   };


//+------------------------------------------------------------------+
