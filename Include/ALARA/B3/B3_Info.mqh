/*
===============================================================================

 package: MQL5\Include\_B3

 module : B3_Info.mqh
 
===============================================================================
*/
#property copyright   "Copyright 2021, ALARA Investimentos"
#property link        "http://www.alara.com.br"
#property version     "1.00"
#property description ""
#property description ""

#property library

//+------------------------------------------------------------------+
//| Defines Constants                                                |
//+------------------------------------------------------------------+

//--- Numero de digitos para os ativos operados:
#define WIN_DIGITOS        0     // Mini contratos de indice Bovespa
#define WIN_FATOR          1     // Fator de multiplicacao para manipulacao como inteiro

#define WDO_DIGITOS        1     // Mini contratos de cotacao do Dolar
#define WDO_FATOR         10     // Fator de multiplicacao para manipulacao como inteiro

#define ACAO_DIGITOS       2     // Ações do Mercado a Vista
#define ACAO_FATOR       100     // Fator de multiplicacao para manipulacao como inteiro

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
const string SBL = StringSubstr(Symbol(), 0, 3);

const int SIMBOLO_DIGITOS = (SBL == "WIN" || SBL == "IND") ? WIN_DIGITOS :
                            (SBL == "WDO" || SBL == "DOL") ? WDO_DIGITOS :
                                                             ACAO_DIGITOS;
//--- 
const int SIMBOLO_FATOR = (SBL == "WIN" || SBL == "IND") ? WIN_FATOR :
                          (SBL == "WDO" || SBL == "DOL") ? WDO_FATOR :
                                                           ACAO_FATOR;

//+------------------------------------------------------------------+
//| Converte o preco para inteiro, retirando o ponto decimal.        |
//+------------------------------------------------------------------+
int PrecoInteiro(double preco) {
    //--- 
    return (int) MathFloor(preco * SIMBOLO_FATOR);
}

int PrecoInteiro(string simbolo, double preco) {
    string sigla = StringSubstr(simbolo, 0, 3);
    int fator = (sigla == "IND" || sigla == "WIN") ? 1 :  // Indice cheio ou mini
                (sigla == "DOL" || sigla == "WDO") ? 10 : // Dolar cheio ou mini
                                                     100; // S&P ou acao
    // valor do preco em inteiro, com decimais a direita.
    return (int) MathFloor(preco * fator);
}

//+------------------------------------------------------------------+
//| Informa se a sessao de negociacao da B3 ja iniciou.                            |
//+------------------------------------------------------------------+
bool IniciouNegociacaoB3() { // Seg a Sex, 9h as 18h30
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);  // Data-hora da estacao local

    bool isB3Open = false;
    int hor = dt_struct.hour,
        min = dt_struct.min,
        dow = dt_struct.day_of_week;

    // verifica os horarios de abertura e fechamento:
    switch (dow) {
        case MONDAY:
        case TUESDAY:
        case WEDNESDAY:
        case THURSDAY:
        case FRIDAY:
            isB3Open = ( (hor >= 9 && hor <= 17) || (hor == 18 && min < 30) );
            break;
        case SATURDAY:
        case SUNDAY:
            isB3Open = false;
            break;
    }    

    return isB3Open;
}

bool IniciouNegociacaoMiniIndice() { // Seg a Sex, 9h as 18h25
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);  // Data-hora da estacao local

    bool isB3Open = false;
    int hor = dt_struct.hour,
        min = dt_struct.min,
        dow = dt_struct.day_of_week;

    // verifica os horarios de abertura e fechamento:
    switch (dow) {
        case MONDAY:
        case TUESDAY:
        case WEDNESDAY:
        case THURSDAY:
        case FRIDAY:
            isB3Open = ( (hor >= 9 && hor <= 17) || (hor == 18 && min < 25) );
            break;
        case SATURDAY:
        case SUNDAY:
            isB3Open = false;
            break;
    }    

    return isB3Open;
}

