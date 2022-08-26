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

//program file         BrokerLogin.mqh
//program package      MQL5/Include/ALARA/Trading/Magic/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************

#property library


//+------------------------------------------------------------------+
//| Enumeration EBrokerLogin.                                        |
//|                                                                  |
//| Usage: Informa o tipo de conta e a corretora utilizada pelo EA.  |
//+------------------------------------------------------------------+
enum EBrokerLogin
   {
//--- Contas demo para desenvolvimento e testes:
    BROKER_DEMO_METAQUOTES    = 0,    // BROKER DEMO DO METATRADER, FORNECIDA PELA METAQUOTES.
    BROKER_DEMO_ICMARKET      = 1,   // IC MARKETS (EU) LTD. LICENSE NUMBER 362/18

//--- Contas reais em producao:
    BROKER_REAL_GENIAL        = 5,   // GENIAL INVESTIMENTOS CORRETORA DE VALORES MOBILIARIOS S.A. CNPJ  27.652.684/0001-62
    BROKER_REAL_MODAL         = 6,   // MODAL DISTRIBUIDORA DE TITULOS E VALORES MOBILIARIOS LTDA. CNPJ 05.389.174/0001-01
    BROKER_REAL_XMGLOBAL      = 7,   // XM GLOBAL LIMITED. LICENSE NUMBER 000261/309
    BROKER_REAL_ICMARKET      = 8    // IC MARKETS (EU) LTD. LICENSE NUMBER 362/18
   };


//+------------------------------------------------------------------+
