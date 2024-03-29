//+------------------------------------------------------------------+
//|                                                FastBookEvent.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <ALARA\WinAPI_Time.mqh>

//+------------------------------------------------------------------+

#define TIMER       10       // timer em segundos

#define DIFF_SIZE   1000    // 0 a 999 milisegundos
#define DIFF_QTDE   999.0   // para calculo da media em double

#define DATA_SIZE   300000  // media de 100 por segundo (disparando cada 10 milisegundos)

SYSTEMTIME lastBookTime, lastTickTime, startTimer, stopTimer;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    GetLocalTime(startTimer);

    Print("EA: FAST-BOOK-EVENT com TIMER = ",TIMER," seg");
    Print("----------------------------------------------------------------------");

    //--- setup timer
    EventSetTimer(TIMER);
    
    // É preciso abrir o acesso aos dados do book
    MarketBookAdd(_Symbol); // Abertura da Profundidade de Mercado (DOM = Depth of Market)

    //---
    return(INIT_SUCCEEDED);
}

//---
static int bookCont = 0;
static SYSTEMTIME  bookTimes[DATA_SIZE];

//+------------------------------------------------------------------+
//| Book DOM Event Function                                          |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol) {
    //---
    static bool result = false;

    //--- ignora outros símbolos.
    if (symbol != _Symbol) return;

    //---
    MqlBookInfo bookInfo[];
        // ENUM_BOOK_TYPE type        : Tipo de ordem proveniente da enumeração ENUM_BOOK_TYPE
        // double         price       : Preço
        // long           volume      : Volume
        // double         volume_real : Volume com maior precisão

    result = MarketBookGet(_Symbol, bookInfo);
    if (result) {
        GetLocalTime(bookTimes[bookCont]);
        lastBookTime = bookTimes[bookCont];
        bookCont++;
    }
}

//+------------------------------------------------------------------+
//| Timer Event Function: 60 segundos = 1 minuto                     |
//+------------------------------------------------------------------+
void OnTimer() {
    GetLocalTime(stopTimer);
    
    //--- apenas executa 1 unica vez.
    EventKillTimer();
    MarketBookRelease(_Symbol);

    Print("  startTimer : ",SystemTimeToString(startTimer));
    Print("   stopTimer : ",SystemTimeToString(stopTimer));
    Print("");
    Print("lastBookTime : ",SystemTimeToString(lastBookTime));
    Print("----------------------------------------------------------------------");

    //---
    if (bookCont > 0) {
        int bookDiffs[DIFF_SIZE];

        double media = DiffMedia(bookCont, bookTimes, bookDiffs);
        //for (int i = 0; i < DIFF_SIZE; i++) {
        //    if (bookDiffs[i] > 0)
        //        Print("BOOK Diff[",i,"] = ", bookDiffs[i]);
        //}
        
        Print("BOOKs Obtidos = ", bookCont, " / Media de Tempo = ", DoubleToString(media, 4), " milissegundos");
        Print("----------------------------------------------------------------------");

        //---
        bookCont = 0;
    } else {
        Print("BOOKs Obtidos = 0");
        Print("----------------------------------------------------------------------");
    }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- destroy timer
    EventKillTimer();

    // Encerra a inscrição ao book de mercado (DOM)
    MarketBookRelease(_Symbol); // Tira da memória o espaço alocado.
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double DiffMedia(int cont, SYSTEMTIME &times[], int &diffs[]) {
    int inc = 0, som = 0, prevMils = 0, nextMils = 0;

    ArrayFill(diffs, 0, DIFF_SIZE, 0);
    prevMils = GetMillisecondsTime(times[0]);
    for (int i = 0; i < cont; i++) {
        nextMils = GetMillisecondsTime(times[i]);
        inc = nextMils - prevMils;
        if(inc < DIFF_SIZE)
            diffs[inc] += 1;
        else
            diffs[DIFF_SIZE-1] += 1;

        som += inc;
        prevMils = nextMils;
    }

    // manipula em double para melhor precisao:
    return (som / DIFF_QTDE); // ignora a 1ª posicao.
}
   
//+------------------------------------------------------------------+
