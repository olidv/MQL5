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
#include "LogLevel.mqh"


//+------------------------------------------------------------------+
//| Structure SLogRecord.                                            |
//|                                                                  |
//| Usage: Registro das informacoes utilizadas no registro do        |
//|        do logging para formatacao e publicacao.                  |
//+------------------------------------------------------------------+
struct SLogRecord final
   {
    ENUM_LOG_LEVEL   level;       // [%level]  Level da mensagem de logging
    datetime         timestamp;   // [%time]   Data-hora no momento da chamada
    string           package;     // [%pack]   Package do programa onde foi feita a chamada
    string           program;     // [%prog]   Nome do programa onde foi feita a chamada
    string           function;    // [%func]   Nome do metodo onde foi feita a chamada
    ushort           line;        // [%line]   Numero da linha onde foi feita a chamada

    string           name;        // [%name]   Nome do logger que foi executado
    string           message;     // [%msg]    Texto original da mensagem

    SLogRecord       operator+ (const string msg)
       {
        this.message = msg;
        return this;
       }
   };


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel de rastreio/Trace.       |
//+------------------------------------------------------------------+
SLogRecord LogRecordTrace(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_TRACE, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel Debug.                   |
//+------------------------------------------------------------------+
SLogRecord LogRecordDebug(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_DEBUG, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel Informativo.             |
//+------------------------------------------------------------------+
SLogRecord LogRecordInfo(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_INFO, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel de alerta/aviso.         |
//+------------------------------------------------------------------+
SLogRecord LogRecordWarn(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_WARN, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel de Erro.                 |
//+------------------------------------------------------------------+
SLogRecord LogRecordError(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_ERROR, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel Fatal.                   |
//+------------------------------------------------------------------+
SLogRecord LogRecordFatal(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_FATAL, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Transforma o path do programa em forma de pacote <aa.bb.cc>.     |
//+------------------------------------------------------------------+
string getPackage(string pathProgram)
   {
// De    C:\Users\qdev\AppData\Roaming\MetaQuotes\Terminal\9AA5A2E564E1326FB93349159C9D30A4\MQL5\Experts\ALARA\Logging.mq5
// Para  Experts.ALARA.Logging
    static string TERM_DATA_PATH = TerminalInfoString(TERMINAL_DATA_PATH);
    static int    PACK_INIT_PATH = StringLen(TERM_DATA_PATH) + 6;  // ...\MQL5\...

    string package = pathProgram;
    if(StringFind(pathProgram, TERM_DATA_PATH) == 0)
       {
        int endPath = StringLen(pathProgram) - PACK_INIT_PATH - 4;
        package = StringSubstr(pathProgram, PACK_INIT_PATH, endPath);
        StringReplace(package, "\\", ".");
       }

    return package;
   }


//+------------------------------------------------------------------+
