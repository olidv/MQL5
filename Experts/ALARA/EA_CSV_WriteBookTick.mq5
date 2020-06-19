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

#define EA_TIMER    5     // timer em segundos

#define DATA_SIZE   5000  // limite de 1000 registros p/ segundo (1 evento a cada 1 milisegundo)

//+------------------------------------------------------------------+

//---
struct SOrderBook {
    int          idBook;
    int          idLastTick;
    int          localTime;
    MqlBookInfo  bookInfo[];  // Ofertas de venda e compra do book
};

struct SPriceTick {
    int          idTick;
    int          idLastBook;
    int          localTime;
    MqlTick      tickInfo;
};

//+------------------------------------------------------------------+

//---
const string FILE_SUFFIX_BOOK = "_Book.csv";
const string FILE_SUFFIX_TICK = "_Tick.csv";
int          csvHandleBook    = INVALID_HANDLE,
             csvHandleTick    = INVALID_HANDLE;

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

    //--- identifica o proximo registro do array de books
    ++bookCont;
    
    // Ofertas de venda e compra do book
    if (MarketBookGet(_Symbol, bookData[bookCont].bookInfo) && ArraySize(bookData[bookCont].bookInfo) == BOOK_SIZE) {
        // data-hora local no momento da obtencao do book
        bookData[bookCont].localTime = GetMillisecondsTime(); // soh a parte hora, em milissegundos
        
        // mais um regitro do livro de ofertas (order book):
        bookData[bookCont].idBook = ++idLastBook;
        //--- ja salva o ultimo registro do tick p/ referencia
        bookData[bookCont].idLastTick = idLastTick;

    } else {
        // se ocorrer algum problema, restaura o ultimo contador valido.
        --bookCont;
    }
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//| Este evento/funcao gasta em torno de 10 a 20 microsegundos para  |
//| ser executado, sendo disparado a cada 10 a 20 milisegundos.      |
//+------------------------------------------------------------------+
void OnTick() {
    //--- identifica o proximo registro do array de ticks
    ++tickCont;

    // ultima mudanca no price tick
    if (SymbolInfoTick(_Symbol, tickData[tickCont].tickInfo)) {
        // data-hora local no momento da obtencao do tick
        tickData[tickCont].localTime = GetMillisecondsTime(); // soh a parte hora, em milissegundos

        // mais um registro de alteracao de preco (tick)
        tickData[tickCont].idTick = ++idLastTick;
        //--- ja salva o ultimo registro do book p/ referencia
        tickData[tickCont].idLastBook = idLastBook;

    } else {
        // se ocorrer algum problema, restaura o ultimo contador valido.
        --tickCont;
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
    //---
    if (bookCont > 0) {
        //--- gravar dados no arquivo
        SOrderBook book;
        string lineBook;
        for (int i = 1; i <= bookCont; i++) {
            book = bookData[i];

            //--- formata o book em uma unica linha tabulada para gravacao
            lineBook = "";
            for (int j = 0; j < BOOK_SIZE; j++) {
                //--- formata os dados como inteiro para facilitar a analise:
               lineBook += StringFormat("%d\t%d\t", PrecoInteiro(book.bookInfo[j].price), book.bookInfo[j].volume);
            }
            // elimina o ultimo tab
            lineBook = StringSubstr(lineBook, 0, StringLen(lineBook) - 1);
           
            //--- chamar função de escrever 
            FileWrite(csvHandleBook, book.idBook, book.idLastTick, (HOJE_MILISSEGUNDOS + book.localTime), lineBook);
        }
    
        //--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
        FileFlush(csvHandleBook);

        //--- zera o index da estrutura de dados para coleta:
        bookCont = 0;
    }

    //---
    if (tickCont > 0) {
        //--- gravar dados no arquivo
        SPriceTick tick;
        for (int i = 1; i <= tickCont; i++) {
            tick = tickData[i];

            //--- chamar função de escrever 
            FileWrite(csvHandleTick, tick.idTick, tick.idLastBook, (HOJE_MILISSEGUNDOS + tick.localTime), tick.tickInfo.time_msc, 
                                     PrecoInteiro(tick.tickInfo.bid), PrecoInteiro(tick.tickInfo.ask), PrecoInteiro(tick.tickInfo.last), tick.tickInfo.volume,
                                     (bool) (tick.tickInfo.flags & TICK_FLAG_BID), 
                                     (bool) (tick.tickInfo.flags & TICK_FLAG_ASK), 
                                     (bool) (tick.tickInfo.flags & TICK_FLAG_LAST), 
                                     (bool) (tick.tickInfo.flags & TICK_FLAG_VOLUME), 
                                     (bool) (tick.tickInfo.flags & TICK_FLAG_BUY), 
                                     (bool) (tick.tickInfo.flags & TICK_FLAG_SELL));
        }
   
        //--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
        FileFlush(csvHandleTick);

        //--- zera o index da estrutura de dados para coleta:
        tickCont = 0;
    }

    //---
    if (EncerrouPregaoB3() || _StopFlag) {
        //---
        EventKillTimer();  //--- destroy timer
        MarketBookRelease(_Symbol);

        //--- fechar o arquivo 
        FileClose(csvHandleBook);
        csvHandleBook = INVALID_HANDLE;  // invalida handle

        FileClose(csvHandleTick); 
        csvHandleTick = INVALID_HANDLE;  // invalida handle

        Print("----------------------------------------------------------------------");
        Print("EA [", _Symbol, "] :  Programa Encerrado! Total de BOOKs Obtidos = ", IntegerToString(idLastBook,7), "  /  Total de TICKs Obtidos = ", IntegerToString(idLastTick,7));
        
        //--- Interrompe o Expert Advisor e o descarrega do gráfico
        ExpertRemove();

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
    OnTimer();  // aqui o valor de _StopFlag = true
}

//+------------------------------------------------------------------+
