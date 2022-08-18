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
//| Enumeration ELogLevel.                                           |
//|                                                                  |
//| Usage: Categorizacao do nivel do registro de logging para        |
//|        identificar como a mensagem de logging sera registrada.   |
//|        Quanto maior o level (numero inteiro), maior a prioridade.|
//+------------------------------------------------------------------+
enum ELogLevel
   {
    LOG_LEVEL_ALL    = INT_MIN,   // Registrara tudo
    LOG_LEVEL_TRACE  = 100,       // Rastro da execucao
    LOG_LEVEL_DEBUG  = 200,       // Valores para debug
    LOG_LEVEL_INFO   = 300,       // Informacoes gerais
    LOG_LEVEL_WARN   = 400,       // Avisos (Warnings)
    LOG_LEVEL_ERROR  = 500,       // Erros serveros
    LOG_LEVEL_FATAL  = 600,       // Erros fatais e/ou criticos
    LOG_LEVEL_OFF    = INT_MAX    // Nada sera registrado
   };


//+------------------------------------------------------------------+
//| Converte um texto string em seu respectivo valor enumerado.      |
//+------------------------------------------------------------------+
ELogLevel StringToLevel(const string level) export
   {
//--- Relacao de todos os levels para facilitar validacao...
    static string LOG_LEVELS = "ALL, TRACE, DEBUG, INFO, INFOR, WARN, WARNG, ERROR, FATAL, OFF";

// valores invalidos automaticamente sao convertidos para LOG_LEVEL_OFF:
    if(level == NULL || level == "")
       {
        return LOG_LEVEL_OFF;
       }

// verifica se o valor trata-se de um level valido:
    string upperLevel = level;
    StringToUpper(upperLevel);
    if(StringFind(LOG_LEVELS, upperLevel) == -1)
       {
        return LOG_LEVEL_OFF;
       }

// se o valor eh um level valido, entao soh precisa testar o primeiro caractere:
    ushort l = StringGetCharacter(level, 0);
    switch(l)
       {
        case 'A':
            return LOG_LEVEL_ALL;
        case 'T':
            return LOG_LEVEL_TRACE;
        case 'D':
            return LOG_LEVEL_DEBUG;
        case 'I':
            return LOG_LEVEL_INFO;
        case 'W':
            return LOG_LEVEL_WARN;
        case 'E':
            return LOG_LEVEL_ERROR;
        case 'F':
            return LOG_LEVEL_FATAL;
        case 'O':
            return LOG_LEVEL_OFF;
        default:  // qualquer valor invalido eh convertido para ELevel.OFF:
            return LOG_LEVEL_OFF;
       }
   }


//+------------------------------------------------------------------+
//| Converte um valor enumerado para sua representacao em string.    |
//+------------------------------------------------------------------+
string LevelToString(const ELogLevel level) export
   {
// valores invalidos nao podem ser convertidos:
    if(level == NULL)
       {
        return NULL;
       }

// obtem o Level correspondente ao texto string, sempre em maiusculas:
    switch(level)
       {
        case LOG_LEVEL_ALL:
            return "ALL  ";
        case LOG_LEVEL_TRACE:
            return "TRACE";
        case LOG_LEVEL_DEBUG:
            return "DEBUG";
        case LOG_LEVEL_INFO:
            return "INFO ";
        case LOG_LEVEL_WARN:
            return "WARN ";
        case LOG_LEVEL_ERROR:
            return "ERROR";
        case LOG_LEVEL_FATAL:
            return "FATAL";
        case LOG_LEVEL_OFF:
            return "OFF  ";
        default:
            return "";
       }
   }


//+------------------------------------------------------------------+
