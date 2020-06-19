//+------------------------------------------------------------------+
//|                                         EA_CSV_WriteBookTick.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

#define EA_TIMER    125    // timer em segundos

int     tickCont = 0,
        bookCont = 0; 

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    // É preciso abrir o acesso aos dados do book
    if (! MarketBookAdd(_Symbol))  // Abertura da Profundidade de Mercado (DOM = Depth of Market)
        return(INIT_FAILED);

    //--- create timer
    if (! EventSetTimer(EA_TIMER)) 
        return(INIT_FAILED);

    //---
    return (INIT_SUCCEEDED);
}

void OnBookEvent(const string &symbol) {
    //--- ignora outros símbolos.
    if (symbol == _Symbol) 
        ++bookCont;
}

void OnTick() {
    ++tickCont;
}

void OnTimer() {
    Print("----------------------------------------------------------------------");
    Print("EA [", _Symbol, "] :  EXPERT-ADVISOR ENCERRADO!  Contador OnTick() = ", IntegerToString(tickCont,7), "  /  Contador de OnBookEvent() = ", IntegerToString(bookCont,7));

    //--- destroy timer
    EventKillTimer();
    MarketBookRelease(_Symbol);

    //--- Interrompe o Expert Advisor e o descarrega do gráfico
    ExpertRemove();
}

//+------------------------------------------------------------------+
