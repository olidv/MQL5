//+------------------------------------------------------------------+
//|                                         EA_CSV_WriteBookTick.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

#define EA_TIMER    120  // timer em segundos

int     tickCont        = 0,
        bookCont        = 0,
        tradeCont       = 0,
        transactionCont = 0; 

bool    marketBook = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    ResetLastError();
    // É preciso abrir o acesso aos dados do book
    if (! MarketBookAdd(_Symbol))  // Abertura da Profundidade de Mercado (DOM = Depth of Market)
        Print("ERRO: Não foi possível obter o Livro de Ofertas : ", GetLastError());
        //return(INIT_FAILED);

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

void OnTrade() {
    ++tradeCont;
}

void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result) {
    ++transactionCont;
}

void OnTimer() {
    Print("----------------------------------------------------------------------");
    Print("#OnTick() = ", tickCont, " | #OnBookEvent() = ", bookCont, " | #OnTrade() = ", tradeCont, " | #OnTradeTransaction() = ", transactionCont);

    //---
    tickCont = 0;
    bookCont = 0;
    tradeCont = 0;
    transactionCont = 0;

    if (! marketBook)
        marketBook = MarketBookAdd(_Symbol);
}

void OnDeinit(const int reason) {
    //--- destroy timer
    EventKillTimer();
    MarketBookRelease(_Symbol);
}

//+------------------------------------------------------------------+
