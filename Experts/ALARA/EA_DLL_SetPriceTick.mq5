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

#define EA_TIMER    10     // timer em segundos

//+------------------------------------------------------------------+

struct SPriceTick {
    int          idTick;
    int          localTime;
    MqlTick      tickInfo;
};

//+------------------------------------------------------------------+

//---
int idLastTick = 0;  // corresponde ao total de registros de tick coletados

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    Print("EA [", _Symbol, "] :  CALL DLL ( TICK )");
    Print("----------------------------------------------------------------------");

    //--- inicializa o processamento da DLL para BOOKs e TICKs:


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
    // ultima mudanca no price tick
    SPriceTick tick;
    if (SymbolInfoTick(_Symbol, tick.tickInfo)) {
        // data-hora local no momento da obtencao do tick
        tick.localTime = GetMillisecondsTime(); // soh a parte hora, em milissegundos

        // mais um registro de alteracao de preco (tick)
        tick.idTick = ++idLastTick;
        
        // Repassa o registro de tick para a DLL:
        
    }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//| Periodicamente verifica se encerrou o pregao da B3 ou se o       |
//| programa foi encerrado por outro processo.                       |
//+------------------------------------------------------------------+
void OnTimer() {
    //---
    if (EncerrouPregaoB3() || _StopFlag) {
        //--- destroy timer
        EventKillTimer();

        Print("----------------------------------------------------------------------");
        Print("EA [", _Symbol, "] :  Programa Encerrado! Total de TICKs Obtidos = ", IntegerToString(idLastTick,7));
        
        //Interrompe o Expert Advisor e o descarrega do gráfico
        ExpertRemove();

    } else {
        Print("EA [", _Symbol, "] :  TICKs Gravados = ", IntegerToString(idLastTick,7));
        Print("----------------------------------------------------------------------");
    }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- efetua o encerramento do timer:
    OnTimer();  // aqui o valor de _StopFlag = true
}

//+------------------------------------------------------------------+
