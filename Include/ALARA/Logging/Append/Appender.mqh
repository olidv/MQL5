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

//program file         Appender.mqh
//program package      MQL5/Include/ALARA/Logging/Append/
#property version	   "1.000"
#property description  "..."

//**********************************************************************************************  

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
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
