//+------------------------------------------------------------------+
//|                                   EA_CSV_WriteIbovespaCandle.mq5 |
//|                              Copyright 2021, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <_ALARA\WinAPI_Time.mqh>

//--- Funcoes para processamento conforme a B3
#include <_B3\B3_Info.mqh>

//+------------------------------------------------------------------+

#define EA_TIMER   60     // Processo de coleta eh executado a cada minuto (60 segundos).

#define EA_START   10     // PRocesso inicia sempre aos 10 segundos de cada minuto, para dar tempo de fechar o candle anterior.

//+------------------------------------------------------------------+

const string FILE_SUFFIX_RATE = "_IBOV_Rate.csv";

int          hndCsvFile = INVALID_HANDLE;  // handle para arquivo CSV gerado.

// Data (apenas dd/mm/yyyy) do arquivo CSV gerado - parte do nome do arquivo;
datetime     dtDiaColeta;

//+------------------------------------------------------------------+

//---
int      qtdAtivos;     // Quantidade de ativos na Observação de Mercado
string   obsAtivos[];   // Armazena a relacao de ativos do observador

long     rateCont;      // Contabiliza o total de rates/candles coletados.


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
//--- Obtem a relacao de ativos no observador -> Carteira IBOV:
    qtdAtivos = SymbolsTotal(true); // quantidade de ativos na Observação de Mercado

//--- Total de ativos inferior a 10 significa que o observador nao esta carregado com carteira IBOV:
    if(qtdAtivos < 10)
       {
        Print("ERRO [IBOV] : 'Observação do Mercado' [", qtdAtivos, "] NÃO está carregada com Carteira IBOV...");
        return(INIT_FAILED);
       }

//--- Ja redimensiona o array de ativos da carteira:
    ArrayResize(obsAtivos, qtdAtivos);

//--- Relaciona os ativos da carteira IBOV (observacao do mercado):
    for(int i=0; i < qtdAtivos; i++)
       {
        obsAtivos[i] = SymbolName(i, true);
       }

//--- Inicializa as variaveis para coleta de dados e arquivo CSV:
    if(! BeginDataCollection(GetDate()))  // Obtem a data do dia da coleta - apenas dia/mes/ano, sem parte horas.
       {
        return(INIT_FAILED);
       }

//--- Atrasa alguns segundos, para pegar a transição de minutos:
    MqlDateTime dtCorrente;
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

//--- Inicializacao do robo efetuada com sucesso.
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
void OnTimer()
   {
//--- Verifica se o MT5 foi encerrado ou se o programa foi removido ou se passou do horario de fechamento da bolsa:
    if(_StopFlag || EncerrouNegociacaoB3())
       {
        // Imediatamente cancela timer para nao ser mais disparado.
        EventKillTimer();

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

//--- Obtem os 2 ultimos candles para cada ativo:
    for(int i=0; i < qtdAtivos; i++)
       {
        string nomAtivo = obsAtivos[i];  // reduz acessos a array

        // Obtem os 2 ultimos para ler o penultimo, pois o mais recente esta em andamento.
        MqlRates ratesM1[];
        ResetLastError();
        if(CopyRates(nomAtivo,PERIOD_M1,0,2,ratesM1) < 2)
           {
            Print("ERRO [IBOV] EM ", TimeToString(dtDiaColeta, TIME_DATE), " : NÃO foi possivel obter rates M1 do ativo '", nomAtivo, "'! Erro = ", GetLastError());
            continue;
           }

        MqlRates rateCandle = ratesM1[1];  // reduz acessos a array
        rateCont++;  // Para todos os ativos, esta iteração conta apenas como um rate/candle coletado.

        // identifica o time (unix-format) do penultimo candle ja formado:
        long timeCandle = ((long) rateCandle.time) * 1000;

        //--- chamar função para escrever no arquivo.
        FileWrite(hndCsvFile, nomAtivo, timeCandle, PrecoInteiro(nomAtivo, rateCandle.open), PrecoInteiro(nomAtivo, rateCandle.high),
                  PrecoInteiro(nomAtivo, rateCandle.low), PrecoInteiro(nomAtivo, rateCandle.close),
                  PrecoInteiro(nomAtivo, rateCandle.spread),
                  rateCandle.tick_volume, rateCandle.real_volume);
       }

//--- Os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
    FileFlush(hndCsvFile);
   }


//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
//--- Imediatamente cancela timer para nao ser mais disparado.
    EventKillTimer();

//--- Fecha os arquivos CSV e encerra coleta do dia anterior:
    EndDataCollection(dtDiaColeta);
   }


