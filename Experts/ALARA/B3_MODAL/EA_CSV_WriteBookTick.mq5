/*
===============================================================================

 package: MQL5\Experts\_B3_MODAL

 module : EA_CSV_WriteBookTick.mq5
 
===============================================================================
*/
#property copyright   "Copyright 2021, ALARA Investimentos"
#property link        "http://www.alara.com.br"
#property version     "1.00"
#property description ""
#property description ""

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <ALARA\WinAPI_Time.mqh>

//--- Funcoes para processamento conforme a B3
#include <ALARA\B3\B3_Info.mqh>

//+------------------------------------------------------------------+

#define EA_TIMER    5     // timer em segundos

#define BOOK_SIZE   50    // limite de 50 posicoes obtidas do book no pregao
// Nao ira definir um tamanho padrao para o array,
// sera verificado ao extrair.

#define DATA_SIZE   5000  // limite de 1000 registros p/ segundo (1 evento a cada 1 milisegundo)

//+------------------------------------------------------------------+

struct SPriceTick
   {
    int              idTick;
    int              idLastBook;
    int              localTime;
    MqlTick          tickInfo;
   };

struct SOrderBook
   {
    int              idBook;
    int              idLastTick;
    int              localTime;
    MqlBookInfo      bookInfo[];  // Ofertas de venda e compra do book
   };

//+------------------------------------------------------------------+

const string FILE_SUFFIX_TICK = "_Tick.csv";
const string FILE_SUFFIX_BOOK = "_Book.csv";

int          hndCsvFileTick = INVALID_HANDLE,  // handle para arquivo CSV gerado.
             hndCsvFileBook = INVALID_HANDLE;  // handle para arquivo CSV gerado.

// Data (apenas dd/mm/yyyy) do arquivo CSV gerado - parte do nome do arquivo;
datetime     dtDiaColeta;

//+------------------------------------------------------------------+

//---
int          tickCont = 0,
             idLastTick = 0;  // corresponde ao total de registros de tick coletados
SPriceTick   tickData[DATA_SIZE];

//---
int          bookCont = 0,
             idLastBook = 0;  // corresponde ao total de registros de book coletados
SOrderBook   bookData[DATA_SIZE];

//+------------------------------------------------------------------+

// indica se o processamento foi finalizado pelo Timer:
bool         isTimerKilled = false;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
//--- inicializa as variaveis para coleta de dados e arquivo CSV:
    if(! BeginDataCollection(GetDate()))  // Obtem a data do dia da coleta - apenas dia/mes/ano, sem parte horas.
       {
        return(INIT_FAILED);
       }

// É preciso abrir o acesso aos dados do book
    if(! MarketBookAdd(_Symbol))   // Abertura da Profundidade de Mercado (DOM = Depth of Market)
        return(INIT_FAILED);

//--- Cria timer, para disparo a cada 5 segundos:
    if(! EventSetTimer(EA_TIMER))
        return(INIT_FAILED);

