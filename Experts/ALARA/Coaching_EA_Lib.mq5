//+------------------------------------------------------------------+
//|                                              Coaching_EA_POO.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+
//| BIBLIOTECAS PADRÃO DA LINGUAGEM MQL5                             |
//+------------------------------------------------------------------+
#include <Charts\Chart.mqh>
#include <ChartObjects\ChartObjectsFibo.mqh>
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| DECLARAR VARIAVEIS DE CLASSES                                    |
//+------------------------------------------------------------------+
CChart grafico;
CChartObjectFibo fibo;
CTrade trade;  // já possui a função OrderSend() embutida.

//+------------------------------------------------------------------+
//| VARIAVEIS GLOBAIS                                                |
//+------------------------------------------------------------------+
MqlRates candle[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    //--- 
    ArraySetAsSeries(candle, true);
    CopyRates(_Symbol, _Period, 0, 100, candle);
    
    if (candle[3].close < candle[2].close && candle[2].close < candle[1].close) {
        
        //--- enviar ordem de compra (procedural)
//        MqlTradeRequest requisicao;
//        MqlTradeResult resultado;
//
//        ZeroMemory(requisicao);
//        ZeroMemory(resultado);
//
//        requisicao.action = TRADE_ACTION_DEAL;
//        requisicao.comment = "Compra a mercado";
//        ...
//                
//        OrderSend(requiscao, resultado);


        // se modo assíncrono ativo (true), não irá fazer a verificação da chegada da ordem no servidor da corretora.
        trade.SetAsyncMode(false);

        //--- enviar ordem de compra (orientada a objetos)
        ResetLastError();
        trade.Buy(1000, _Symbol, 0, 0, 0, "Compra a mercado");
        
        //--- verificação do retorno da ordem
        uint resultRetCode = trade.ResultRetcode();
        if (resultRetCode == 10008 || resultRetCode == 10009) {
            // ordem executada / enviada com sucesso!
            Print("ORDEM EXECUTADA / ENVIADA COM SUCESSO !");
        } else {
            Print("Erro ao enviar ordem. Erro : # ", GetLastError(), " / retorno = ", resultRetCode);
        }
    }
    
    //+------------------------------------------------------------------+
    //| ORDEM LIMITADA                                                   |
    //+------------------------------------------------------------------+
    trade.BuyLimit(1000, candle[0].close-0.05, _Symbol, 0, 0, ORDER_TIME_GTC, 0, "Compra na pedra");
    
    //+------------------------------------------------------------------+
    //| ORDEM STOP (START)                                               |
    //+------------------------------------------------------------------+
    trade.BuyStop(1000, candle[1].high+0.10, _Symbol, 0, 0, ORDER_TIME_GTC, 0, "Compra start");
   
    //---
//    grafico.Attach(0);
//    string ativo = grafico.Symbol();
//    ENUM_TIMEFRAMES _TF = (ENUM_TIMEFRAMES) grafico.Period();
//    int visBars = grafico.VisibleBars;
//    
//    //---
//    grafico.Mode(CHART_BARS);
//    Print("ativo = ", ativo, " / timeframe = ", EnumToString(_TF), " / barras = ", visBars);
//    
//    //grafico.ShowLineBid(true);

    //fibo.Create(0, "Fibonacci", 0, candle[22].time, candle[22].close, candle[5].time, candle[5].close);
    
    //---
    Print("EA inicializado com sucesso !");
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- destroy timer
    EventKillTimer();
   
}
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
    //---

}
