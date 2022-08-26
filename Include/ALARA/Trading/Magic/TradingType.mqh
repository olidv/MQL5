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

//program file         TradingType.mqh
//program package      MQL5/Include/ALARA/Trading/Magic/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************

#property library


//+------------------------------------------------------------------+
//| Enumeration ETradingType.                                         |
//|                                                                  |
//| Usage: Informa o estilo e temporizacao das operacoes de trading. |
//+------------------------------------------------------------------+
enum ETradingType
   {
//--- Operacoes de trading dentro do mesmo dia:
    TRADING_HIGHFREQ   = 1,   //
    TRADING_SCALPING   = 2,   //
    TRADING_INTRADAY   = 3,   //
    TRADING_DAY        = 4,   //

//--- Operacoes de trading de medio a longo prazo:
    TRADING_SWING      = 5,   //
    TRADING_POSITION   = 6,   //

//--- Operacoes no final de um periodo (dia, semana, mes):
    TRADING_EOD        = 7,   //
    TRADING_EOW        = 8,   //
    TRADING_EOM        = 9    //
   };


//+------------------------------------------------------------------+
