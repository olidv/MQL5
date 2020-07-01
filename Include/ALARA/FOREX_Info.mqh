//+------------------------------------------------------------------+
//|                                                   FOREX_Info.mqh |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
//#property copyright "Copyright 2020, ALARA Investimentos"
//#property link      "http://www.alara.com.br"
//#property version   "1.00"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
#define BOOK_SIZE         32    // limite de 32 posicoes obtidas do book no pregao

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
