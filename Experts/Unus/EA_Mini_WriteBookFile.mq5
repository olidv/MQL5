//+------------------------------------------------------------------+
//|                                         EA_WIN_WriteBookFile.mq5 |
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
static const string FILE_SUFFIX_BOOK = "_Book.csv";
static int          csvHandleBook;

//---
static int          bookCont = 0;
static SBookDOM     bookData[DATA_SIZE];
static SBookDOM     copyBookData[DATA_SIZE];  // buffer temporario

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    Print("EA [",_Symbol,"] :  WRITE-BOOK-FILE  com  TIMER = ",EA_TIMER," seg");
    Print("----------------------------------------------------------------------");

    //--- inicializa o arquivo CSV:
    string fileName = TimeToString(TimeLocal(), TIME_DATE) + "_" + _Symbol + FILE_SUFFIX_BOOK;
    bool fileExist = FileIsExist(fileName);
    
    ResetLastError();
    csvHandleBook = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                              : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI); 
    if (csvHandleBook == INVALID_HANDLE) {
        Print("EA [",_Symbol,"] :  Operação 'FileOpen(",fileName,")' falhou! Erro = ", GetLastError()); 
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
    MqlBookInfo bookInfo[];
    if (MarketBookGet(_Symbol, bookInfo)) {
        bookData[bookCont].time = GetMillisecondsTime();
        ArrayCopy(bookData[bookCont++].info, bookInfo, 0, 0, BOOK_SIZE);
    }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {
    static int totalBookCont = 0, copyBookCont = 0;

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
        ArrayCopy(copyBookData, bookData, 0, 0, bookCont);
        totalBookCont += bookCont;

        //--- zera valores atuais
        bookCont = 0;
        ZeroMemory(bookData);
        
        //--- gravar dados no arquivo
        for (int i = 0; i < copyBookCont; i++) {
           SBookDOM book = copyBookData[i];
           
           string bookInfo = "";
           for (int j = 0; j < BOOK_SIZE; j++)
               bookInfo += StringFormat("%s\t%s\t", DoubleToString(book.info[j].price,SIMBOLO_DIGITOS), DoubleToString(book.info[j].volume,0));
           // elimina o ultimo tab
           bookInfo = StringSubstr(bookInfo, 0, StringLen(bookInfo) - 1);
           
           //--- chamar função de escrever 
           FileWrite(csvHandleBook, book.time, bookInfo);
        }
    
        //--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
        FileFlush(csvHandleBook);
    }

    //Print("EA [",_Symbol,"] :  BOOKs Gravados = ", IntegerToString(copyCont,5));
    //Print("----------------------------------------------------------------------");
    
    //---
    if (endPregao) {
        //--- fechar o arquivo 
        FileClose(csvHandleBook);
        csvHandleBook = INVALID_HANDLE;  // invalida handle

        Print("----------------------------------------------------------------------");
        Print("EA [",_Symbol,"] :  Pregão Encerrado! Total de BOOKs Obtidos = ", totalBookCont);
    }    
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- destroy timer
    EventKillTimer();
    MarketBookRelease(_Symbol);
    
    //--- fechar o arquivo, se ja nao foi fechado
    if (csvHandleBook != INVALID_HANDLE) {
        FileFlush(csvHandleBook);
        FileClose(csvHandleBook); 
        csvHandleBook = INVALID_HANDLE;  // invalida handle
    }
}

//+------------------------------------------------------------------+