bool IniciouNegociacaoMiniDolar() { // Seg a Sex, 9h as 18h30
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);  // Data-hora da estacao local

    bool isB3Open = false;
    int hor = dt_struct.hour,
        min = dt_struct.min,
        dow = dt_struct.day_of_week;

    // verifica os horarios de abertura e fechamento:
    switch (dow) {
        case MONDAY:
        case TUESDAY:
        case WEDNESDAY:
        case THURSDAY:
        case FRIDAY:
            isB3Open = ( (hor >= 9 && hor <= 17) || (hor == 18 && min < 30) );
            break;
        case SATURDAY:
        case SUNDAY:
            isB3Open = false;
            break;
    }    

    return isB3Open;
}

bool IniciouNegociacaoMercadoVista() { // 10h às 17h55
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);  // Data-hora da estacao local

    bool isB3Open = false;
    int hor = dt_struct.hour,
        min = dt_struct.min,
        dow = dt_struct.day_of_week;

    // verifica os horarios de abertura e fechamento:
    switch (dow) {
        case MONDAY:
        case TUESDAY:
        case WEDNESDAY:
        case THURSDAY:
        case FRIDAY:
            isB3Open = ( (hor >= 10 && hor <= 16) || (hor == 17 && min < 55) );
            break;
        case SATURDAY:
        case SUNDAY:
            isB3Open = false;
            break;
    }    

    return isB3Open;
}

//+------------------------------------------------------------------+
//| Informa se a sessao de negociacao da B3 chegou ao fim.                         |
//+------------------------------------------------------------------+
bool EncerrouNegociacaoB3() { // Seg a Sex, 9h as 18h30
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);  // Data-hora da estacao local

    bool isB3Close = false;
    int hor = dt_struct.hour,
        min = dt_struct.min,
        dow = dt_struct.day_of_week;

    // verifica apenas o horario de fechamento:
    switch (dow) {
        case MONDAY:
        case TUESDAY:
        case WEDNESDAY:
        case THURSDAY:
        case FRIDAY:
            isB3Close = ( (hor == 18 && min >= 30) || (hor >= 19) );
            break;
        case SATURDAY:
        case SUNDAY:
            isB3Close = true;
            break;
    }    

    return isB3Close;
}

bool EncerrouNegociacaoMiniIndice() { // Seg a Sex, 9h as 18h25
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);  // Data-hora da estacao local

    bool isB3Close = false;
    int hor = dt_struct.hour,
        min = dt_struct.min,
        dow = dt_struct.day_of_week;

    // verifica apenas o horario de fechamento:
    switch (dow) {
        case MONDAY:
        case TUESDAY:
        case WEDNESDAY:
        case THURSDAY:
        case FRIDAY:
            isB3Close = ( (hor == 18 && min >= 25) || (hor >= 19) );
            break;
        case SATURDAY:
        case SUNDAY:
            isB3Close = true;
            break;
    }    

    return isB3Close;
}

bool EncerrouNegociacaoMiniDolar() { // Seg a Sex, 9h as 18h30
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);  // Data-hora da estacao local

    bool isB3Close = false;
    int hor = dt_struct.hour,
        min = dt_struct.min,
        dow = dt_struct.day_of_week;

    // verifica apenas o horario de fechamento:
    switch (dow) {
        case MONDAY:
        case TUESDAY:
        case WEDNESDAY:
        case THURSDAY:
        case FRIDAY:
            isB3Close = ( (hor == 18 && min >= 30) || (hor >= 19) );
            break;
        case SATURDAY:
        case SUNDAY:
            isB3Close = true;
            break;
    }    

    return isB3Close;
}

bool EncerrouNegociacaoMercadoVista() { // Seg a Sex, 10h às 17h55
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);  // Data-hora da estacao local

    bool isB3Close = false;
    int hor = dt_struct.hour,
        min = dt_struct.min,
        dow = dt_struct.day_of_week;

    // verifica apenas o horario de fechamento:
    switch (dow) {
        case MONDAY:
        case TUESDAY:
        case WEDNESDAY:
        case THURSDAY:
        case FRIDAY:
            isB3Close = ( (hor == 17 && min >= 55) || (hor >= 18) );
            break;
        case SATURDAY:
        case SUNDAY:
            isB3Close = true;
            break;
    }    

    return isB3Close;
}

//+------------------------------------------------------------------+
