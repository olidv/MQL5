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

//program file         SA_QuantModerator.mqh
//program package      MQL5/Services/ALARA/Common/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************

#property service


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include <ALARA\BR_EvE.mqh>  // Funcoes utilitarias de uso geral (Enumerators e Evaluators).
#include <ALARA\GlobalVar.mqh>  // Manutencao de variaveis globais no terminal.
#include <ALARA\Trading\TradeHelper.mqh>  // Funcoes helpers para auxilio as operacoes de trading.


//+------------------------------------------------------------------+
//--- timer em segundos e/ou milissegundos
#define TIMER_SECONDS       5
#define TIMER_MILLISECONDS  4999  // compensa por eventuais atrasos


//+------------------------------------------------------------------+
//--- Helper para manutencao da varivael global referenciada:
CGlobalVar* gVar = NULL;
string      sVar = Symbol();


//+------------------------------------------------------------------+
//| Funcao executada na inicializacao do service.                    |
//+------------------------------------------------------------------+
void OnStart()
   {
//--- Inicializa os recursos utilizados pelo service-advisor.
    gVar = new CGlobalVar(sVar, GLOBAL_VAR_TEMP);

//--- Loop continuo para varredura das variaveis globais:
    while(! IsStopped())
       {
        //--- Executa o processamento interno e principal do servico.
        if(! OnLoop())
            break;  // se nao ira mais executar, entao sai do loop.

        //--- aguarda alguns segundos antes da proxima iteracao:
        Sleep(TIMER_MILLISECONDS);
       }

//--- Liberacao dos recursos para encerramento do service-advisor.
    OnStop();
    return;
   }


//+------------------------------------------------------------------+
//| Funcao para a execucao do processamento principal do servico.    |
//+------------------------------------------------------------------+
bool OnLoop()
   {
    Print("Seviço esta em execução");

//--- se tudo ok ainda, informa que o loop pode/deve continuar...
    return true;
   }


//+------------------------------------------------------------------+
//| Funcao executada no encerramento do service.                     |
//+------------------------------------------------------------------+
void OnStop()
   {
//--- Liberacao dos recursos para encerramento do service-advisor.
    if(gVar != NULL)
       {
        delete gVar;
        gVar = NULL;
       }
   }


//+------------------------------------------------------------------+
