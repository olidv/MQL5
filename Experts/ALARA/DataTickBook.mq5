//+------------------------------------------------------------------+
//|                                                 DataTickBook.mq5 |
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
#define BOOK_SIZE   32      // tamnho do book (DOM) para WIN e WDO
#define BOOK_IEND   31      // indice final do book (DOM) com 32 posicoes

SYSTEMTIME lastBookTime, lastTickTime, startTimer, stopTimer;

//+------------------------------------------------------------------+

//--- Estruturas para armazenar registros do book de ofertas (DOM) para o Mini Indice e Mini Dolar
struct SOrderMini {
    int         price;   // Preco, em pontos sem casas decimais
    int         volume;  // Volume
};

struct SBookMini {
    long        time;      // data-hora local em milissegundos
    SOrderMini  asks[16];  // Ofertas de venda, ordenadas da menor (0) para a maior (15)
    SOrderMini  bids[16];  // Ofertas de compra, ordenadas da maior (0) para a menor (15)
};

//--- Estruturas para armazenar registros do book de ofertas (DOM) para o Mini Dolar
struct SOrderWDO {
    float       price;   // Preco, em pontos sem casas decimais
    int         volume;  // Volume
};

struct SBookWDO {
    long        time;      // data-hora local em milissegundos
    SOrderWDO   asks[16];  // Ofertas de venda, ordenadas da menor (0) para a maior (15)
    SOrderWDO   bids[16];  // Ofertas de compra, ordenadas da maior (0) para a menor (15)
};

//--- Estrutura para armazenar registro do preco atual (tick) para Mini Indice e Mini Dolar
struct STickMini {
    long        time;         // Tempo do "Last" preço atualizado em milissegundos
    int         bid;          // Preco corrente de venda
    int         ask;          // Preco corrente de compra
    int         last;         // Preco da ultima operacao (ultimo preco)
    int         volume;       // Volume para o ultimo preco
    bool        flag_bid;     // Flag TICK_FLAG_BID – tick alterou o preco Bid 
    bool        flag_ask;     // Flag TICK_FLAG_ASK  – tick alterou o preco Ask
    bool        flag_last;    // Flag TICK_FLAG_LAST – tick alterou o ultimo preco da oferta
    bool        flag_volume;  // Flag TICK_FLAG_VOLUME – tick alterou o volume
    bool        flag_buy;     // Flag TICK_FLAG_BUY – tick eh resultado de uma compra
    bool        flag_sell;    // Flag TICK_FLAG_SELL – tick eh resultado de uma venda
};

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    GetLocalTime(startTimer);

    Print("EA: DATA-TICK-BOOK com TIMER = ",TIMER," seg");
    Print("----------------------------------------------------------------------");

    // É preciso abrir o acesso aos dados do book
    MarketBookAdd(_Symbol); // Abertura da Profundidade de Mercado (DOM = Depth of Market)

    //--- setup timer
    EventSetTimer(TIMER);

    //---
    return(INIT_SUCCEEDED);
}

//---
static int bookCont = 0;
static SYSTEMTIME  bookTimes[DATA_SIZE];
static SBookMini   bookData[DATA_SIZE];

//+------------------------------------------------------------------+
//| Book DOM Event Function                                          |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol) {
    //---
    static bool result = false;

    //--- ignora outros símbolos.
    if (symbol != _Symbol) return;

    //--- ja obtem a hora corrente:
    GetLocalTime(bookTimes[bookCont]);
    lastBookTime = bookTimes[bookCont];

    //---
    MqlBookInfo bookInfo[];
        // ENUM_BOOK_TYPE type        : Tipo de ordem proveniente da enumeração ENUM_BOOK_TYPE
        // double         price       : Preço
        // long           volume      : Volume
        // double         volume_real : Volume com maior precisão

    result = MarketBookGet(_Symbol, bookInfo);
    if (result && ArraySize(bookInfo) > BOOK_IEND) {
        SBookMini bookMini;
        bookMini.time = GetMillisecondsTime(bookTimes[bookCont]);
        for (int i = 15, j = 0; i >= 0; i--, j++) {
            // Ofertas de venda, ordenadas da menor (0) para a maior (15)
            bookMini.asks[j].price = (int) bookInfo[i].price;
            bookMini.asks[j].volume = (int) bookInfo[i].volume;
            
            // Ofertas de compra, ordenadas da maior (0) para a menor (15)
            bookMini.bids[j].price = (int) bookInfo[BOOK_IEND - i].price;
            bookMini.bids[j].volume = (int) bookInfo[BOOK_IEND - i].volume;
        }
        bookData[bookCont++] = bookMini;
    }
}

