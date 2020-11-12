//+------------------------------------------------------------------+
//|                                             EA_CSV_WriteTick.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <_ALARA\WinAPI_Time.mqh>

//--- Funcoes para processamento conforme o FOREX
#include <_FOREX\FOREX_Info.mqh>

//+------------------------------------------------------------------+

#define EA_TIMER    5     // timer em segundos

#define DATA_SIZE   5000  // limite de 1000 registros p/ segundo (1 evento a cada 1 milisegundo)

//+------------------------------------------------------------------+

struct SPriceTick {
    int          idTick;
    int          localTime;
    MqlTick      tickInfo;
};

//+------------------------------------------------------------------+

//---
const string FILE_SUFFIX_TICK = "_Tick.csv";
int          csvHandleTick = INVALID_HANDLE;
datetime     dtCsvFile;

//---
int          tickCont = 0,
             idLastTick = 0;  // corresponde ao total de registros de tick coletados
SPriceTick   tickData[DATA_SIZE];

// indica se o processamento foi finalizado pelo Timer:
bool         isTimerKilled = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    //--- inicializa as variaveis e estruturas para coleta de dados:
    InitDataCollection();
    dtCsvFile = GetDate(); // apenas dia/mes/ano, sem parte horas.

    //--- inicializa o arquivo CSV para TICKs:
    csvHandleTick = OpenCsvFile(dtCsvFile);
    if (csvHandleTick == INVALID_HANDLE) 
        return (INIT_FAILED);

    //--- create timer
    if (! EventSetTimer(EA_TIMER)) 
        return(INIT_FAILED);

    //---
    return (INIT_SUCCEEDED);
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
//| pode prejudicar / atrasar o disparo de OnTick(). |
//+------------------------------------------------------------------+
void OnTimer() {
    //---
    if (tickCont > 0) {
        //--- gravar dados no arquivo
        SPriceTick tick;
        for (int i = 1; i <= tickCont; i++) {
            tick = tickData[i];

            //--- chamar função de escrever 
            FileWrite(csvHandleTick, tick.idTick, (HOJE_MILISSEGUNDOS + tick.localTime), tick.tickInfo.time_msc, 
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
    if (_StopFlag || EncerrouNegociacaoForex()) {
        // registra o final do processamento:
        isTimerKilled = true;

        //---
        EventKillTimer();  //--- destroy timer

        //--- fecha o arquivo CSV
        CloseCsvFile(csvHandleTick); 

        Print("----------------------------------------------------------------------");
        Print("EA [", _Symbol, "] :  Programa Encerrado! Total de TICKs Obtidos = ", IntegerToString(idLastTick,7));

    //---
    } else { // verifica se passou para outro dia:
        datetime dtCurrent = GetDate();
    
        if (dtCsvFile < dtCurrent) { 
            //--- fecha o arquivo CSV do dia anterior:
            CloseCsvFile(csvHandleTick); 
    
            Print("----------------------------------------------------------------------");
            Print("EA [", _Symbol, "] :  Total de TICKs Obtidos no dia = ", IntegerToString(idLastTick,7));
    
            //--- inicializa as variaveis e estruturas para nova coleta de dados:
            InitDataCollection();
            dtCsvFile = dtCurrent;
    
            //--- precisa gerar outro arquivo CSV para o dia corrente:
            csvHandleTick = OpenCsvFile(dtCsvFile);
            if (csvHandleTick == INVALID_HANDLE) {
                ExpertRemove();  // encerra o EA devido a falha de gravacao do arquivo.
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- Verifica se o timer ja foi finalizado:
    if (! isTimerKilled) {
        //--- grava os ultimos registros e encerra o timer:
        OnTimer();  // aqui o valor de _StopFlag = true
    }
}

//+-------------------------------------------------------------------------------+
//| Inicializa as variaveis e estruturas para coleta de dados.                    |
//+-------------------------------------------------------------------------------+
void InitDataCollection() {
    Print("EA [", _Symbol, "] :  WRITE TICK CSV FILE  |  TIMER = ", EA_TIMER, " seg");
    Print("----------------------------------------------------------------------");

    //--- inicializa o ID para novo contador do dia:
    idLastTick = 0;
    tickCont = 0;
}

//+-------------------------------------------------------------------------------+
//| Inicializa o arquivo CSV para nova data e retorna o handle do arquivo criado. |
//+-------------------------------------------------------------------------------+
int OpenCsvFile(datetime dtDiaArquivo) {
    //--- inicializa o arquivo CSV para TICKs:
    string fileName = TimeToString(dtDiaArquivo, TIME_DATE) + "_" + _Symbol + FILE_SUFFIX_TICK;
    bool fileExist = FileIsExist(fileName);
    
    ResetLastError();
    int csvHandle = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                              : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI); 
    if (csvHandle == INVALID_HANDLE) {
        Print("EA [", _Symbol, "] :  Operação 'FileOpen(", fileName, ")' falhou! Erro = ", GetLastError()); 

    } else if (fileExist) {
       FileSeek(csvHandle, 0, SEEK_END);

    } else {
        FileWrite(csvHandle, "ID_TICK", "LOCAL_TIME", "TIME", "BID", "ASK", "LAST", "VOLUME",
                             "FLAG_BID", "FLAG_ASK", "FLAG_LAST", "FLAG_VOLUME", "FLAG_BUY", "FLAG_SELL");
    }

    //--- retorna o handle do arquivo para gravacao dos registros.
    return (csvHandle);
}


//+-------------------------------------------------------------------------------+
//| Fecha o arquivo CSV e encerra o handle do arquivo criado.                     |
//+-------------------------------------------------------------------------------+
void CloseCsvFile(int &csvHandle) {
    //--- grava os dados restantes do arquivo.
    FileFlush(csvHandle);

    //--- fecha o arquivo
    FileClose(csvHandle); 

    csvHandle = INVALID_HANDLE;  // invalida o handle do arquivo;
}

//+------------------------------------------------------------------+
