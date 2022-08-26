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

//program file         FormatType.mqh
//program package      MQL5/Include/ALARA/Logging/Format/
#property version	   "1.000"
#property description  "..."

//**********************************************************************************************  

#property library


//+------------------------------------------------------------------+
//| Definicoes dos layouts padroes para cada classe formatter        |
//| que utiliza uma formatacao textual simples (linha unica).        |
//+------------------------------------------------------------------+
#define LAYOUT_TEXT_SIMPLE        "%level %msg"
#define LAYOUT_TEXT_COMMENT       "%time %level %msg"
#define LAYOUT_TEXT_NOTIFICATION  "[%file] %level: %msg"
#define LAYOUT_TEXT_STREAM        "%time %level [%logger] %pack->%func{%line} %msg"


//+------------------------------------------------------------------+
//| Definicoes de layout padrao para classe formatter que utiliza    |
//| uma formatacao em HTML (trecho inserido no BODY).                |
//+------------------------------------------------------------------+
#define LAYOUT_HTML_MESSAGE       "<p>%time %level [%logger] %pack-&gt;%func&lt;%line&gt;</p><br/><p>%msg</p>"


//+------------------------------------------------------------------+
//| Enumeration EFormatType.                                         |
//|                                                                  |
//| Usage: Identifica o tipo de formatacao default utilizada         |
//|        ao criar / configurar um appender para o logger.          |
//+------------------------------------------------------------------+
enum EFormatType
   {
    FORMAT_TEXT  = 1,   // Formata o registro de logging em um linha textual simples.
    FORMAT_HTML  = 2,   // Formata o registro de logging como trecho de HTML.
   };


//+------------------------------------------------------------------+
//| A especificação do formato do layout segue o padrao para         |
//| formatacao de strings:  %word                                    |
//+------------------------------------------------------------------+
//
// word       Campo de SLogRecord
// -------    ---------------------
// %time   =  SLogRecord.timestamp
// %level  =  SLogRecord.level
// %name   =  SLogRecord.name
// %pack   =  SLogRecord.package
// %prog   =  SLogRecord.program
// %func   =  SLogRecord.function
// %line   =  SLogRecord.line
// %msg    =  SLogRecord.message


//+------------------------------------------------------------------+
