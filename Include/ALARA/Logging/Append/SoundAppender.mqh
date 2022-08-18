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
#include "AbstractAppender.mqh"


//+------------------------------------------------------------------+
//| Arquivos de som para emissao de notificacao sonora.              |
//+------------------------------------------------------------------+
#resource "\\Sounds\\fatal.wav"
#resource "\\Sounds\\error.wav"
#resource "\\Sounds\\warn.wav"
#resource "\\Sounds\\info.wav"

#define WAVE_FATAL "::Sounds\\fatal.wav"
#define WAVE_ERROR "::Sounds\\error.wav"
#define WAVE_WARN  "::Sounds\\warn.wav"
#define WAVE_INFO  "::Sounds\\info.wav"


//+------------------------------------------------------------------+
//| Class CSoundAppender.                                            |
//|                                                                  |
//| Usage: Notificacao das mensagens de logging na forma sonora.     |
//+------------------------------------------------------------------+
class CSoundAppender: public CAbstractAppender
   {
protected:
    //--- Grava o registro de logging.
    virtual bool        doAppend(const SLogRecord &record);

public:
    //--- Construtores: Inicializa o layout utilizado internamente na formatacao.
    void                CSoundAppender(const string name,
                                       const ELogLevel level) : CAbstractAppender(name, level) {};

    //--- Informa o tipo de processamento e destinatario do appender:
    virtual EAppendType getAppendType();
   };


//+------------------------------------------------------------------+
//| Informa o tipo deste appender.                                   |
//+------------------------------------------------------------------+
EAppendType CSoundAppender::getAppendType()
   {
    return APPEND_SOUND;
   }


//+------------------------------------------------------------------+
//| Imprime o registro de logging na console.                        |
//+------------------------------------------------------------------+
bool CSoundAppender::doAppend(const SLogRecord &record)
   {
// apenas considera o level do registro de logging, ignorando a mensagem.
    switch(record.level)
       {
        case LOG_LEVEL_FATAL:
            PlaySound(WAVE_FATAL);
            break;
        case LOG_LEVEL_ERROR:
            PlaySound(WAVE_ERROR);
            break;
        case LOG_LEVEL_WARN:
            PlaySound(WAVE_WARN);
            break;
        case LOG_LEVEL_INFO:
            PlaySound(WAVE_INFO);
            break;
       }

    return true;
   }


//+------------------------------------------------------------------+
