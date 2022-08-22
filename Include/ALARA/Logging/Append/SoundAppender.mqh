/*
 ***********************************************************************************************
 Este programa de  computador contem informacoes  confidenciais de propriedade da ALARA CAPITAL,
 e esta  protegido pela lei de copyright. Voce nao  deve divulgar tais informacoes confidenciais 
 e  deve usa-las somente em  conformidade com os termos  do contrato de licenca  definidos  pela 
 ALARA CAPITAL. A reproducao ou distribuicao nao autorizada deste programa, ou de qualquer parte
 dele,  resultara na  imposicao de  rigorosas penas  civis e  criminais,  e sera  objeto de acao 
 judicial promovida na maxima extensao possivel, nos termos da lei.

 Parte integrante do repositorio de componentes, rotinas e artefatos  criados pela ALARA CAPITAL
 para o desenvolvimento de Trading Algorítmico na plataforma MetaQuotes MetaTrader for Desktop.
 ***********************************************************************************************
*/
#property copyright    "Copyright (C) 2020-2022, ALARA CAPITAL. Todos os direitos reservados."
#property link         "https://www.Alara.com.BR/"

//program file         
//program package      MQL5/Include/ALARA/
#property version	   "1.000"
#property description  "..."

//**********************************************************************************************  

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
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
