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

//program file         AppendType.mqh
//program package      MQL5/Include/ALARA/Logging/Append/
#property version	   "1.000"
#property description  "..."

//**********************************************************************************************  

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
