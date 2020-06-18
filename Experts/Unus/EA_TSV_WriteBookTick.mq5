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

#define EA_TIMER    5    // timer em segundos

#define DATA_SIZE   500  // limite de 100 por segundo (minimo a cada 10 milisegundos)

//+------------------------------------------------------------------+

//---
const string FILE_SUFFIX_BOOK = "_Book.csv";
const string FILE_SUFFIX_TICK = "_Tick.csv";
int          csvHandleBook, csvHandleTick;

//---
int          bookCont = 0,
             idLastBook = 0;  // corresponde ao total de registros de book coletados
SOrderBook   bookData[DATA_SIZE];

//---
int          tickCont = 0,
             idLastTick = 0;  // corresponde ao total de registros de tick coletados
SPriceTick   tickData[DATA_SIZE];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    Print("EA [", _Symbol, "] :  WRITE BOOK & TICK CSV FILE  |  TIMER = ", EA_TIMER, " seg");
    Print("----------------------------------------------------------------------");

    //--- inicializa o arquivo CSV para BOOKs:
    string fileName = TimeToString(TimeLocal(), TIME_DATE) + "_" + _Symbol + FILE_SUFFIX_BOOK;
    bool fileExist = FileIsExist(fileName);
    
    ResetLastError();
    csvHandleBook = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                              : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI); 
    if (csvHandleBook == INVALID_HANDLE) {
        Print("EA [", _Symbol, "] :  Operação 'FileOpen(", fileName, ")' falhou! Erro = ", GetLastError()); 
        return (INIT_FAILED);

    } else if (fileExist) {
       FileSeek(csvHandleBook, 0, SEEK_END);

    } else {
        string bookHead = "";
        for (int i = 0; i < BOOK_SIZE; i++)
            bookHead += StringFormat("PRICE_%d\tVOLUME_%d\t", i, i);
        // elimina o ultimo tab
        bookHead = StringSubstr(bookHead, 0, StringLen(bookHead) - 1);

        FileWrite(csvHandleBook, "ID_BOOK", "LAST_TICK", "LOCAL_TIME", bookHead);
    }

    //--- inicializa o arquivo CSV para TICKs:
    fileName = TimeToString(TimeLocal(), TIME_DATE) + "_" + _Symbol + FILE_SUFFIX_TICK;
    fileExist = FileIsExist(fileName);
    
    ResetLastError();
    csvHandleTick = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                              : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI); 
    if (csvHandleTick == INVALID_HANDLE) {
        Print("EA [", _Symbol, "] :  Operação 'FileOpen(", fileName, ")' falhou! Erro = ", GetLastError()); 
        return (INIT_FAILED);

    } else if (fileExist) {
       FileSeek(csvHandleTick, 0, SEEK_END);

    } else {
        FileWrite(csvHandleTick, "ID_TICK", "LAST_BOOK", "LOCAL_TIME", "TIME", "BID", "ASK", "LAST", "VOLUME",
                                 "FLAG_BID", "FLAG_ASK", "FLAG_LAST", "FLAG_VOLUME", "FLAG_BUY", "FLAG_SELL");
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
//| Este evento/funcao gasta em torno de 10 a 20 microsegundos para  |
//| ser executado, sendo disparado a cada 10 a 20 milisegundos.      |
//| A orientacao eh que este evento seja o mais breve, para nao      |
//| prejudicar os outros EA, pois como eh disparado via brodcasting, |
//| o dispara ocorre em todos os EA simultaneamente.                 |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol) {
    //--- ignora outros símbolos.
    if (symbol != _Symbol) return;

    //--- ja salva o ultimo registro do tick p/ referencia
    int lastTick = idLastTick;
    //--- identifica o proximo registro do array de books
    int nextBook = bookCont + 1;
    
    // Ofertas de venda e compra do book
    if (MarketBookGet(_Symbol, bookData[nextBook].bookInfo)) {
        //---
        if (ArraySize(bookData[nextBook].bookInfo) < BOOK_SIZE) return;

        // data-hora local no momento da obtencao do book
        bookData[nextBook].localTime = GetMillisecondsTime();
        
        // mais um regitro do livro de ofertas (order book):
        bookData[nextBook].idBook = ++idLastBook;
        bookData[nextBook].idLastTick = lastTick;

        // atualiza ao final para nao conflitar com a gravacao (OnTimer):
        ++bookCont;
    }
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//| Este evento/funcao gasta em torno de 10 a 20 microsegundos para  |
//| ser executado, sendo disparado a cada 10 a 20 milisegundos.      |
//+------------------------------------------------------------------+
void OnTick() {
    //--- ja salva o ultimo registro do book p/ referencia
    int lastBook = idLastBook;
    //--- identifica o proximo registro do array de ticks
    int nextTick = tickCont + 1;

    // ultima mudanca no price tick
    if (SymbolInfoTick(_Symbol, tickData[nextTick].tickInfo)) {
        // data-hora local no momento da obtencao do tick
        tickData[nextTick].localTime = GetMillisecondsTime();

        // mais um registro de alteracao de preco (tick)
        tickData[nextTick].idTick = ++idLastTick;
        tickData[nextTick].idLastBook = lastBook;

        // atualiza ao final para nao conflitar com a gravacao (OnTimer):
        ++tickCont;
    }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//| Foi definido um timer de 5 segundos, pois este evento/funcao     |
//| esta gastando entre 4 a 8 milisegundos para executar. Se o timer |
//| for definido em intervalo de tempo maior que 5 segundos, este    |
//| evento pode gastar mais que 10 milisegundos para executar, o que |
//| pode prejudicar / atrasar o disparo de OnBookEvent() e OnTick(). |
//+------------------------------------------------------------------+
void OnTimer() {
    int copyBookCont = 0, copyTickCont = 0;
    
    //---
    bool endPregao = EncerrouPregaoB3() || _StopFlag;
    if (endPregao) {
        EventKillTimer();  //--- destroy timer
        MarketBookRelease(_Symbol);
    }

    //---
    if (bookCont > 0) {
        //---
        copyBookCont = bookCont;
        //ArrayCopy(copyBookData, bookData, 0, 0, bookCont);

        //--- zera o index da estrutura de dados para coleta:
        bookCont = 0;

        //--- gravar dados no arquivo
        for (int i = 1; i <= copyBookCont; i++) {
            SOrderBook book = bookData[i];

            //--- formata o book em uma unica linha tabulada para gravacao
            string lineBook = "";
            for (int j = 0; j < BOOK_SIZE; j++) {
                //--- formata os dados como inteiro para facilitar a analise:
               lineBook += StringFormat("%d\t%d\t", PrecoInteiro(book.bookInfo[j].price), book.bookInfo[j].volume);
            }
            // elimina o ultimo tab
            lineBook = StringSubstr(lineBook, 0, StringLen(lineBook) - 1);
           
            //--- chamar função de escrever 
            FileWrite(csvHandleBook, book.idBook, book.idLastTick, book.localTime, lineBook);
        }
    
        //--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
        FileFlush(csvHandleBook);
    }

    //---
    if (tickCont > 0) {
        //---
        copyTickCont = tickCont;

        //--- zera o index da estrutura de dados para coleta:
        tickCont = 0;

        //--- gravar dados no arquivo
        for (int i = 1; i <= copyTickCont; i++) {
            SPriceTick tick = tickData[i];

            bool flag_bid = tick.tickInfo.flags & TICK_FLAG_BID;
            bool flag_ask = tick.tickInfo.flags & TICK_FLAG_ASK;
            bool flag_last = tick.tickInfo.flags & TICK_FLAG_LAST;
            bool flag_volume = tick.tickInfo.flags & TICK_FLAG_VOLUME;
            bool flag_buy = tick.tickInfo.flags & TICK_FLAG_BUY;
            bool flag_sell = tick.tickInfo.flags & TICK_FLAG_SELL;

            //--- chamar função de escrever 
            FileWrite(csvHandleTick, tick.idTick, tick.idLastBook, tick.localTime, tick.tickInfo.time_msc, 
                                     PrecoInteiro(tick.tickInfo.bid), PrecoInteiro(tick.tickInfo.ask), PrecoInteiro(tick.tickInfo.last), tick.tickInfo.volume,
                                     flag_bid, flag_ask, flag_last, flag_volume, flag_buy, flag_sell);
        }
   
        //--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
        FileFlush(csvHandleTick);
    }

    //---
    if (endPregao) {
        //--- fechar o arquivo 
        FileClose(csvHandleBook);
        csvHandleBook = INVALID_HANDLE;  // invalida handle

        FileClose(csvHandleTick); 
        csvHandleTick = INVALID_HANDLE;  // invalida handle

        Print("----------------------------------------------------------------------");
        Print("EA [", _Symbol, "] :  Programa Encerrado! Total de BOOKs Obtidos = ", IntegerToString(idLastBook,7), "  /  Total de TICKs Obtidos = ", IntegerToString(idLastTick,7));

    //} else {
    //    Print("EA [", _Symbol, "] :  BOOKs Gravados = ", IntegerToString(copyBookCont,7), "  /  TICKs Gravados = ", IntegerToString(copyTickCont,7));
    //    Print("----------------------------------------------------------------------");
    }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- grava os ultimos registros:
    OnTimer();  // aqui o valor de _StopFlag = false
}

//+------------------------------------------------------------------+
