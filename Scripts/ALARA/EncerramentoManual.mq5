//+------------------------------------------------------------------+
//|                                           EncerramentoManual.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

MqlRates rates[];

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    //---
    ArraySetAsSeries(rates, true);

    while (! IsStopped())
    {
        int copied = CopyRates(_Symbol, _Period, 0, 5, rates);
        if (copied > 0)
        {
            Print("Abertura : ", rates[0].open, " Hora : ", rates[0].time);
        }

        Sleep(3000);
    }    
}

//+------------------------------------------------------------------+
