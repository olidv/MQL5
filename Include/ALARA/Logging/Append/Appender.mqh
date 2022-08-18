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
#include "AppendType.mqh"
#include "..\LogRecord.mqh"


//+------------------------------------------------------------------+
//| Interface IAppender.                                             |
//|                                                                  |
//| Usage: Definicao de metodos para as classes concretas que        |
//|        efetuam a publicacao das mensagens de logging.            |
//+------------------------------------------------------------------+
interface IAppender
   {
//--- Informa o tipo de processamento e destinatario do appender:
    EAppendType getAppendType();

//--- Obtem o level para o appender.
    ELogLevel   getLevel();

//--- Verifica se o appender ira considerar o registro de logging.
    bool        isLoggable(const SLogRecord &record);

//--- Executa procedimentos de inicializacao para o appender.
    bool        start();

//--- Efetua o processamento e grava o registro de logging.
    bool        write(const SLogRecord &record);

//--- Encerra os recursos alocados e fecha arquivos, se necessario.
    bool        close();
   };


//+------------------------------------------------------------------+
