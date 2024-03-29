//+------------------------------------------------------------------+
//|                                                  PrecosAtivo.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    //---
    MqlRates rates[];
    
    int copied = CopyRates(_Symbol, _Period, 0, 10, rates);
    if (copied <= 0)
    {
        Print("Erro ao copiar dados de preços ", GetLastError());
    } 
    else
    {
        Print("Copied ", ArraySize(rates), " bars");
    }
        
    for (int index = 0; index < ArraySize(rates); index++)
    {
        Print(" Abertura : rates[", index, "] = ", DoubleToString(rates[index].open, 5), " Hora : ", rates[index].time);
    }

    ArraySetAsSeries(rates, true); // Inverte a ordem para facilitar o entendimento.
    Print(" ----- ArraySetAsSeries(rates, true) -----");
            
    for (int index = 0; index < ArraySize(rates); index++)
    {
        Print(" Abertura : rates[", index, "] = ", DoubleToString(rates[index].open, 5), " Hora : ", rates[index].time);
    }
}

//+------------------------------------------------------------------+
