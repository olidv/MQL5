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

//program file         FillingType.mqh
//program package      MQL5/Include/ALARA/Trading/Magic/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************

#property library


//+------------------------------------------------------------------+
//| Enumeration EFillingType.                                        |
//|                                                                  |
//| Usage: Valores para identificar o tipo de preenchimento do       |
//|        volume a ser utilizado ao enviar ordens.                  |
//+------------------------------------------------------------------+
enum EFillingType
   {
//--- Tipo de preenchimento para ordens a mercado ou pedentes:
    FILLING_FOK      = 01,   // o mesmo significado de ORDER_FILLING_FOK
    FILLING_IOC      = 02,   // o mesmo significado de ORDER_FILLING_IOC

//--- Tipo de preenchimento apenas para ordens pedentes:
    FILLING_RETURN   = 03    // o mesmo significado de ORDER_FILLING_RETURN
   };


//+------------------------------------------------------------------+
