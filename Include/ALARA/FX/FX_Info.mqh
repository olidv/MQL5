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

//program file         
//program package      MQL5/Include/ALARA/
#property version	   "1.000"
#property description  "..."

//**********************************************************************************************  

#property library


//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
//--- Numero de digitos para os ativos operados:
#define USD_DIGITOS        5     // Mini contratos de cotacao do Dolar
#define USD_FATOR     100000     // Fator de multiplicacao para manipulacao como inteiro

#define JPY_DIGITOS        3     // Mini contratos de indice Bovespa
#define JPY_FATOR       1000     // Fator de multiplicacao para manipulacao como inteiro

//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import

//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import

//+------------------------------------------------------------------+
//| EX5 exports                                                      |
//+------------------------------------------------------------------+

//--- Informa as 3 primeiras letras do ativo corrente.
const int SIMBOLO_DIGITOS = StringFind(_Symbol, "JPY") > -1 ? JPY_DIGITOS : USD_DIGITOS;
//--- 
const int SIMBOLO_FATOR = StringFind(_Symbol, "JPY") > -1 ? JPY_FATOR : USD_FATOR;

//+------------------------------------------------------------------+
//| Converte o preco para inteiro, retirando o ponto decimal.        |
//+------------------------------------------------------------------+
int PrecoInteiro(double preco) {
    //--- 
    return (int) MathFloor(preco * SIMBOLO_FATOR);
}

//+------------------------------------------------------------------+
//| Informa se o Mercado Forex ja iniciou.                           |
//+------------------------------------------------------------------+
bool IniciouNegociacaoForex() {
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);  // Data-hora da estacao local
    
    bool isForexOpen = false;
    int hor = dt_struct.hour,
        min = dt_struct.min,
        dow = dt_struct.day_of_week;
                
    // verifica os horarios de abertura e fechamento:
    switch (dow) {
        case MONDAY:
        case TUESDAY:
        case WEDNESDAY:
        case THURSDAY:
            isForexOpen = true;
            break;
        case FRIDAY:
            isForexOpen = (hor < 19);
            break;
        case SATURDAY:
            isForexOpen = false;
            break;
        case SUNDAY:
            isForexOpen = (hor >= 18);
            break;
    }    
    
    return isForexOpen;
}

//+------------------------------------------------------------------+
//| Informa se o Mercado Forex ja foi encerrado.                     |
//+------------------------------------------------------------------+
bool EncerrouNegociacaoForex() {
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);  // Data-hora da estacao local
    
    bool isForexClose = false;
    int hor = dt_struct.hour,
        min = dt_struct.min,
        dow = dt_struct.day_of_week;
                
    // verifica apenas o horario de fechamento:
    switch (dow) {
        case MONDAY:
        case TUESDAY:
        case WEDNESDAY:
        case THURSDAY:
            isForexClose = false;
            break;
        case FRIDAY:
            isForexClose = (hor >= 19);
            break;
        case SATURDAY:
            isForexClose = true;
            break;
        case SUNDAY:
            isForexClose = false;
            break;
    }    
    
    return isForexClose;
}
