//+------------------------------------------------------------------+
//|                                    EA_Mini_WriteBookTickFile.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <Unus\wintime.mqh>

//--- Funcoes para processamento conforme a B3
#include <Unus\B3_Info.mqh>

//+------------------------------------------------------------------+

#define EA_TIMER    60    // timer em segundos = 1 minuto

#define DATA_SIZE   6000  // limite de 100 por segundo (minimo a cada 10 milisegundos)

//+------------------------------------------------------------------+

//---
static const string FILE_SUFFIX_BOOK = "_Book_2.csv";
static const string FILE_SUFFIX_TICK = "_Tick_2.csv";
static int          csvHandleBook, csvHandleTick;

//---
static int totalBookCont = 0, 
           totalTickCont = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    Print("EA [",_Symbol,"] :  WRITE-BOOK-TICK-FILES (2)  com  TIMER = ",EA_TIMER," seg");
    Print("----------------------------------------------------------------------");

    //--- inicializa o arquivo CSV para BOOKs:
    string fileName = TimeToString(TimeLocal(), TIME_DATE) + "_" + _Symbol + FILE_SUFFIX_BOOK;
    bool fileExist = FileIsExist(fileName);
    
    ResetLastError();
    csvHandleBook = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                              : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI); 
    if (csvHandleBook == INVALID_HANDLE) {
        Print("EA [",_Symbol,"]  :  Operação 'FileOpen(",fileName,")' falhou! Erro = ", GetLastError()); 
        return (INIT_FAILED);

    } else if (fileExist) {
       FileSeek(csvHandleBook, 0, SEEK_END);

    } else {
        string bookHead = "";
        for (int i = 0; i < BOOK_SIZE; i++)
            bookHead += StringFormat("PRICE_%d\tVOLUME_%d\t", i, i);
        // elimina o ultimo tab
        bookHead = StringSubstr(bookHead, 0, StringLen(bookHead) - 1);

        FileWrite(csvHandleBook, "LOCAL_TIME", bookHead);
    }

    //--- inicializa o arquivo CSV para TICKs:
    fileName = TimeToString(TimeLocal(), TIME_DATE) + "_" + _Symbol + FILE_SUFFIX_TICK;
    fileExist = FileIsExist(fileName);
    
    ResetLastError();
    csvHandleTick = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                              : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI); 
    if (csvHandleTick == INVALID_HANDLE) {
        Print("EA [",_Symbol,"] :  Operação 'FileOpen(",fileName,")' falhou! Erro = ", GetLastError()); 
        return (INIT_FAILED);

    } else if (fileExist) {
       FileSeek(csvHandleTick, 0, SEEK_END);

    } else {
        FileWrite(csvHandleTick, "TIME","LOCAL_TIME","BID","ASK","LAST","VOLUME","FLAG_BID","FLAG_ASK","FLAG_LAST","FLAG_VOLUME","FLAG_BUY","FLAG_SELL");
    }

    //--- create timer
    EventSetTimer(EA_TIMER);
    
    // É preciso abrir o acesso aos dados do book
    MarketBookAdd(_Symbol); // Abertura da Profundidade de Mercado (DOM = Depth of Market)
    
    //---
    return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert book function                                             |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol) {
    //--- ignora outros símbolos.
    if (symbol != _Symbol) return;

    //---
    MqlBookInfo bookInfo[];    // Ofertas de venda e compra do book
    if (MarketBookGet(_Symbol, bookInfo)) {
        //---
        if (ArraySize(bookInfo) < BOOK_SIZE) return;
        
        long localTime = GetMillisecondsTime();  // data-hora local no momento da obtencao do book
        totalBookCont++;  // mais um regitro do livro de ofertas (order book)
    
        //--- formata o book em uma unica linha tabulada para gravacao
        string lineBook = "";
        for (int i = 0; i < BOOK_SIZE; i++) {
           lineBook += StringFormat("%s\t%s\t", DoubleToString(bookInfo[i].price,SIMBOLO_DIGITOS), DoubleToString(bookInfo[i].volume,0));
        }
        // elimina o ultimo tab
        lineBook = StringSubstr(lineBook, 0, StringLen(lineBook) - 1);
           
        //--- gravar dados no arquivo
        FileWrite(csvHandleBook, localTime, lineBook);
    }
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
    //---
    MqlTick tick;
    if (SymbolInfoTick(_Symbol, tick)) {
        double localTime = (double) GetMillisecondsTime();  // data-hora local no momento da obtencao do tick
        totalTickCont++;  // mais um registro de alteracao de preco (tick)

        //--- gravar dados no arquivo
        bool flag_bid = tick.flags & TICK_FLAG_BID;
        bool flag_ask = tick.flags & TICK_FLAG_ASK;
        bool flag_last = tick.flags & TICK_FLAG_LAST;
        bool flag_volume = tick.flags & TICK_FLAG_VOLUME;
        bool flag_buy = tick.flags & TICK_FLAG_BUY;
        bool flag_sell = tick.flags & TICK_FLAG_SELL;

        //--- chamar função de escrever 
        FileWrite(csvHandleTick, tick.time_msc, DoubleToString(localTime,0), DoubleToString(tick.bid,SIMBOLO_DIGITOS), DoubleToString(tick.ask,SIMBOLO_DIGITOS), DoubleToString(tick.last,SIMBOLO_DIGITOS), DoubleToString(tick.volume,0), 
                                 flag_bid, flag_ask, flag_last, flag_volume, flag_buy, flag_sell);
    }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {
    //--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
    FileFlush(csvHandleBook);
    FileFlush(csvHandleTick);

    if (EncerrouPregaoB3() || _StopFlag) {
        //--- destroy timer
        EventKillTimer();
        MarketBookRelease(_Symbol);
        
        //--- fecha os arquivos, se ja nao foram fechados
        if (csvHandleBook != INVALID_HANDLE) {
            FileFlush(csvHandleBook);
            FileClose(csvHandleBook); 
            csvHandleBook = INVALID_HANDLE;  // invalida handle
        }
        
        if (csvHandleTick != INVALID_HANDLE) {
            FileFlush(csvHandleTick);
            FileClose(csvHandleTick); 
            csvHandleTick = INVALID_HANDLE;  // invalida handle
        }
    
        Print("----------------------------------------------------------------------");
        Print("EA [",_Symbol,"]  :  Pregão Encerrado! Total de BOOKs Obtidos = ", totalBookCont, "  /  Total de TICKs Obtidos = ", totalTickCont);
    }
}
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- destroy timer
    EventKillTimer();
    MarketBookRelease(_Symbol);
    
    //--- fecha os arquivos, se ja nao foram fechados
    if (csvHandleBook != INVALID_HANDLE) {
        FileFlush(csvHandleBook);
        FileClose(csvHandleBook); 
        csvHandleBook = INVALID_HANDLE;  // invalida handle
    }
    
    if (csvHandleTick != INVALID_HANDLE) {
        FileFlush(csvHandleTick);
        FileClose(csvHandleTick); 
        csvHandleTick = INVALID_HANDLE;  // invalida handle
    }
}

//+------------------------------------------------------------------+