//---
static int tickCont = 0;
static SYSTEMTIME tickTimes[DATA_SIZE];
static STickMini  tickData[DATA_SIZE];

//+------------------------------------------------------------------+
//| Price Tick Event Function                                        |
//+------------------------------------------------------------------+
void OnTick() {
    //---
    static bool result = false;

    //--- ja obtem a hora corrente:
    GetLocalTime(tickTimes[tickCont]);
    lastTickTime = tickTimes[tickCont];

    //---
    MqlTick tickInfo;
        // datetime time;       : Hora da última atualização de preços
        // double   bid;        : Preço corrente de venda
        // double   ask;        : Preço corrente de compra
        // double   last;       : Preço da última operação (preço último)
        // ulong    volume;     : Volume para o preço último corrente
        // long     time_msc;   : Tempo do "Last" preço atualizado em  milissegundos
        // uint     flags;      : Flags de tick
        // double   volume_real : Volume para o preço Last atual com maior precisão

    result = SymbolInfoTick(_Symbol, tickInfo);
    if (result) {
        STickMini tickMini;
        tickMini.time = tickInfo.time_msc;
        tickMini.bid = (int) tickInfo.bid;
        tickMini.ask = (int) tickInfo.ask;
        tickMini.last = (int) tickInfo.last;
        tickMini.volume = (int) tickInfo.volume;
        tickMini.flag_bid = tickInfo.flags & TICK_FLAG_BID;
        tickMini.flag_ask = tickInfo.flags & TICK_FLAG_ASK;
        tickMini.flag_last = tickInfo.flags & TICK_FLAG_LAST;
        tickMini.flag_volume = tickInfo.flags & TICK_FLAG_VOLUME;
        tickMini.flag_buy = tickInfo.flags & TICK_FLAG_BUY;
        tickMini.flag_sell = tickInfo.flags & TICK_FLAG_SELL;
        
        tickData[tickCont++] = tickMini;
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
    Print("lastTickTime : ",SystemTimeToString(lastTickTime));
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

        //Print("BOOK DATA:  TIME  PRICE/VOLUME ...");
        //for (int i = 0; i < bookCont; i++) {
        //    SBookMini book = bookData[i];
        //    string lineAsk = "ASK: ", lineBid = "BID: ";
        //    for (int j = 0; j <= 15; j++) {
        //        lineAsk += IntegerToString(book.asks[j].price) + "[" + IntegerToString(book.asks[j].volume) + "]  ";
        //        lineBid += IntegerToString(book.bids[j].price) + "[" + IntegerToString(book.bids[j].volume) + "]  ";
        //    }
        //    Print(book.time," : ", lineAsk);
        //    Print("              : ", lineBid);
        //}
        //Print("----------------------------------------------------------------------");

        //---
        bookCont = 0;
    } else {
        Print("BOOKs Obtidos = 0");
        Print("----------------------------------------------------------------------");
    }

    //+------------------------------------------------------------------+

    //---
    if (tickCont > 0) {
        int tickDiffs[DIFF_SIZE];

        double media = DiffMedia(tickCont, tickTimes, tickDiffs);
        //for (int i = 0; i < DIFF_SIZE; i++) {
        //    if (tickDiffs[i] > 0)
        //        Print("TICK Diff[",i,"] = ", tickDiffs[i]);
        //}
        
        Print("TICKs Obtidos = ", tickCont, " / Media de Tempo = ", DoubleToString(media, 4), " milissegundos");
        Print("----------------------------------------------------------------------");

        //Print("TICK DATA:  TIME   BID   ASK   LAST   VOLUME   FLAGS: BID ASK LAST VOLUME BUY SELL");
        //for (int i = 0; i < tickCont; i++) {
        //    STickMini tick = tickData[i];
        //    Print(tick.time,", ",tick.bid,", ",tick.ask,", ",tick.last,", ",tick.volume,", ",tick.flag_bid,", ",tick.flag_ask,", ",tick.flag_last,", ",tick.flag_volume,", ",tick.flag_buy,", ",tick.flag_sell);
        //}
        //Print("----------------------------------------------------------------------");

        //---
        tickCont = 0;
    } else {
        Print("TICKs Obtidos = 0");
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
string GetBookType(ENUM_BOOK_TYPE type) {
    switch(type) {
        case BOOK_TYPE_SELL : return EnumToString(BOOK_TYPE_SELL);
        case BOOK_TYPE_BUY : return EnumToString(BOOK_TYPE_BUY);
        case BOOK_TYPE_SELL_MARKET : return EnumToString(BOOK_TYPE_SELL_MARKET);
        case BOOK_TYPE_BUY_MARKET : return EnumToString(BOOK_TYPE_BUY_MARKET);
        default: return "None";
    }
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
