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


//+------------------------------------------------------------------+
//| Enumeration EAppendType.                                         |
//|                                                                  |
//| Usage: Identificacao dos tipos de appenders utilizados para      |
//|        registrar as mensagens de logging.                        |
//+------------------------------------------------------------------+
enum EAppendType
   {
    APPEND_ALERT    =   1,   // Registra o logging em popup de alerta.
    APPEND_CHART    =   2,   // Registra o logging no grafico.
    APPEND_CONSOLE  =   4,   // Registra o logging na console.
    APPEND_FILE     =   8,   // Registra o logging me arquivo.
    APPEND_MAIL     =  16,   // Registra o logging enviando e-mail.
    APPEND_PUSH     =  32,   // Registra o logging enviando notificacao push.
    APPEND_SOUND    =  64,   // Registra o logging emitindo aviso sonoro.
    APPEND_NONE     = 128    // Nenhum registro de loggin sera feito.
   };


//+------------------------------------------------------------------+