//+-------------------------------------------------------------------------------+
//| Inicializa as variaveis e estruturas para coleta de dados e arquivo(s) CSV.   |
//+-------------------------------------------------------------------------------+
bool BeginDataCollection(datetime dtCsvFile)
   {
//--- Obtem a data do dia da coleta - apenas dia/mes/ano, sem parte horas.
    dtDiaColeta = dtCsvFile;

//--- Zera contador de rates/candles coletados e salvos em CSV.
    rateCont = 0;

//--- Inicializa o arquivo CSV para RATEs dos ativos:
    hndCsvFile = OpenCsvFile(dtCsvFile);
    if(hndCsvFile == INVALID_HANDLE)
        return false;

    Print("INICIO [IBOV] EM ", TimeToString(dtCsvFile, TIME_DATE), " : WRITE RATE CSV FILE  |  ATIVOS DA CARTEIRA IBOV = ", qtdAtivos, "  |  TIMER = ", EA_TIMER, " seg");
    Print("-----------------------------------------------------------------------------------------------------");

//-- procedimento de inicializacao realizado com sucesso:
    return true;
   }


//+-------------------------------------------------------------------------------+
//| Fecha o arquivo CSV e encerra coleta do dia anterior.                         |
//+-------------------------------------------------------------------------------+
bool EndDataCollection(datetime dtCsvFile)
   {
//--- fecha o arquivo CSV do dia anterior:
    CloseCsvFile(hndCsvFile);

    Print("-----------------------------------------------------------------------------------------------------");
    Print("FIM [IBOV] EM ", TimeToString(dtCsvFile, TIME_DATE), " : Total de Ativos = ", qtdAtivos, "  |  Total de RATEs Obtidos no dia = ", rateCont);

//-- procedimento de finalizacao realizado com sucesso:
    return true;
   }


//+-------------------------------------------------------------------------------+
//| Inicializa o arquivo CSV para nova data e retorna o handle do arquivo criado. |
//+-------------------------------------------------------------------------------+
int OpenCsvFile(datetime dtCsvFile)
   {
//--- inicializa o arquivo CSV para RATEs:
    string fileName = TimeToString(dtCsvFile, TIME_DATE) + FILE_SUFFIX_RATE;
    bool fileExist = FileIsExist(fileName);

    ResetLastError();
    int csvHandle = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                    : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI);
    if(csvHandle == INVALID_HANDLE)
       {
        Print("ERRO [IBOV] EM ", TimeToString(dtCsvFile, TIME_DATE), " : Operação 'FileOpen(", fileName, ")' falhou! Erro = ", GetLastError());
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

//--- retorna o handle do arquivo aberto:
    return csvHandle;
   }


//+-------------------------------------------------------------------------------+
//| Fecha o arquivo CSV e encerra o handle do arquivo criado.                     |
//+-------------------------------------------------------------------------------+
void CloseCsvFile(int &csvHandle)
   {
//--- Se nem criou arquivo CSV, nada a fazer aqui...
    if(csvHandle == INVALID_HANDLE)
        return;

//--- grava os dados restantes do arquivo.
    FileFlush(csvHandle);

//--- fecha o arquivo e inutiliza handle:
    FileClose(csvHandle);

    csvHandle = INVALID_HANDLE;  // invalida o handle do arquivo;
   }

//+------------------------------------------------------------------+
