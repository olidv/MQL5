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

//program file         EA_Broker_modelo.mqh
//program package      MQL5/Experts/ALARA/Common/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include <ALARA\BR_EvE.mqh>  // Funcoes utilitarias de uso geral (Enumerators e Evaluators).
#include <ALARA\GlobalVar.mqh>  // Manutencao de variaveis globais no terminal.
#include <ALARA\Trading\TradeHelper.mqh>  // Funcoes helpers para auxilio as operacoes de trading.


//+------------------------------------------------------------------+
//--- timer em segundos e/ou milissegundos:
#define TIMER_SECONDS       10
#define TIMER_MILLISECONDS  10000


//+------------------------------------------------------------------+
//--- Helper para manutencao da varivael global referenciada:
CGlobalVar* gVar = NULL;
string      sVar = Symbol();


//+------------------------------------------------------------------+
//| Funcao executada na inicializacao do expert-advisor.             |
//+------------------------------------------------------------------+
int OnInit()
   {
//--- Inicializa os recursos utilizados pelo expert-advisor.
    gVar = new CGlobalVar(sVar, GLOBAL_VAR_TEMP);

//--- Configura e inicia timer, para disparo a cada periodo de segundos:
    if(! EventSetTimer(TIMER_SECONDS))
        return(INIT_FAILED);

//--- Inicializacao do expert-broker efetuada com sucesso.
    return INIT_SUCCEEDED;
   }


//+------------------------------------------------------------------+
//| Funcao executada no disparo do evento Trade pelo terminal.       |
//+------------------------------------------------------------------+
void OnTrade()
   {
//---
   }


//+-----------------------------------------------------------------------+
//| Funcao executada no disparo do evento TradeTransaction pelo terminal. |
//+-----------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
   {
//---
   }


//+------------------------------------------------------------------+
//| Funcao executada no disparo do evento timer do relogio interno.  |
//+------------------------------------------------------------------+
void OnTimer()
   {
//---
   }


//+------------------------------------------------------------------+
//| Funcao executada no encerramento do expert-advisor.              |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
//--- Imediatamente cancela timer para nao ser mais disparado.
    EventKillTimer();

//--- Liberacao dos recursos para encerramento do expert-advisor.
    if(gVar != NULL)
       {
        delete gVar;
        gVar = NULL;
       }
   }


//+------------------------------------------------------------------+
