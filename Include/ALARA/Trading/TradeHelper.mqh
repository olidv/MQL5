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

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include <ALARA\BR_EvE.mqh>              // Funcoes utilitarias de uso geral (Enumerators e Evaluators).


//+------------------------------------------------------------------+
//---
//#define A B


//+------------------------------------------------------------------+
//|  Informa quando aparece uma nova barra no grafico corrente.      |
//+------------------------------------------------------------------+
bool isNewBar()
   {
//--- var inicializada apenas uma vez: armazenamos o tempo de abertura da barra atual
    static datetime lastbar_time = 0;  //

//--- obtemos o tempo de abertura da barra zero (corrente)
    datetime currbar_time = iTime(NULL, PERIOD_CURRENT, 0);

//--- se o tempo de abertura mudar, eh porque apareceu uma nova barra:
    if(currbar_time != lastbar_time && currbar_time > 0)  // tambem testa se nao houve erro...
       {
        lastbar_time = currbar_time;
        //--- temos uma nova barra:
        return (true);
       }

//--- nao ha nenhuma barra nova
    return (false);
   }
//--- Efetua uma chamda inicial a funcao isNewBar() para inicializar a variavel estatica:
bool none_var = isNewBar();


//+------------------------------------------------------------------+
//|  Informa se eh possivel realizar algo-trading no momento.        |
//+------------------------------------------------------------------+
bool isTradeOk()
   {
//--- verifica se ha conexao com o servidor de negociacao:
    if(! TerminalInfoInteger(TERMINAL_CONNECTED))
        return false;

//--- verifica se a negociacao eh permitida para a conta corrente:
    if(!AccountInfoInteger(ACCOUNT_TRADE_ALLOWED))
        return false;

//--- verifica se a negociacao eh permitida para qualquer Expert Advisors/Scripts na conta corrente:
    if(!AccountInfoInteger(ACCOUNT_TRADE_EXPERT))
        return false;

//--- Verifica se ha permissao para realizar a negociacao automatizada no terminal:
    if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
        return false;

//--- verifica se a negociacao foi habilitada na execucao do Expert-Advisor/Script corrente:
    if(! MQLInfoInteger(MQL_TRADE_ALLOWED))
        return false;

//--- se tudo ok, informa que a negociacao automatiza eh possivel no momento:
    return true;
   }

//+------------------------------------------------------------------+
//|  Informa se eh possivel realizar algo-trading no momento e       |
//|  retorna uma mensagem de erro que explica o motivo.              |
//+------------------------------------------------------------------+
bool isTradeOk(string& msgErro)
   {
//--- verifica se ha conexao com o servidor de negociacao:
    if(! TerminalInfoInteger(TERMINAL_CONNECTED))
       {
        msgErro = "A Negociacao Automatizada nao eh possivel por nao haver conexao com o servidor.";
        return false;
       }

//--- verifica se a negociacao eh permitida para a conta corrente:
    if(!AccountInfoInteger(ACCOUNT_TRADE_ALLOWED))
       {
        msgErro = "A Negociacao Automatizada esta proibida para a conta " +
                  IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) +
                  " no lado do servidor de negociacao.";
        return false;
       }

//--- verifica se a negociacao eh permitida para qualquer Expert-Advisors/Scripts na conta corrente:
    if(!AccountInfoInteger(ACCOUNT_TRADE_EXPERT))
       {
        msgErro = "A Negociacao Automatizada com Expert-Advisors/Scripts esta proibida para a conta " +
                  IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) +
                  " no lado do servidor de negociacao.";
        return false;
       }

//--- Verifica se ha permissao para realizar a negociacao automatizada no terminal:
    if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
       {
        msgErro = "A Negociacao Automatizada nao foi habilitada nas configuracoes do terminal.";
        return false;
       }

//--- verifica se a negociacao foi habilitada na execucao do Expert-Advisor/Script corrente:
    if(! MQLInfoInteger(MQL_TRADE_ALLOWED))
       {
        msgErro = "A Negociacao Automatizada nao foi habilitada na execucao do Expert-Advisor/Scrit corrente.";
        return false;
       }

//--- se tudo ok, informa que a negociacao automatiza eh possivel no momento:
    return true;
   }


//--- MANUTENCAO DE VARIAVEIS GLOBAIS NO TERMINAL --------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
