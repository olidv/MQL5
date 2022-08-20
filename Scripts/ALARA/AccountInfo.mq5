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
    Print("\nENUM_ACCOUNT_INFO_STRING");
    Print("    ACCOUNT_NAME = ", AccountInfoString(ACCOUNT_NAME));
    Print("    ACCOUNT_COMPANY = ", AccountInfoString(ACCOUNT_COMPANY));
    Print("    ACCOUNT_SERVER = ", AccountInfoString(ACCOUNT_SERVER));
    Print("    ACCOUNT_CURRENCY = ", AccountInfoString(ACCOUNT_CURRENCY));

//---
    Print("\nENUM_ACCOUNT_INFO_INTEGER");
    Print("    ACCOUNT_LOGIN = ", AccountInfoInteger(ACCOUNT_LOGIN));
    Print("    ACCOUNT_TRADE_MODE = ", EnumToString((ENUM_ACCOUNT_TRADE_MODE) AccountInfoInteger(ACCOUNT_TRADE_MODE)));
    Print("    ACCOUNT_LEVERAGE = ", AccountInfoInteger(ACCOUNT_LEVERAGE));
    Print("    ACCOUNT_LIMIT_ORDERS = ", AccountInfoInteger(ACCOUNT_LIMIT_ORDERS));
    Print("    ACCOUNT_MARGIN_SO_MODE = ", EnumToString((ENUM_ACCOUNT_STOPOUT_MODE) AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE)));
    Print("    ACCOUNT_TRADE_ALLOWED = ", AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) == 1);
    Print("    ACCOUNT_TRADE_EXPERT = ", AccountInfoInteger(ACCOUNT_TRADE_EXPERT) == 1);
    Print("    ACCOUNT_MARGIN_MODE = ", EnumToString((ENUM_ACCOUNT_MARGIN_MODE) AccountInfoInteger(ACCOUNT_MARGIN_MODE)));
    Print("    ACCOUNT_CURRENCY_DIGITS = ", AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS));
    Print("    ACCOUNT_FIFO_CLOSE = ", AccountInfoInteger(ACCOUNT_FIFO_CLOSE) == 1);
    Print("    ACCOUNT_HEDGE_ALLOWED = ", AccountInfoInteger(ACCOUNT_HEDGE_ALLOWED) == 1);

//---
    Print("\nENUM_ACCOUNT_INFO_DOUBLE");
    Print("    ACCOUNT_BALANCE = ", AccountInfoDouble(ACCOUNT_BALANCE));
    Print("    ACCOUNT_CREDIT = ", AccountInfoDouble(ACCOUNT_CREDIT));
    Print("    ACCOUNT_PROFIT = ", AccountInfoDouble(ACCOUNT_PROFIT));
    Print("    ACCOUNT_EQUITY = ", AccountInfoDouble(ACCOUNT_EQUITY));
    Print("    ACCOUNT_MARGIN = ", AccountInfoDouble(ACCOUNT_MARGIN));
    Print("    ACCOUNT_MARGIN_FREE = ", AccountInfoDouble(ACCOUNT_MARGIN_FREE));
    Print("    ACCOUNT_MARGIN_LEVEL = ", AccountInfoDouble(ACCOUNT_MARGIN_LEVEL));
    Print("    ACCOUNT_MARGIN_SO_CALL = ", AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL));
    Print("    ACCOUNT_MARGIN_SO_SO = ", AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));
    Print("    ACCOUNT_MARGIN_INITIAL = ", AccountInfoDouble(ACCOUNT_MARGIN_INITIAL));
    Print("    ACCOUNT_MARGIN_MAINTENANCE = ", AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE));
    Print("    ACCOUNT_ASSETS = ", AccountInfoDouble(ACCOUNT_ASSETS));
    Print("    ACCOUNT_LIABILITIES = ", AccountInfoDouble(ACCOUNT_LIABILITIES));
    Print("    ACCOUNT_COMMISSION_BLOCKED = ", AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED));
   }


//+------------------------------------------------------------------+
