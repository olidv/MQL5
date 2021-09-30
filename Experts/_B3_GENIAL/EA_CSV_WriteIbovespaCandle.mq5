//+------------------------------------------------------------------+
//|                                                      candles.mq5 |
//|                              Copyright 2021, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

//--- Funcoes para processamento conforme a B3
#include <_B3\B3_Info.mqh>

//+------------------------------------------------------------------+
const int    EA_START = 10;     // timer em segundos
const int    EA_TIMER = 60;     // timer em segundos

const string FILE_SUFFIX_RATE = "_IBOV_Rate.csv";

//+------------------------------------------------------------------+
int      qtdAtivos;     // Quantidade de ativos na Observação de Mercado
string   obsAtivos[];   // Armazena a relacao de ativos do observador


//+------------------------------------------------------------------+
int      hndCsvFile = INVALID_HANDLE;  // handle para arquivo CSV gerado.

bool     isTimerKilled = false;  // indica se o processamento foi finalizado pelo Timer:


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
MqlDateTime dtCorrente;
datetime    dtCsvFile;  // Data-hora do arquivo CSV gerado (parte do nome);

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
   {
//--- Obtem a relacao de ativos no observador -> Carteira IBOV:
    qtdAtivos = SymbolsTotal(true); // quantidade de ativos na Observação de Mercado

    Print("EA [IBOV] :  WRITE RATE CSV FILE  |  ATIVOS DA CARTEIRA IBOV = ", qtdAtivos, "  |  TIMER = ", EA_TIMER, " seg");
    Print("------------------------------------------------------------------------------------");

//--- Total de ativos inferior a 10 significa que o observador nao esta carregado com carteira IBOV:
    if(qtdAtivos < 10)
       {
        Print("ERRO: 'Observação do Mercado' NÃO está carregada com Carteira IBOV...");
        return(INIT_FAILED);
       }

//--- Atrasa alguns segundos, para pegar a transição de minutos:
    do
       {
        Sleep(1000); // aguarda 1 segundo
        TimeCurrent(dtCorrente);
       }
    while(dtCorrente.sec != EA_START);     // espera chegar no segundo 05 da hora corrente.

//--- Cria timer, para disparo a cada minuto:  HH:MM:05
    if(! EventSetTimer(EA_TIMER))
       {
        return(INIT_FAILED);
       }

//--- Inicializa as variaveis e estruturas para coleta de dados.
    InitDataCollection();

//--- Inicializa o arquivo CSV para RATEs dos ativos:
    hndCsvFile = OpenCsvFile();
    if(hndCsvFile == INVALID_HANDLE)
        return (INIT_FAILED);

//---
    return (INIT_SUCCEEDED);
   }


//+------------------------------------------------------------------+
//| Timer function                                                   |
//| Foi definido um timer de 5 segundos, pois este evento/funcao     |
//| esta gastando entre 4 a 8 milisegundos para executar. Se o timer |
//| for definido em intervalo de tempo maior que 5 segundos, este    |
//| evento pode gastar mais que 10 milisegundos para executar, o que |
//| pode prejudicar / atrasar o disparo de OnBookEvent() e OnTick(). |
//+------------------------------------------------------------------+
string       nomAtivo;
MqlRates     rates[];
long         timeCandle;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
   {
    ulong start = GetMicrosecondCount();

//--- Obtem os 2 ultimos candles para cada ativo:
    for(int i=0; i < qtdAtivos; i++)
       {
        nomAtivo = obsAtivos[i];
        // Obtem os 2 ultimos para ler o penultimo, pois o mais recente esta em andamento.
        if(CopyRates(nomAtivo,PERIOD_M1,0,2,rates) < 2)
           {
            Print("ERRO: NÃO foi possivel obter rates do ativo '", nomAtivo, "'.");
            continue;
           }

        // identifica o time (unix-format) do penultimo candle ja formado:
        timeCandle = ((long) rates[1].time) * 1000;

        //--- chamar função para escrever no arquivo.
        FileWrite(hndCsvFile, nomAtivo, timeCandle, PrecoInteiro(nomAtivo, rates[1].open), PrecoInteiro(nomAtivo, rates[1].high),
                                                    PrecoInteiro(nomAtivo, rates[1].low), PrecoInteiro(nomAtivo, rates[1].close),
                                                    PrecoInteiro(nomAtivo, rates[1].spread), rates[1].tick_volume, rates[1].real_volume);
       }

//--- Os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
    FileFlush(hndCsvFile);

    ulong stop = GetMicrosecondCount() - start;
    Print("Tempo Total de Processamento: ", stop);

//--- Verifica se o programa foi removido, se o MT5 foi encerrado
//--- ou se passou do horario de fechamento da bolsa.
    if(_StopFlag || EncerrouNegociacaoB3())
       {
        // registra o final do processamento:
        isTimerKilled = true;

        //---
        EventKillTimer();  //--- destroy timer

        //--- fecha o arquivo CSV
        CloseCsvFile(hndCsvFile);
       }
   }


//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
//--- Verifica se o timer ja foi finalizado:
    if(! isTimerKilled)
       {
        //--- grava os ultimos registros e encerra o timer:
        OnTimer();  // aqui o valor de _StopFlag = true
       }

    Print("----------------------------------------------------------------------");
    Print("EA [IBOV] :  Programa Encerrado! Total de Ativos na carteira = ", qtdAtivos, "  /  Total de RATEs Obtidos = ", IntegerToString(0,7));
   }


//+-------------------------------------------------------------------------------+
//| Inicializa as variaveis e estruturas para coleta de dados.                    |
//+-------------------------------------------------------------------------------+
void InitDataCollection()
   {
//--- Ja redimensiona o array de ativos da carteira:
    ArrayResize(obsAtivos, qtdAtivos);

//--- Relaciona os ativos da carteira IBOV (observacao do mercado):
    for(int i=0; i < qtdAtivos; i++)
       {
        obsAtivos[i] = SymbolName(i, true);
       }
   }


//+-------------------------------------------------------------------------------+
//| Inicializa o arquivo CSV para nova data e retorna o handle do arquivo criado. |
//+-------------------------------------------------------------------------------+
int OpenCsvFile()
   {
//--- inicializa o arquivo CSV para RATEs:
    datetime dtDiaArquivo = TimeCurrent();
    string fileName = TimeToString(dtDiaArquivo, TIME_DATE) + FILE_SUFFIX_RATE;
    bool fileExist = FileIsExist(fileName);

    ResetLastError();
    int csvHandle = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                    : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI);
    if(csvHandle == INVALID_HANDLE)
       {
        Print("EA [IBOV] :  Operação 'FileOpen(", fileName, ")' falhou! Erro = ", GetLastError());

       }
    else
        if(fileExist)
           {
            FileSeek(csvHandle, 0, SEEK_END);
           }
        else
           {
            FileWrite(csvHandle, "SYMBOL", "TIME", "OPEN", "HIGH", "LOW", "CLOSE", "SPREAD", "TICK_VOLUME", "REAL_VOLUME");
           }

//--- retorna o handle do arquivo para gravacao dos registros.
    return (csvHandle);
   }


//+-------------------------------------------------------------------------------+
//| Fecha o arquivo CSV e encerra o handle do arquivo criado.                     |
//+-------------------------------------------------------------------------------+
void CloseCsvFile(int &csvHandle)
   {
//--- grava os dados restantes do arquivo.
    FileFlush(csvHandle);

//--- fecha o arquivo
    FileClose(csvHandle);

    csvHandle = INVALID_HANDLE;  // invalida o handle do arquivo;
   }

//+------------------------------------------------------------------+
