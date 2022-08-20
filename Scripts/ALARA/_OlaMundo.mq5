//+------------------------------------------------------------------+
//|                                                     OlaMundo.mq5 |
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
//    datetime hoje = D'01.01.2016 13:43:23';
//
//    Alert("titulo qualquer", 234, false, TimeCurrent());
//
//    Sleep(5000);
//
//    Alert("segundo titulo", 2, true, TimeCurrent());

//int i = NULL;
//PrintFormat("Teste PrintFormat: %d", NULL);


//int i = 0;
//Print(LogFormat("Teste 1 de logging: %s %f %d", "i", 6.7, TimeLocal()));
//Print(LogFormat("Teste 2 de logging: %d %d %d", i));
//Print(LogFormat("Teste 3 de logging: %d %f %d ", i, 6.7));


//--- get possible filling policy types by symbol

//Print("\nORDER_FILLING_FOK = ", ORDER_FILLING_FOK);
//Print("ORDER_FILLING_IOC = ", ORDER_FILLING_IOC);
//Print("ORDER_FILLING_RETURN = ", ORDER_FILLING_RETURN);

    //Print("\n\tSYMBOL_FILLING_FOK = ", SYMBOL_FILLING_FOK);
    //Print("\tSYMBOL_FILLING_IOC = ", SYMBOL_FILLING_IOC);

//    uint filling = (uint) SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE);
//    Print("Simbolo ", Symbol(), " tem preenchimento SYMBOL_FILLING_MODE = ", filling);
//
//    if((filling & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
//       {
//        Print("    Simbolo ", Symbol(), " tem preenchimento SYMBOL_FILLING_FOK.");
//       }
//
//    if((filling&SYMBOL_FILLING_IOC)==SYMBOL_FILLING_IOC)
//       {
//        Print("    Simbolo ", Symbol(), " tem preenchimento SYMBOL_FILLING_IOC.");
//       }


    ENUM_SYMBOL_TRADE_EXECUTION exec = (ENUM_SYMBOL_TRADE_EXECUTION) SymbolInfoInteger(Symbol(), SYMBOL_TRADE_EXEMODE);
    Print(Symbol(), " : SYMBOL_TRADE_EXEMODE = ", EnumToString(exec));


   }


//+------------------------------------------------------------------+
