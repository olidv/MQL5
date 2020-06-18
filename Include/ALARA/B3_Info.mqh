//+------------------------------------------------------------------+
//|                                                      B3_Info.mqh |
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

//--- Mercado de Derivativos > Mercado Futuro > Ativos Financeiros > Mini Contratos
#define HOR_INI_B3        09    // horario de inicio da B3, para fins de coleta de dados
#define HOR_FIM_B3        18    // horario de encerramento da B3, para fins de coleta de dados

#define HOR_INI_MINCTT    09    // horario de inicio do pregao na B3
#define MIN_INI_MINCTT    00    // para mini contratos, inicia as 09h 00min

#define HOR_FIM_MINCTT    17    // horario de finalizacao do pregao na B3
#define MIN_FIM_MINCTT    55    // para mini contratos, finaliza as 17h 55min

//--- Mercado a Vista > Ações
#define HOR_INI_MVISTA    10    // horario de inicio do pregao na B3
#define MIN_INI_MVISTA    00    // para mercado a vista, inicia as 10h 00min

#define HOR_FIM_MVISTA    16    // horario de finalizacao do pregao na B3
#define MIN_FIM_MVISTA    55    // para mercado a vista, finaliza as 16h 55min

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

const int SIMBOLO_DIGITOS = SBL == "WIN" ? WIN_DIGITOS :
                            SBL == "WDO" ? WDO_DIGITOS :
                                           ACAO_DIGITOS;
//--- 
const int SIMBOLO_FATOR = SBL == "WIN" ? WIN_FATOR :
                          SBL == "WDO" ? WDO_FATOR :
                                         ACAO_FATOR;

//+------------------------------------------------------------------+
//| Converte o preco para inteiro, retirando o ponto decimal.        |
//+------------------------------------------------------------------+
int PrecoInteiro(double preco) {
    //--- 
    return (int) MathFloor(preco * SIMBOLO_FATOR);
}

//+------------------------------------------------------------------+
//| Informa se o pregao da B3 ja iniciou.                            |
//+------------------------------------------------------------------+
bool IniciouPregaoB3() {
    MqlDateTime dt_struct;
    TimeLocal(dt_struct);  // Data-hora da estacao local
    
    return (dt_struct.hour >= HOR_INI_B3) && ! EncerrouPregaoB3();
}

bool IniciouPregaoMiniContratos() {
    MqlDateTime dt_struct;
    TimeLocal(dt_struct);  // Data-hora da estacao local
    
    return (dt_struct.hour >= HOR_INI_MINCTT) && ! EncerrouPregaoMiniContratos();
}

bool IniciouPregaoMercadoVista() {
    MqlDateTime dt_struct;
    TimeLocal(dt_struct);  // Data-hora da estacao local
    
    return (dt_struct.hour >= HOR_INI_MVISTA) && ! EncerrouPregaoMercadoVista();
}

//+------------------------------------------------------------------+
//| Informa se o pregao da B3 chegou ao fim.                         |
//+------------------------------------------------------------------+
bool EncerrouPregaoB3() {
    MqlDateTime dt_struct;
    TimeLocal(dt_struct);  // Data-hora da estacao local
    
    return (dt_struct.hour >= HOR_FIM_B3);
}

bool EncerrouPregaoMiniContratos() {
    MqlDateTime dt_struct;
    TimeLocal(dt_struct);  // Data-hora da estacao local
    
    return (dt_struct.hour > HOR_FIM_MINCTT) ||
           (dt_struct.hour == HOR_FIM_MINCTT && dt_struct.min > MIN_FIM_MINCTT);
}

bool EncerrouPregaoMercadoVista() {
    MqlDateTime dt_struct;
    TimeLocal(dt_struct);  // Data-hora da estacao local
    
    return (dt_struct.hour > HOR_FIM_MVISTA) ||
           (dt_struct.hour == HOR_FIM_MVISTA && dt_struct.min > MIN_FIM_MVISTA);
}

//+------------------------------------------------------------------+
