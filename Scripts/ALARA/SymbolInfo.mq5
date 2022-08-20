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
    //uint order_mode = (uint) SymbolInfoInteger(Symbol(), SYMBOL_ORDER_MODE);
    //Print("\n",Symbol(), " -> SYMBOL_ORDER_MODE:");
    //if ((order_mode & SYMBOL_ORDER_MARKET) != 0)
    //    Print("    SYMBOL_ORDER_MARKET");
    //if ((order_mode & SYMBOL_ORDER_LIMIT) != 0)
    //    Print("    SYMBOL_ORDER_LIMIT");
    //if ((order_mode & SYMBOL_ORDER_STOP) != 0)
    //    Print("    SYMBOL_ORDER_STOP");
    //if ((order_mode & SYMBOL_ORDER_STOP_LIMIT ) != 0)
    //    Print("    SYMBOL_ORDER_STOP_LIMIT ");
    //if ((order_mode & SYMBOL_ORDER_SL) != 0)
    //    Print("    SYMBOL_ORDER_SL");
    //if ((order_mode & SYMBOL_ORDER_TP) != 0)
    //    Print("    SYMBOL_ORDER_TP");
    //if ((order_mode & SYMBOL_ORDER_CLOSEBY) != 0)
    //    Print("    SYMBOL_ORDER_CLOSEBY");

//---
    uint expire_mode = (uint) SymbolInfoInteger(Symbol(), SYMBOL_EXPIRATION_MODE);
    Print("\n",Symbol(), " -> SYMBOL_EXPIRATION_MODE:");
    if ((expire_mode & SYMBOL_EXPIRATION_GTC) != 0)
        Print("    SYMBOL_EXPIRATION_GTC");
    if ((expire_mode & SYMBOL_EXPIRATION_DAY) != 0)
        Print("    SYMBOL_EXPIRATION_DAY");
    if ((expire_mode & SYMBOL_EXPIRATION_SPECIFIED) != 0)
        Print("    SYMBOL_EXPIRATION_SPECIFIED");
    if ((expire_mode & SYMBOL_EXPIRATION_SPECIFIED_DAY ) != 0)
        Print("    SYMBOL_EXPIRATION_SPECIFIED_DAY ");



   }


//+------------------------------------------------------------------+
