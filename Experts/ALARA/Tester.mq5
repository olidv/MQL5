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

//program file         TradeHelper.mqh
//program package      MQL5/Include/ALARA/Trading/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include <ALARA\BR_EvE.mqh>   // Funcoes utilitarias de uso geral (Enumerators e Evaluators).
#include <ALARA\Trading\TradeHelper.mqh>


//+------------------------------------------------------------------+
//---


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
//---
    bool ok = isTradeOk();
    Print("isTradeOk() = ", ok);
    
    string msg;
    ok = isTradeOk(msg);
    Print("isTradeOk(msg) = ", ok);
    Print("    msg = ", msg);
    
//---
    return(INIT_SUCCEEDED);
   }


//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
//---

   }


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
   {
//---

   }


//+------------------------------------------------------------------+
