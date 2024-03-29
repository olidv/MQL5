//+------------------------------------------------------------------+
//|                                                    InfoTimer.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

#define CONT_TAMANHO  100000000000   // máximo de 100 por segundo (cada 10 milisegundos)

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    ulong ini = GetMicrosecondCount();
    
    int intSimples = 0;
    for (ulong i = 0; i < CONT_TAMANHO; i++) {
       intSimples++;
       intSimples = intSimples - 2;
       string a = "23";
       
    }  
    ulong stopIntSimples = GetMicrosecondCount();
    
    
    Print("int : ", (stopIntSimples - (double) ini));
    
    
    
    //---
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {}

//+------------------------------------------------------------------+
