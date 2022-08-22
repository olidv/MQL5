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
   Print("\nSIMBOLO: ", Symbol());
   
//---
    uint order_mode = (uint) SymbolInfoInteger(Symbol(), SYMBOL_ORDER_MODE);
    Print(" -> SYMBOL_ORDER_MODE: ", order_mode);
    if ((order_mode & SYMBOL_ORDER_MARKET) != 0)
        Print("        SYMBOL_ORDER_MARKET");
    if ((order_mode & SYMBOL_ORDER_LIMIT) != 0)
        Print("        SYMBOL_ORDER_LIMIT");
    if ((order_mode & SYMBOL_ORDER_STOP) != 0)
        Print("        SYMBOL_ORDER_STOP");
    if ((order_mode & SYMBOL_ORDER_STOP_LIMIT ) != 0)
        Print("        SYMBOL_ORDER_STOP_LIMIT ");
    if ((order_mode & SYMBOL_ORDER_SL) != 0)
        Print("        SYMBOL_ORDER_SL");
    if ((order_mode & SYMBOL_ORDER_TP) != 0)
        Print("        SYMBOL_ORDER_TP");
    if ((order_mode & SYMBOL_ORDER_CLOSEBY) != 0)
        Print("        SYMBOL_ORDER_CLOSEBY");

//---
    uint filling_mode = (uint) SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE);
    Print(" -> SYMBOL_FILLING_MODE: ", filling_mode);
    if (filling_mode == 0)
        Print("        FILLING_RETURN");
    if ((filling_mode & SYMBOL_FILLING_FOK) != 0)
        Print("        SYMBOL_FILLING_FOK");
    if ((filling_mode & SYMBOL_FILLING_IOC) != 0)
        Print("        SYMBOL_FILLING_IOC");

//---
    uint expire_mode = (uint) SymbolInfoInteger(Symbol(), SYMBOL_EXPIRATION_MODE);
    Print(" -> SYMBOL_EXPIRATION_MODE: ", expire_mode);
    if ((expire_mode & SYMBOL_EXPIRATION_GTC) != 0)
        Print("        SYMBOL_EXPIRATION_GTC");
    if ((expire_mode & SYMBOL_EXPIRATION_DAY) != 0)
        Print("        SYMBOL_EXPIRATION_DAY");
    if ((expire_mode & SYMBOL_EXPIRATION_SPECIFIED) != 0)
        Print("        SYMBOL_EXPIRATION_SPECIFIED");
    if ((expire_mode & SYMBOL_EXPIRATION_SPECIFIED_DAY ) != 0)
        Print("        SYMBOL_EXPIRATION_SPECIFIED_DAY ");
   }


//+------------------------------------------------------------------+