//--- Inicializacao do robo efetuada com sucesso.
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
void OnBookEvent(const string &symbol)
   {
//--- ignora outros símbolos.
    if(symbol != _Symbol)
        return;

//--- identifica o proximo registro do array de books
    ++bookCont;

// Ofertas de venda e compra do book
//    if (MarketBookGet(_Symbol, bookData[bookCont].bookInfo) && ArraySize(bookData[bookCont].bookInfo) == BOOK_SIZE) {
    if(MarketBookGet(_Symbol, bookData[bookCont].bookInfo))
       {
        // data-hora local no momento da obtencao do book
        bookData[bookCont].localTime = GetMillisecondsTime(); // soh a parte hora, em milissegundos

        // mais um regitro do livro de ofertas (order book):
        bookData[bookCont].idBook = ++idLastBook;
        //--- ja salva o ultimo registro do tick p/ referencia
        bookData[bookCont].idLastTick = idLastTick;
       }
    else
       {
        // se ocorrer algum problema, restaura o ultimo contador valido.
        --bookCont;
       }
   }


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//| Este evento/funcao gasta em torno de 10 a 20 microsegundos para  |
//| ser executado, sendo disparado a cada 10 a 20 milisegundos.      |
//+------------------------------------------------------------------+
void OnTick()
   {
//--- identifica o proximo registro do array de ticks
    ++tickCont;

// ultima mudanca no price tick
    if(SymbolInfoTick(_Symbol, tickData[tickCont].tickInfo))
       {
        // data-hora local no momento da obtencao do tick
        tickData[tickCont].localTime = GetMillisecondsTime(); // soh a parte hora, em milissegundos

        // mais um registro de alteracao de preco (tick)
        tickData[tickCont].idTick = ++idLastTick;
        //--- ja salva o ultimo registro do book p/ referencia
        tickData[tickCont].idLastBook = idLastBook;
       }
    else
       {
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
void OnTimer()
   {
//--- Salva os registros coletados do times and trades:
    if(tickCont > 0)
       {
        //--- gravar dados no arquivo
        SPriceTick tick;
        for(int i = 1; i <= tickCont; i++)
           {
            tick = tickData[i];

            //--- chamar função de escrever
            FileWrite(hndCsvFileTick, tick.idTick, tick.idLastBook, addTimeToHoje(tick.localTime), tick.tickInfo.time_msc,
                      PrecoInteiro(tick.tickInfo.bid), PrecoInteiro(tick.tickInfo.ask), PrecoInteiro(tick.tickInfo.last), tick.tickInfo.volume,
                      (bool)(tick.tickInfo.flags & TICK_FLAG_BID),
                      (bool)(tick.tickInfo.flags & TICK_FLAG_ASK),
                      (bool)(tick.tickInfo.flags & TICK_FLAG_LAST),
                      (bool)(tick.tickInfo.flags & TICK_FLAG_VOLUME),
                      (bool)(tick.tickInfo.flags & TICK_FLAG_BUY),
                      (bool)(tick.tickInfo.flags & TICK_FLAG_SELL));
           }

        //--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
        FileFlush(hndCsvFileTick);

        //--- zera o index da estrutura de dados para coleta:
        tickCont = 0;
       }

//--- Salva os registros coletados do livro de ofertas:
    if(bookCont > 0)
       {
        //--- gravar dados no arquivo
        SOrderBook book;
        string lineBook;
        for(int i = 1; i <= bookCont; i++)
           {
            book = bookData[i];

            //--- formata o book em uma unica linha tabulada para gravacao
            lineBook = "";
            int bookSize = ArraySize(book.bookInfo);
            for(int j = 0; j < bookSize; j++)
               {
                //--- formata os dados como inteiro para facilitar a analise:
                lineBook += StringFormat("%d\t%d\t", PrecoInteiro(book.bookInfo[j].price), book.bookInfo[j].volume);
               }
            // elimina o ultimo tab
            lineBook = StringSubstr(lineBook, 0, StringLen(lineBook) - 1);

            //--- chamar função de escrever
            FileWrite(hndCsvFileBook, book.idBook, book.idLastTick, addTimeToHoje(book.localTime), lineBook);
           }

        //--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
        FileFlush(hndCsvFileBook);

        //--- zera o index da estrutura de dados para coleta:
        bookCont = 0;
       }

//--- Verifica se o MT5 foi encerrado ou se o programa foi removido ou se passou do horario de fechamento da bolsa:
    if(_StopFlag || EncerrouNegociacaoB3())
       {
        // registra o final do processamento:
        isTimerKilled = true;

        // Imediatamente cancela timer e evento de book para nao serem mais disparados.
        EventKillTimer();  //--- destroy timer
        MarketBookRelease(_Symbol);

        // Fecha os arquivos CSV e encerra coleta do dia anterior:
        EndDataCollection(dtDiaColeta);

        // Nada mais a fazer aqui no OnTimer().
        return;
       }

//--- Verifica se passou para outro dia enquanto computador estava suspenso:
    datetime dtAgora = GetDate();
    if(dtDiaColeta < dtAgora)
       {
        //--- fecha os arquivos CSV e encerra coleta do dia anterior:
        EndDataCollection(dtDiaColeta);

        //--- inicia coleta do dia corrente e abre os novos arquivos CSV:
        if(! BeginDataCollection(dtAgora))
           {
            return;
           }
       }
   }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
//--- Imediatamente cancela timer para nao ser mais disparado.
    EventKillTimer();

//--- Verifica se os ultimos dados coletados ja foram salvos:
    if(! isTimerKilled)
       {
        //--- grava os ultimos registros e encerra o timer:
        OnTimer();  // aqui o valor de _StopFlag = true
       }
   }

//+-------------------------------------------------------------------------------+
//| Inicializa as variaveis e estruturas para coleta de dados e arquivo(s) CSV.   |
//+-------------------------------------------------------------------------------+
bool BeginDataCollection(datetime dtCsvFile)
   {
//--- Obtem a data do dia da coleta - apenas dia/mes/ano, sem parte horas.
    dtDiaColeta = dtCsvFile;

//--- Zera contadores de dados coletados e salvos em CSV.
    tickCont = 0;
    idLastTick = 0;

//---
    bookCont = 0;
    idLastBook = 0;

//--- Inicializa o arquivo CSV para TICKs:
    hndCsvFileTick = OpenCsvFileTicks(dtCsvFile);
    if(hndCsvFileTick == INVALID_HANDLE)
        return false;

//--- Inicializa o arquivo CSV para BOOKs:
    hndCsvFileBook = OpenCsvFileBooks(dtCsvFile);
    if(hndCsvFileBook == INVALID_HANDLE)
        return false;

    Print("INICIO [", _Symbol, "] EM ", TimeToString(dtCsvFile, TIME_DATE), " : WRITE BOOK & TICK CSV FILE  |  TIMER = ", EA_TIMER, " seg");
    Print("----------------------------------------------------------------------");

//-- procedimento de inicializacao realizado com sucesso:
    return true;
   }


//+-------------------------------------------------------------------------------+
//| Fecha os arquivos CSV e encerra coleta do dia anterior.                       |
//+-------------------------------------------------------------------------------+
bool EndDataCollection(datetime dtCsvFile)
   {
//--- fecha os arquivos CSV do dia anterior:
    CloseCsvFile(hndCsvFileTick);
    CloseCsvFile(hndCsvFileBook);

    Print("----------------------------------------------------------------------");
    Print("FIM [", _Symbol, "] EM ", TimeToString(dtCsvFile, TIME_DATE), " : Total de TICKs Obtidos no dia = ", IntegerToString(idLastTick,7), "  /  Total de BOOKs Obtidos no dia = ", IntegerToString(idLastBook,7));

//-- procedimento de finalizacao realizado com sucesso:
    return true;
   }


//+-------------------------------------------------------------------------------+
//| Inicializa o arquivo CSV para nova data e retorna o handle do arquivo criado. |
//+-------------------------------------------------------------------------------+
int OpenCsvFileTicks(datetime dtCsvFile)
   {
//--- inicializa o arquivo CSV para TICKs:
    string fileName = TimeToString(dtCsvFile, TIME_DATE) + "_" + _Symbol + FILE_SUFFIX_TICK;
    bool fileExist = FileIsExist(fileName);

    ResetLastError();
    int hndCsvFile = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                              : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI);
    if(hndCsvFile == INVALID_HANDLE)
       {
        Print("ERRO [", _Symbol, "] EM ", TimeToString(dtCsvFile, TIME_DATE), " : Operação 'FileOpen(", fileName, ")' falhou! Erro = ", GetLastError());
       }
    else
        if(fileExist)
           {
            FileSeek(hndCsvFile, 0, SEEK_END);
           }
        else
           {
            FileWrite(hndCsvFile, "ID_TICK", "LAST_BOOK", "LOCAL_TIME", "TIME", "BID", "ASK", "LAST", "VOLUME",
                                 "FLAG_BID", "FLAG_ASK", "FLAG_LAST", "FLAG_VOLUME", "FLAG_BUY", "FLAG_SELL");
           }

//--- retorna o handle do arquivo para gravacao dos registros.
    return (hndCsvFile);
   }


