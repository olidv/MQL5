//+------------------------------------------------------------------+
//|                                                        Tempo.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

#property indicator_chart_window

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
//--- indicator buffers mapping
   
//--- temporizador:
    EventSetTimer(1);

    return(INIT_SUCCEEDED);
}

// Quando fechar o indicador, retirando-o do grafico.
void OnDeinit(const int reason) {
    EventKillTimer();
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//| Dispara quando o preço mudar. Se o mercado fechar, não executará.
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[]) {
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+


// Dispara a todo momento conforme a configuração do timer (EventSetTimer)
void OnTimer() {
    static int count = 0;
    
    count = (count % 5) + 1;
    
    //if (count < 5) {
        //count++;
    //} else {
        //count = 0;
    //}

    Comment(count);
}