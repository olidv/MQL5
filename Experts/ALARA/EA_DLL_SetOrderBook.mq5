//+------------------------------------------------------------------+
//|                                         EA_CSV_WriteBookTick.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <ALARA\WinAPI_Time.mqh>

//--- Funcoes para processamento conforme a B3
#include <ALARA\B3_Info.mqh>

//+------------------------------------------------------------------+

#define EA_TIMER    10     // timer em segundos

//+------------------------------------------------------------------+

//---
struct SOrderBook {
    int          idBook;
    int          localTime;
    MqlBookInfo  bookInfo[];  // Ofertas de venda e compra do book
};

//+------------------------------------------------------------------+

//---
int idLastBook = 0;  // corresponde ao total de registros de book coletados

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    Print("EA [", _Symbol, "] :  CALL DLL ( BOOK )");
    Print("----------------------------------------------------------------------");

    //--- inicializa o processamento da DLL para BOOKs e TICKs:


    // É preciso abrir o acesso aos dados do book
    if (! MarketBookAdd(_Symbol))  // Abertura da Profundidade de Mercado (DOM = Depth of Market)
        return(INIT_FAILED);

    //--- create timer
    if (! EventSetTimer(EA_TIMER)) 
        return(INIT_FAILED);

    //---
    return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert book function                                             |
//| Este evento/funcao gasta em torno de 10 a 20 microsegundos para  |
//| ser executado, sendo disparado a cada 10 a 20 milisegundos.      |
//| A orientacao eh que este evento seja o mais breve, para nao      |
//| prejudicar os outros EA, pois como eh disparado via brodcasting, |
//| o dispara ocorre em todos os EA simultaneamente.                 |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol) {
    //--- ignora outros símbolos.
    if (symbol != _Symbol) return;

    // Ofertas de venda e compra do book
    SOrderBook book;
    if (MarketBookGet(_Symbol, book.bookInfo) && ArraySize(book.bookInfo) == BOOK_SIZE) {
        // data-hora local no momento da obtencao do book
        book.localTime = GetMillisecondsTime(); // soh a parte hora, em milissegundos
        
        // mais um regitro do livro de ofertas (order book):
        book.idBook = ++idLastBook;
        
        // Repassa o registro de book para a DLL:
        
    }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//| Periodicamente verifica se encerrou o pregao da B3 ou se o       |
//| programa foi encerrado por outro processo.                       |
//+------------------------------------------------------------------+
void OnTimer() {
    //---
    if (EncerrouPregaoB3() || _StopFlag) {
        //---
        MarketBookRelease(_Symbol);

        //--- destroy timer
        EventKillTimer();

        Print("----------------------------------------------------------------------");
        Print("EA [", _Symbol, "] :  Programa Encerrado! Total de BOOKs Obtidos = ", IntegerToString(idLastBook,7));
        
        //Interrompe o Expert Advisor e o descarrega do gráfico
        ExpertRemove();

    } else {
        Print("EA [", _Symbol, "] :  BOOKs Gravados = ", IntegerToString(idLastBook,7));
        Print("----------------------------------------------------------------------");
    }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- efetua o encerramento do timer:
    OnTimer();  // aqui o valor de _StopFlag = true
}

//+------------------------------------------------------------------+