//+-------------------------------------------------------------------------------+
//| Inicializa o arquivo CSV para nova data e retorna o handle do arquivo criado. |
//+-------------------------------------------------------------------------------+
int OpenCsvFileBooks(datetime dtCsvFile)
   {
//--- inicializa o arquivo CSV para BOOKs:
    string fileName = TimeToString(dtCsvFile, TIME_DATE) + "_" + _Symbol + FILE_SUFFIX_BOOK;
    bool fileExist = FileIsExist(fileName);

    ResetLastError();
    int hndCsvFile = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                              : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI);
    if(hndCsvFile == INVALID_HANDLE)
       {
        Print("ERRO [", _Symbol, "] EM ", TimeToString(dtCsvFile, TIME_DATE), " : Operação 'FileOpen(", fileName, ")' falhou! Erro = ", GetLastError());
       }
    else
        if(fileExist)
           {
            FileSeek(hndCsvFile, 0, SEEK_END);
           }
        else
           {
            string bookHead = "";
            for(int i = 1; i <= BOOK_SIZE; i++)
                bookHead += StringFormat("PRICE_%d\tVOLUME_%d\t", i, i);
            // elimina o ultimo tab
            bookHead = StringSubstr(bookHead, 0, StringLen(bookHead) - 1);

            FileWrite(hndCsvFile, "ID_BOOK", "LAST_TICK", "LOCAL_TIME", bookHead);
           }

//--- retorna o handle do arquivo para gravacao dos registros.
    return (hndCsvFile);
   }

//+-------------------------------------------------------------------------------+
//| Fecha o arquivo CSV e encerra o handle do arquivo criado.                     |
//+-------------------------------------------------------------------------------+
void CloseCsvFile(int &hndCsvFile)
   {
//--- Se nem criou arquivo CSV ainda, nada a fazer aqui...
    if(hndCsvFile == INVALID_HANDLE)
        return;

//--- grava os dados restantes do arquivo.
    FileFlush(hndCsvFile);

//--- fecha o arquivo e inutiliza handle:
    FileClose(hndCsvFile);

    hndCsvFile = INVALID_HANDLE;  // invalida o handle do arquivo;
   }

//+------------------------------------------------------------------+
