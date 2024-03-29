//+------------------------------------------------------------------+
//|                                                      Objetos.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

#property description "Essa ferramenta server para calcular o spread flutuante atual do ativo. "
                      "Foi feito através do tutorial de canal no YouTube 'Litoral Trading'."
#property icon        "stock.ico"

#property indicator_plots        0
#property indicator_chart_window

#include <ALARA\GUI_Object.mqh>

//+------------------------------------------------------------------+

const string TITULAR_CONTA_MT5 = "MetaTrader 5 Desktop Demo";
const string TITULAR_CONTA_CLEAR = "ALESSANDRA CRISTINA DE CASTRO";

enum Conta {
    CONTA_MT5_DEMO   = 28849071,   // Conta MetaQuotes Demo
    CONTA_CLEAR_DEMO = 1091130825, // Conta Clear Demo
    CONTA_CLEAR_REAL = 1001130825  // Conta Clear Real
};


input int    InputTamanho   = 24;                     // Tamanho da Fonte
input string InputFonte     = "Calibri Bold";         // Fonte
input color  InputCor       = (color) "clrMagenta";   // Cor
input int    InputDistancia = 8;                      // Distância do Gráfico
input string InputTexto     = "pontos";               // Rótulo
input Conta  InputConta     = CONTA_MT5_DEMO;         // Conta Corretora
input bool   questao        = false;                  // Questão
input bool   InputTimeframe = true;                   // Exibir Timeframe

input ENUM_TIMEFRAMES InputTempo = PERIOD_H1;         // Timeframe

string tf_texto;


//+------------------------------------------------------------------+
//| INÍCIO                                                           |
//+------------------------------------------------------------------+
int OnInit() {  // indicator buffers mapping
    EventSetTimer(1);

    // Condição com operador ternário.
    //Alert("A questão é " + (questao ? "VERDADEIRO" : "FALSO"));
    
    tf_texto = PeriodToString(InputTempo);
    //Alert(tf_texto);

    // Proteger o arquivo MQL5: VERIFICAR O NÚMERO DA CONTA
    long accountLogin = AccountInfoInteger(ACCOUNT_LOGIN);
    if (accountLogin != CONTA_MT5_DEMO) {
        Alert("Conta não cadastrada!");
        return(INIT_FAILED);
    }
    
    // Proteger o arquivo MQL5: VERIFICAR O TITULAR DA CONTA
    string titular = AccountInfoString(ACCOUNT_NAME);
    if (titular != TITULAR_CONTA_MT5) {
        Alert("Titular não cadastrado!");
        return(INIT_FAILED);
    }
        
    //Alert("A largura do gráfico, em pixels, eh: " + (string) LarguraDoGrafico());    
    
    if (ChecarSeMaiorQueDez(15)) {
        //Alert("Eh maior que 10");
    } else {
        //Alert("Eh menor que 10");
    }
    
    return(INIT_SUCCEEDED);
}
  
//+------------------------------------------------------------------+
//| CÁLCULOS                                                         |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[]) {
    //--- Rótulo
    string label = "Spread: " + (string) SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) + " " + InputTexto;
    CriarTexto(0, "InfoSpread",InputDistancia, InputDistancia, label, InputTamanho, 
               InputCor, InputFonte, ANCHOR_RIGHT_UPPER, CORNER_RIGHT_UPPER, false, true, true);
    //CriarTexto(0, "objeto2", 100, 200, "Segunda Função", 12, clrWheat, "Calibri", ANCHOR_LEFT_LOWER, CORNER_LEFT_LOWER);
    //CriarTexto(0, "objeto3", 100, 300, "Terceira Função", 12, clrGreen, "San Serif", ANCHOR_RIGHT_LOWER, CORNER_RIGHT_LOWER);

    //--- Botões
    CriarBotao(0, "BotaoComprar", 4, 32+32+32+4+4+4, 100, 32, CORNER_LEFT_LOWER, 12, "Calibri", "COMPRAR", 
               clrWhite, clrBlue, clrBlack, false, false, false, "Ordem de Compra");

    CriarBotao(0, "BotaoVender", 4, 32+32+4+4, 100, 32, CORNER_LEFT_LOWER, 12, "Calibri", "VENDER", 
               clrWhite, clrMaroon, clrBlack, false, false, false, "Ordem de Venda");

    CriarBotao(0, "BotaoZerar", 4, 32+4, 100, 32, CORNER_LEFT_LOWER, 12, "Calibri", "ZERAR",
               clrWhite, clrGray, clrBlack, false, false, false, "Fechar operações");
       
    //--- return value of prev_calculated for next call
    return(rates_total);
}

//+------------------------------------------------------------------+
//| EVENTOS DO GRÁFICO: ChartEvent function.                         |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) {
    //--- captura click genérico no gráfico
    if (id == CHARTEVENT_OBJECT_CLICK) {
        if (sparam == "BotaoComprar") {
            Print("Você clicou no botão COMPRAR!");
        } else if (sparam == "BotaoVender") {
            Print("Você clicou no botão VENDER!");
        } else if (sparam == "BotaoZerar") {
            Print("Você clicou no botão ZERAR!");
        }
    }
}

//+------------------------------------------------------------------+
//| TIMER                                                            |
//+------------------------------------------------------------------+
void OnTimer() {
    // Marca d'água
    string label = (InputTimeframe ? PeriodToString(_Period)+"/" : "") + _Symbol;
    
    CriarTexto(0, "MarcaDagua", (int) ChartGetInteger(0, CHART_WIDTH_IN_PIXELS)/2, (int) ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS)/2,
               label, InputTamanho, clrGray, "Arial", ANCHOR_CENTER, CORNER_LEFT_UPPER, false, true, true);
    // Força a renderização após mudança no (tamanho) grafico...
    ChartRedraw();               
}

//+------------------------------------------------------------------+
//| DESTRUIÇÃO                                                       |
//+------------------------------------------------------------------+

void OnDeinit(const int reason) {
    // Desconsidera o timer...
    EventKillTimer();
    
    // Elimina os objetos inseridos no gráfico:
    ObjectDelete(0, "MarcaDagua");
    ObjectDelete(0, "InfoSpread");
}

//+------------------------------------------------------------------+
