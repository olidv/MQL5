//+------------------------------------------------------------------+
//|                                                       Robotu.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"
#property description "Robô para realização de operações de compra e venda. "
                      "Foi feito através do tutorial de canal no YouTube 'Litoral Trading'."

#property indicator_plots        0
#property indicator_chart_window

#include <ALARA\GUI_Object.mqh>
#include <TradeAlt.mqh>

input double InputTP = 100; // Take Profit (pontos)
input double InputSL = 100; // Stop Loss (pontos)

//+------------------------------------------------------------------+

CTradeAlt MeuTrade;

double ASK, BID;
int posicoes;

//+------------------------------------------------------------------+
//| INICIALIZAÇÃO: Expert initialization function                    |
//+------------------------------------------------------------------+
int OnInit() {
    //--- Botões
    CriarBotao(0, "BotaoComprar", 4, 32+32+32+4+4+4, 100, 32, CORNER_LEFT_LOWER, 12, "Calibri", "COMPRAR", 
               clrWhite, clrBlue, clrBlack, false, true, false, "Ordem de Compra");

    CriarBotao(0, "BotaoVender", 4, 32+32+4+4, 100, 32, CORNER_LEFT_LOWER, 12, "Calibri", "VENDER", 
               clrWhite, clrMaroon, clrBlack, false, true, false, "Ordem de Venda");

    CriarBotao(0, "BotaoZerar", 4, 32+4, 100, 32, CORNER_LEFT_LOWER, 12, "Calibri", "ZERAR",
               clrWhite, clrGray, clrBlack, false, true, false, "Fechar operações");

    //---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| FINALIZAÇÃO: Expert deinitialization function                    |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    // Elimina os objetos inseridos no gráfico:
    ObjectDelete(0, "BotaoComprar");
    ObjectDelete(0, "BotaoVender");
    ObjectDelete(0, "BotaoZerar");
}

//+------------------------------------------------------------------+
//| CÁLCULO DO PREÇO: Expert tick function                           |
//+------------------------------------------------------------------+
void OnTick() {
    //--- Valores para operações:
    ASK = SymbolInfoDouble(_Symbol, SYMBOL_ASK);    
    BID = SymbolInfoDouble(_Symbol, SYMBOL_BID);    
    //Comment("Bid: " + BID);
}

//+------------------------------------------------------------------+
//| EVENTOS DO GRÁFICO: ChartEvent function                          |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) {
    //--- captura click genérico no gráfico
    if (id == CHARTEVENT_OBJECT_CLICK) {
        // COMPRAR
        if (sparam == "BotaoComprar") {
            Print("Você clicou no botão COMPRAR!");
            MeuTrade.Buy(0.01, _Symbol, ASK,                   // Preço de Entrada
                                        ASK-(InputSL*_Point),  // Stop Loss
                                        ASK+(InputTP*_Point)); // Take Profit
        // VENDER
        } else if (sparam == "BotaoVender") {
            Print("Você clicou no botão VENDER!");
            MeuTrade.Sell(0.01, _Symbol, BID,                   // Preço de Entrada
                                         BID+(InputSL*_Point),  // Stop Loss
                                         BID-(InputTP*_Point)); // Take Profit
        // ZERAR
        } else if (sparam == "BotaoZerar") {
            Print("Você clicou no botão ZERAR!");
            Print("Qtde Posições abertas = " + PositionsTotal());
            Print("Posições(0) = " + PositionGetSymbol(0));
            for (int i = PositionsTotal()-1; i >= 0; i--) {
                if (PositionGetSymbol(i) == _Symbol) {
                    if (!MeuTrade.PositionClose(PositionGetTicket(i))) {
                        Print("ERRO: " + GetLastError());
                    }
                }
            }
        }
    }
}

//+------------------------------------------------------------------+
