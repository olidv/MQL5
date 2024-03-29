//+------------------------------------------------------------------+
//|                                                 InfoTerminal.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//---
struct SYSTEMTIME {
    ushort wYear;
    ushort wMonth;
    ushort wDayOfWeek;
    ushort wDay;
    ushort wHour;
    ushort wMinute;
    ushort wSecond;
    ushort wMilliseconds;
};

#import "kernel32.dll"
    void GetSystemTime(SYSTEMTIME &system_time);
    void GetLocalTime(SYSTEMTIME &system_time);
#import

string TerminalInfoBool(ENUM_TERMINAL_INFO_INTEGER property_id) {
    int info = TerminalInfoInteger(property_id);
    return (info == 0) ? "false" : "true";
}

string MQLInfoBool(ENUM_MQL_INFO_INTEGER property_id) {
    int info = MQLInfoInteger(property_id);
    return (info == 0) ? "false" : "true";
}

string AccountInfoBool(ENUM_ACCOUNT_INFO_INTEGER property_id) {
    long info = AccountInfoInteger(property_id);
    return (info == 0) ? "false" : "true";
}

string SymbolInfoBool(string symbol, ENUM_SYMBOL_INFO_INTEGER property_id) {
    long info = SymbolInfoInteger(symbol, property_id);
    return (info == 0) ? "false" : "true";
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    Print("**** FUNÇÕES DE DATA E HORA ****");

    Print("    TimeCurrent() = ", TimeCurrent());
    Print("    TimeTradeServer() = ", TimeTradeServer());
    Print("    TimeGMT() = ", TimeGMT());
    Print("    TimeGMTOffset() = ", TimeGMTOffset());
    Print("    TimeDaylightSavings() = ", TimeDaylightSavings());
    Print("    TimeLocal() = ", TimeLocal());

    SYSTEMTIME systemTime;
    GetSystemTime(systemTime);
    PrintFormat("    GetSystemTime() = %04d/%02d/%02d %02d:%02d:%02d:%03d [%d]",
                systemTime.wYear,systemTime.wMonth,systemTime.wDay,
                systemTime.wHour,systemTime.wMinute,systemTime.wSecond,systemTime.wMilliseconds,systemTime.wDayOfWeek);

    ZeroMemory(systemTime);
    GetLocalTime(systemTime);
    PrintFormat("    GetLocalTime() = %04d/%02d/%02d %02d:%02d:%02d:%03d [%d]",
                systemTime.wYear,systemTime.wMonth,systemTime.wDay,
                systemTime.wHour,systemTime.wMinute,systemTime.wSecond,systemTime.wMilliseconds,systemTime.wDayOfWeek);
    Print("");

    Print("**** INFORMAÇÕES SOBRE O CÓDIGO EXPERT-ADVISOR ****");

    Print("    __MQLBUILD__ = ",__MQLBUILD__,"  /  __FILE__ = ",__FILE__,"  /  __DATETIME__ = ",__DATETIME__);
    Print("    __PATH__ = ",__PATH__);
    Print("    __FUNCTION__ = ",__FUNCTION__,"  /  __LINE__ = ",__LINE__); 

    Print("    MQL_PROGRAM_NAME = ",MQLInfoString(MQL_PROGRAM_NAME)); 
    Print("    MQL_PROGRAM_PATH = ",MQLInfoString(MQL_PROGRAM_PATH)); 

    Print("    MQL_DLLS_ALLOWED = ",MQLInfoBool(MQL_DLLS_ALLOWED)); 
    Print("    MQL_TRADE_ALLOWED = ",MQLInfoBool(MQL_TRADE_ALLOWED)); 
    Print("    MQL_SIGNALS_ALLOWED = ",MQLInfoBool(MQL_SIGNALS_ALLOWED)); 
    Print("    MQL_DEBUG = ",MQLInfoBool(MQL_DEBUG)); 
    Print("    MQL_PROFILER = ",MQLInfoBool(MQL_PROFILER)); 
    Print("    MQL_TESTER = ",MQLInfoBool(MQL_TESTER)); 
    Print("    MQL_FORWARD = ",MQLInfoBool(MQL_FORWARD)); 
    Print("    MQL_OPTIMIZATION = ",MQLInfoBool(MQL_OPTIMIZATION)); 
    Print("    MQL_VISUAL_MODE = ",MQLInfoBool(MQL_VISUAL_MODE)); 
    Print("    MQL_FRAME_MODE = ",MQLInfoBool(MQL_FRAME_MODE)); 

    PrintFormat("    MQL_MEMORY_LIMIT = %d MB",MQLInfoInteger(MQL_MEMORY_LIMIT)); 
    PrintFormat("    MQL_MEMORY_USED = %d MB",MQLInfoInteger(MQL_MEMORY_USED)); 

    string info = "";
    switch (MQLInfoInteger(MQL_PROGRAM_TYPE)) {
       case PROGRAM_SCRIPT : info = "PROGRAM_SCRIPT"; break;
       case PROGRAM_EXPERT : info = "PROGRAM_EXPERT"; break;
       case PROGRAM_INDICATOR : info = "PROGRAM_INDICATOR"; break;
    }
    Print("    MQL_PROGRAM_TYPE = ",info); 

    info = "";
    switch (MQLInfoInteger(MQL_LICENSE_TYPE)) {
       case LICENSE_FREE : info = "LICENSE_FREE"; break;
       case LICENSE_DEMO : info = "LICENSE_DEMO"; break;
       case LICENSE_FULL : info = "LICENSE_FULL"; break;
       case LICENSE_TIME : info = "LICENSE_TIME"; break;
    }
    Print("    MQL_LICENSE_TYPE = ",info); 
    Print("");

    Print("**** INFORMAÇÕES SOBRE O METATRADER TERMINAL ****");
    
    Print("    TERMINAL_LANGUAGE = ",TerminalInfoString(TERMINAL_LANGUAGE)); 
    Print("    TERMINAL_COMPANY = ",TerminalInfoString(TERMINAL_COMPANY)); 
    Print("    TERMINAL_NAME = ",TerminalInfoString(TERMINAL_NAME)); 
    Print("    TERMINAL_PATH = ",TerminalInfoString(TERMINAL_PATH)); 
    Print("    TERMINAL_DATA_PATH = ",TerminalInfoString(TERMINAL_DATA_PATH)); 
    Print("    TERMINAL_COMMONDATA_PATH = ",TerminalInfoString(TERMINAL_COMMONDATA_PATH)); 

    Print("    TERMINAL_COMMUNITY_CONNECTION = ",TerminalInfoBool(TERMINAL_COMMUNITY_CONNECTION)); 
    Print("    TERMINAL_CONNECTED = ",TerminalInfoBool(TERMINAL_CONNECTED)); 
    Print("    TERMINAL_DLLS_ALLOWED = ",TerminalInfoBool(TERMINAL_DLLS_ALLOWED)); 
    Print("    TERMINAL_TRADE_ALLOWED = ",TerminalInfoBool(TERMINAL_TRADE_ALLOWED)); 
    Print("    TERMINAL_FTP_ENABLED = ",TerminalInfoBool(TERMINAL_FTP_ENABLED)); 
    Print("    TERMINAL_EMAIL_ENABLED = ",TerminalInfoBool(TERMINAL_EMAIL_ENABLED)); 
    Print("    TERMINAL_NOTIFICATIONS_ENABLED = ",TerminalInfoBool(TERMINAL_NOTIFICATIONS_ENABLED)); 
    Print("    TERMINAL_MQID = ",TerminalInfoBool(TERMINAL_MQID)); 
    Print("    TERMINAL_VPS = ",TerminalInfoBool(TERMINAL_VPS)); 
    Print("    TERMINAL_X64 = ",TerminalInfoBool(TERMINAL_X64)); 

    Print("    TERMINAL_BUILD = ",TerminalInfoInteger(TERMINAL_BUILD)); 
    Print("    TERMINAL_CPU_CORES = ",TerminalInfoInteger(TERMINAL_CPU_CORES)); 
    PrintFormat("    TERMINAL_DISK_SPACE = %d MB",TerminalInfoInteger(TERMINAL_DISK_SPACE)); 
    PrintFormat("    TERMINAL_MEMORY_PHYSICAL = %d MB",TerminalInfoInteger(TERMINAL_MEMORY_PHYSICAL)); 
    PrintFormat("    TERMINAL_MEMORY_TOTAL = %d MB",TerminalInfoInteger(TERMINAL_MEMORY_TOTAL)); 
    PrintFormat("    TERMINAL_MEMORY_AVAILABLE = %d MB",TerminalInfoInteger(TERMINAL_MEMORY_AVAILABLE)); 
    PrintFormat("    TERMINAL_MEMORY_USED = %d MB",TerminalInfoInteger(TERMINAL_MEMORY_USED)); 
    Print("    TERMINAL_CODEPAGE = ",TerminalInfoInteger(TERMINAL_CODEPAGE)); 
    Print("    TERMINAL_MAXBARS = ",TerminalInfoInteger(TERMINAL_MAXBARS)); 
    Print("    TERMINAL_OPENCL_SUPPORT = ",TerminalInfoInteger(TERMINAL_OPENCL_SUPPORT)); 
    Print("    TERMINAL_SCREEN_DPI = ",TerminalInfoInteger(TERMINAL_SCREEN_DPI)); 
    Print("    TERMINAL_SCREEN_WIDTH = ",TerminalInfoInteger(TERMINAL_SCREEN_WIDTH)); 
    Print("    TERMINAL_SCREEN_HEIGHT = ",TerminalInfoInteger(TERMINAL_SCREEN_HEIGHT)); 
    Print("");
    
    Print("**** INFORMAÇÕES SOBRE A CONTA DA CORRETORA ****");
    
    Print("    ACCOUNT_NAME = ",AccountInfoString(ACCOUNT_NAME)); 
    Print("    ACCOUNT_SERVER = ",AccountInfoString(ACCOUNT_SERVER)); 
    Print("    ACCOUNT_CURRENCY = ",AccountInfoString(ACCOUNT_CURRENCY)); 
    Print("    ACCOUNT_COMPANY = ",AccountInfoString(ACCOUNT_COMPANY)); 

    Print("    ACCOUNT_TRADE_ALLOWED = ",AccountInfoBool(ACCOUNT_TRADE_ALLOWED)); 
    Print("    ACCOUNT_TRADE_EXPERT = ",AccountInfoBool(ACCOUNT_TRADE_EXPERT)); 
    Print("    ACCOUNT_FIFO_CLOSE = ",AccountInfoBool(ACCOUNT_FIFO_CLOSE)); 

    Print("    ACCOUNT_LOGIN = ",AccountInfoInteger(ACCOUNT_LOGIN)); 
    Print("    ACCOUNT_LEVERAGE = ",AccountInfoInteger(ACCOUNT_LEVERAGE)); 
    Print("    ACCOUNT_LIMIT_ORDERS = ",AccountInfoInteger(ACCOUNT_LIMIT_ORDERS)); 
    Print("    ACCOUNT_CURRENCY_DIGITS = ",AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS)); 

    Print("    ACCOUNT_BALANCE = ",AccountInfoDouble(ACCOUNT_BALANCE)); 
    Print("    ACCOUNT_CREDIT = ",AccountInfoDouble(ACCOUNT_CREDIT)); 
    Print("    ACCOUNT_PROFIT = ",AccountInfoDouble(ACCOUNT_PROFIT)); 
    Print("    ACCOUNT_EQUITY = ",AccountInfoDouble(ACCOUNT_EQUITY)); 
    Print("    ACCOUNT_MARGIN = ",AccountInfoDouble(ACCOUNT_MARGIN)); 
    Print("    ACCOUNT_MARGIN_FREE = ",AccountInfoDouble(ACCOUNT_MARGIN_FREE)); 
    Print("    ACCOUNT_MARGIN_LEVEL = ",AccountInfoDouble(ACCOUNT_MARGIN_LEVEL)); 
    Print("    ACCOUNT_MARGIN_SO_CALL = ",AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL)); 
    Print("    ACCOUNT_MARGIN_SO_SO = ",AccountInfoDouble(ACCOUNT_MARGIN_SO_SO)); 
    Print("    ACCOUNT_MARGIN_INITIAL = ",AccountInfoDouble(ACCOUNT_MARGIN_INITIAL)); 
    Print("    ACCOUNT_MARGIN_MAINTENANCE = ",AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE)); 
    Print("    ACCOUNT_ASSETS = ",AccountInfoDouble(ACCOUNT_ASSETS)); 
    Print("    ACCOUNT_LIABILITIES = ",AccountInfoDouble(ACCOUNT_LIABILITIES)); 
    Print("    ACCOUNT_COMMISSION_BLOCKED = ",AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED)); 
    
    info = "";
    switch ((int) AccountInfoInteger(ACCOUNT_TRADE_MODE)) {
       case ACCOUNT_TRADE_MODE_DEMO : info = "ACCOUNT_TRADE_MODE_DEMO"; break;
       case ACCOUNT_TRADE_MODE_CONTEST : info = "ACCOUNT_TRADE_MODE_CONTEST"; break;
       case ACCOUNT_TRADE_MODE_REAL : info = "ACCOUNT_TRADE_MODE_REAL"; break;
    }
    Print("    ACCOUNT_TRADE_MODE = ",info); 
    
    info = "";
    switch ((int) AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE)) {
       case ACCOUNT_STOPOUT_MODE_PERCENT : info = "ACCOUNT_STOPOUT_MODE_PERCENT"; break;
       case ACCOUNT_STOPOUT_MODE_MONEY : info = "ACCOUNT_STOPOUT_MODE_MONEY"; break;
    }
    Print("    ACCOUNT_MARGIN_SO_MODE = ",info); 
    
    info = "";
    switch ((int) AccountInfoInteger(ACCOUNT_MARGIN_MODE)) {
       case ACCOUNT_MARGIN_MODE_RETAIL_NETTING : info = "ACCOUNT_MARGIN_MODE_RETAIL_NETTING"; break;
       case ACCOUNT_MARGIN_MODE_EXCHANGE : info = "ACCOUNT_MARGIN_MODE_EXCHANGE"; break;
       case ACCOUNT_MARGIN_MODE_RETAIL_HEDGING : info = "ACCOUNT_MARGIN_MODE_RETAIL_HEDGING"; break;
    }
    Print("    ACCOUNT_MARGIN_MODE = ",info); 
    Print("");

    Print("**** INFORMAÇÕES SOBRE O ATIVO/SÍMBOLO CORRENTE ****");

    Print("    SYMBOL = ",_Symbol); 
    Print("    SYMBOL_CUSTOM = ",SymbolInfoBool(_Symbol,SYMBOL_CUSTOM)); 
    Print("    SYMBOL_EXIST = ",SymbolInfoBool(_Symbol,SYMBOL_EXIST)); 
    Print("    SYMBOL_SELECT = ",SymbolInfoBool(_Symbol,SYMBOL_SELECT)); 
    Print("    SYMBOL_VISIBLE = ",SymbolInfoBool(_Symbol,SYMBOL_VISIBLE)); 
    Print("    SYMBOL_SPREAD_FLOAT = ",SymbolInfoBool(_Symbol,SYMBOL_SPREAD_FLOAT)); 
    Print("    SYMBOL_MARGIN_HEDGED_USE_LEG = ",SymbolInfoBool(_Symbol,SYMBOL_MARGIN_HEDGED_USE_LEG)); 

    Print("    SYMBOL_SESSION_DEALS = ",SymbolInfoInteger(_Symbol,SYMBOL_SESSION_DEALS)); 
    Print("    SYMBOL_SESSION_BUY_ORDERS = ",SymbolInfoInteger(_Symbol,SYMBOL_SESSION_BUY_ORDERS)); 
    Print("    SYMBOL_SESSION_SELL_ORDERS = ",SymbolInfoInteger(_Symbol,SYMBOL_SESSION_SELL_ORDERS)); 
    Print("    SYMBOL_VOLUME = ",SymbolInfoInteger(_Symbol,SYMBOL_VOLUME)); 
    Print("    SYMBOL_VOLUMEHIGH = ",SymbolInfoInteger(_Symbol,SYMBOL_VOLUMEHIGH)); 
    Print("    SYMBOL_VOLUMELOW = ",SymbolInfoInteger(_Symbol,SYMBOL_VOLUMELOW)); 
    Print("    SYMBOL_TIME = ",(datetime) SymbolInfoInteger(_Symbol,SYMBOL_TIME)); 
    Print("    SYMBOL_DIGITS = ",SymbolInfoInteger(_Symbol,SYMBOL_DIGITS)); 
    Print("    SYMBOL_SPREAD = ",SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)); 
    Print("    SYMBOL_TICKS_BOOKDEPTH = ",SymbolInfoInteger(_Symbol,SYMBOL_TICKS_BOOKDEPTH)); 
    Print("    SYMBOL_START_TIME = ",(datetime) SymbolInfoInteger(_Symbol,SYMBOL_START_TIME)); 
    Print("    SYMBOL_EXPIRATION_TIME = ",(datetime) SymbolInfoInteger(_Symbol,SYMBOL_EXPIRATION_TIME)); 
    Print("    SYMBOL_TRADE_STOPS_LEVEL = ",SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)); 
    Print("    SYMBOL_TRADE_FREEZE_LEVEL = ",SymbolInfoInteger(_Symbol,SYMBOL_TRADE_FREEZE_LEVEL)); 
    Print("    SYMBOL_EXPIRATION_MODE = ",SymbolInfoInteger(_Symbol,SYMBOL_EXPIRATION_MODE)); 
    Print("    SYMBOL_FILLING_MODE = ",SymbolInfoInteger(_Symbol,SYMBOL_FILLING_MODE)); 
    Print("    SYMBOL_ORDER_MODE = ",SymbolInfoInteger(_Symbol,SYMBOL_ORDER_MODE)); 

    Print("    SYMBOL_BID = ",SymbolInfoDouble(_Symbol,SYMBOL_BID)); 
    Print("    SYMBOL_BIDHIGH = ",SymbolInfoDouble(_Symbol,SYMBOL_BIDHIGH)); 
    Print("    SYMBOL_BIDLOW = ",SymbolInfoDouble(_Symbol,SYMBOL_BIDLOW)); 
    Print("    SYMBOL_ASK = ",SymbolInfoDouble(_Symbol,SYMBOL_ASK)); 
    Print("    SYMBOL_ASKHIGH = ",SymbolInfoDouble(_Symbol,SYMBOL_ASKHIGH)); 
    Print("    SYMBOL_ASKLOW = ",SymbolInfoDouble(_Symbol,SYMBOL_ASKLOW)); 
    Print("    SYMBOL_LAST = ",SymbolInfoDouble(_Symbol,SYMBOL_LAST)); 
    Print("    SYMBOL_LASTHIGH = ",SymbolInfoDouble(_Symbol,SYMBOL_LASTHIGH)); 
    Print("    SYMBOL_LASTLOW = ",SymbolInfoDouble(_Symbol,SYMBOL_LASTLOW)); 
    Print("    SYMBOL_VOLUME_REAL = ",SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_REAL)); 
    Print("    SYMBOL_VOLUMEHIGH_REAL = ",SymbolInfoDouble(_Symbol,SYMBOL_VOLUMEHIGH_REAL)); 
    Print("    SYMBOL_VOLUMELOW_REAL = ",SymbolInfoDouble(_Symbol,SYMBOL_VOLUMELOW_REAL)); 
    Print("    SYMBOL_OPTION_STRIKE = ",SymbolInfoDouble(_Symbol,SYMBOL_OPTION_STRIKE)); 
    Print("    SYMBOL_POINT = ",SymbolInfoDouble(_Symbol,SYMBOL_POINT)); 
    Print("    SYMBOL_TRADE_TICK_VALUE = ",SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE)); 
    Print("    SYMBOL_TRADE_TICK_VALUE_PROFIT = ",SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE_PROFIT)); 
    Print("    SYMBOL_TRADE_TICK_VALUE_LOSS = ",SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE_LOSS)); 
    Print("    SYMBOL_TRADE_TICK_SIZE = ",SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE)); 
    Print("    SYMBOL_TRADE_CONTRACT_SIZE = ",SymbolInfoDouble(_Symbol,SYMBOL_TRADE_CONTRACT_SIZE)); 
    Print("    SYMBOL_TRADE_ACCRUED_INTEREST = ",SymbolInfoDouble(_Symbol,SYMBOL_TRADE_ACCRUED_INTEREST)); 
    Print("    SYMBOL_TRADE_FACE_VALUE = ",SymbolInfoDouble(_Symbol,SYMBOL_TRADE_FACE_VALUE)); 
    Print("    SYMBOL_TRADE_LIQUIDITY_RATE = ",SymbolInfoDouble(_Symbol,SYMBOL_TRADE_LIQUIDITY_RATE)); 
    Print("    SYMBOL_VOLUME_MIN = ",SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN)); 
    Print("    SYMBOL_VOLUME_MAX = ",SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX)); 
    Print("    SYMBOL_VOLUME_STEP = ",SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP)); 
    Print("    SYMBOL_VOLUME_LIMIT = ",SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_LIMIT)); 
    Print("    SYMBOL_SWAP_LONG = ",SymbolInfoDouble(_Symbol,SYMBOL_SWAP_LONG)); 
    Print("    SYMBOL_SWAP_SHORT = ",SymbolInfoDouble(_Symbol,SYMBOL_SWAP_SHORT)); 
    Print("    SYMBOL_MARGIN_INITIAL = ",SymbolInfoDouble(_Symbol,SYMBOL_MARGIN_INITIAL)); 
    Print("    SYMBOL_MARGIN_MAINTENANCE = ",SymbolInfoDouble(_Symbol,SYMBOL_MARGIN_MAINTENANCE)); 
    Print("    SYMBOL_SESSION_VOLUME = ",SymbolInfoDouble(_Symbol,SYMBOL_SESSION_VOLUME)); 
    Print("    SYMBOL_SESSION_TURNOVER = ",SymbolInfoDouble(_Symbol,SYMBOL_SESSION_TURNOVER)); 
    Print("    SYMBOL_SESSION_INTEREST = ",SymbolInfoDouble(_Symbol,SYMBOL_SESSION_INTEREST)); 
    Print("    SYMBOL_SESSION_BUY_ORDERS_VOLUME = ",SymbolInfoDouble(_Symbol,SYMBOL_SESSION_BUY_ORDERS_VOLUME)); 
    Print("    SYMBOL_SESSION_SELL_ORDERS_VOLUME = ",SymbolInfoDouble(_Symbol,SYMBOL_SESSION_SELL_ORDERS_VOLUME)); 
    Print("    SYMBOL_SESSION_OPEN = ",SymbolInfoDouble(_Symbol,SYMBOL_SESSION_OPEN)); 
    Print("    SYMBOL_SESSION_CLOSE = ",SymbolInfoDouble(_Symbol,SYMBOL_SESSION_CLOSE)); 
    Print("    SYMBOL_SESSION_AW = ",SymbolInfoDouble(_Symbol,SYMBOL_SESSION_AW)); 
    Print("    SYMBOL_SESSION_PRICE_SETTLEMENT = ",SymbolInfoDouble(_Symbol,SYMBOL_SESSION_PRICE_SETTLEMENT)); 
    Print("    SYMBOL_SESSION_PRICE_LIMIT_MIN = ",SymbolInfoDouble(_Symbol,SYMBOL_SESSION_PRICE_LIMIT_MIN)); 
    Print("    SYMBOL_SESSION_PRICE_LIMIT_MAX = ",SymbolInfoDouble(_Symbol,SYMBOL_SESSION_PRICE_LIMIT_MAX)); 
    Print("    SYMBOL_MARGIN_HEDGED = ",SymbolInfoDouble(_Symbol,SYMBOL_MARGIN_HEDGED)); 
    Print("    SYMBOL_PRICE_CHANGE = ",SymbolInfoDouble(_Symbol,SYMBOL_PRICE_CHANGE)); 
    Print("    SYMBOL_PRICE_VOLATILITY = ",SymbolInfoDouble(_Symbol,SYMBOL_PRICE_VOLATILITY)); 
    Print("    SYMBOL_PRICE_THEORETICAL = ",SymbolInfoDouble(_Symbol,SYMBOL_PRICE_THEORETICAL)); 
    Print("    SYMBOL_PRICE_DELTA = ",SymbolInfoDouble(_Symbol,SYMBOL_PRICE_DELTA)); 
    Print("    SYMBOL_PRICE_THETA = ",SymbolInfoDouble(_Symbol,SYMBOL_PRICE_THETA)); 
    Print("    SYMBOL_PRICE_GAMMA = ",SymbolInfoDouble(_Symbol,SYMBOL_PRICE_GAMMA)); 
    Print("    SYMBOL_PRICE_VEGA = ",SymbolInfoDouble(_Symbol,SYMBOL_PRICE_VEGA)); 
    Print("    SYMBOL_PRICE_RHO = ",SymbolInfoDouble(_Symbol,SYMBOL_PRICE_RHO)); 
    Print("    SYMBOL_PRICE_OMEGA = ",SymbolInfoDouble(_Symbol,SYMBOL_PRICE_OMEGA)); 
    Print("    SYMBOL_PRICE_SENSITIVITY = ",SymbolInfoDouble(_Symbol,SYMBOL_PRICE_SENSITIVITY)); 

    Print("    SYMBOL_BASIS = ",SymbolInfoString(_Symbol,SYMBOL_BASIS)); 
    Print("    SYMBOL_CATEGORY = ",SymbolInfoString(_Symbol,SYMBOL_CATEGORY)); 
    Print("    SYMBOL_CURRENCY_BASE = ",SymbolInfoString(_Symbol,SYMBOL_CURRENCY_BASE)); 
    Print("    SYMBOL_CURRENCY_PROFIT = ",SymbolInfoString(_Symbol,SYMBOL_CURRENCY_PROFIT)); 
    Print("    SYMBOL_CURRENCY_MARGIN = ",SymbolInfoString(_Symbol,SYMBOL_CURRENCY_MARGIN)); 
    Print("    SYMBOL_BANK = ",SymbolInfoString(_Symbol,SYMBOL_BANK)); 
    Print("    SYMBOL_DESCRIPTION = ",SymbolInfoString(_Symbol,SYMBOL_DESCRIPTION)); 
    Print("    SYMBOL_EXCHANGE = ",SymbolInfoString(_Symbol,SYMBOL_EXCHANGE)); 
    Print("    SYMBOL_FORMULA = ",SymbolInfoString(_Symbol,SYMBOL_FORMULA)); 
    Print("    SYMBOL_ISIN = ",SymbolInfoString(_Symbol,SYMBOL_ISIN)); 
    Print("    SYMBOL_PAGE = ",SymbolInfoString(_Symbol,SYMBOL_PAGE)); 
    Print("    SYMBOL_PATH = ",SymbolInfoString(_Symbol,SYMBOL_PATH)); 

    info = "";
    switch ((int) SymbolInfoInteger(_Symbol, SYMBOL_CHART_MODE)) {
       case SYMBOL_CHART_MODE_BID : info = "SYMBOL_CHART_MODE_BID"; break;
       case SYMBOL_CHART_MODE_LAST : info = "SYMBOL_CHART_MODE_LAST"; break;
    }
    Print("    SYMBOL_CHART_MODE = ",info); 

    info = "";
    switch ((int) SymbolInfoInteger(_Symbol, SYMBOL_TRADE_CALC_MODE)) {
       case SYMBOL_CALC_MODE_FOREX : info = "SYMBOL_CALC_MODE_FOREX"; break;
       case SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE : info = "SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE"; break;
       case SYMBOL_CALC_MODE_FUTURES : info = "SYMBOL_CALC_MODE_FUTURES"; break;
       case SYMBOL_CALC_MODE_CFD : info = "SYMBOL_CALC_MODE_CFD"; break;
       case SYMBOL_CALC_MODE_CFDINDEX : info = "SYMBOL_CALC_MODE_CFDINDEX"; break;
       case SYMBOL_CALC_MODE_CFDLEVERAGE : info = "SYMBOL_CALC_MODE_CFDLEVERAGE"; break;
       case SYMBOL_CALC_MODE_EXCH_STOCKS : info = "SYMBOL_CALC_MODE_EXCH_STOCKS"; break;
       case SYMBOL_CALC_MODE_EXCH_FUTURES : info = "SYMBOL_CALC_MODE_EXCH_FUTURES"; break;
       case SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS : info = "SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS"; break;
       case SYMBOL_CALC_MODE_EXCH_BONDS : info = "SYMBOL_CALC_MODE_EXCH_BONDS"; break;
       case SYMBOL_CALC_MODE_EXCH_STOCKS_MOEX : info = "SYMBOL_CALC_MODE_EXCH_STOCKS_MOEX"; break;
       case SYMBOL_CALC_MODE_EXCH_BONDS_MOEX : info = "SYMBOL_CALC_MODE_EXCH_BONDS_MOEX"; break;
       case SYMBOL_CALC_MODE_SERV_COLLATERAL : info = "SYMBOL_CALC_MODE_SERV_COLLATERAL"; break;
    }
    Print("    SYMBOL_TRADE_CALC_MODE = ",info); 

    info = "";
    switch ((int) SymbolInfoInteger(_Symbol, SYMBOL_TRADE_MODE)) {
       case SYMBOL_TRADE_MODE_DISABLED : info = "SYMBOL_TRADE_MODE_DISABLED"; break;
       case SYMBOL_TRADE_MODE_LONGONLY : info = "SYMBOL_TRADE_MODE_LONGONLY"; break;
       case SYMBOL_TRADE_MODE_SHORTONLY : info = "SYMBOL_TRADE_MODE_SHORTONLY"; break;
       case SYMBOL_TRADE_MODE_CLOSEONLY : info = "SYMBOL_TRADE_MODE_CLOSEONLY"; break;
       case SYMBOL_TRADE_MODE_FULL : info = "SYMBOL_TRADE_MODE_FULL"; break;
    }
    Print("    SYMBOL_TRADE_MODE = ",info); 

    info = "";
    switch ((int) SymbolInfoInteger(_Symbol, SYMBOL_TRADE_EXEMODE)) {
       case SYMBOL_TRADE_EXECUTION_REQUEST : info = "SYMBOL_TRADE_EXECUTION_REQUEST"; break;
       case SYMBOL_TRADE_EXECUTION_INSTANT : info = "SYMBOL_TRADE_EXECUTION_INSTANT"; break;
       case SYMBOL_TRADE_EXECUTION_MARKET : info = "SYMBOL_TRADE_EXECUTION_MARKET"; break;
       case SYMBOL_TRADE_EXECUTION_EXCHANGE : info = "SYMBOL_TRADE_EXECUTION_EXCHANGE"; break;
    }
    Print("    SYMBOL_TRADE_EXEMODE = ",info); 

    info = "";
    switch ((int) SymbolInfoInteger(_Symbol, SYMBOL_SWAP_MODE)) {
       case SYMBOL_SWAP_MODE_DISABLED : info = "SYMBOL_SWAP_MODE_DISABLED"; break;
       case SYMBOL_SWAP_MODE_POINTS : info = "SYMBOL_SWAP_MODE_POINTS"; break;
       case SYMBOL_SWAP_MODE_CURRENCY_SYMBOL : info = "SYMBOL_SWAP_MODE_CURRENCY_SYMBOL"; break;
       case SYMBOL_SWAP_MODE_CURRENCY_MARGIN : info = "SYMBOL_SWAP_MODE_CURRENCY_MARGIN"; break;
       case SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT : info = "SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT"; break;
       case SYMBOL_SWAP_MODE_INTEREST_CURRENT : info = "SYMBOL_SWAP_MODE_INTEREST_CURRENT"; break;
       case SYMBOL_SWAP_MODE_INTEREST_OPEN : info = "SYMBOL_SWAP_MODE_INTEREST_OPEN"; break;
       case SYMBOL_SWAP_MODE_REOPEN_CURRENT : info = "SYMBOL_SWAP_MODE_REOPEN_CURRENT"; break;
       case SYMBOL_SWAP_MODE_REOPEN_BID : info = "SYMBOL_SWAP_MODE_REOPEN_BID"; break;
    }
    Print("    SYMBOL_SWAP_MODE = ",info); 

    info = "";
    switch ((int) SymbolInfoInteger(_Symbol, SYMBOL_SWAP_ROLLOVER3DAYS)) {
       case SUNDAY : info = "SUNDAY"; break;
       case MONDAY : info = "MONDAY"; break;
       case TUESDAY : info = "TUESDAY"; break;
       case WEDNESDAY : info = "WEDNESDAY"; break;
       case THURSDAY : info = "THURSDAY"; break;
       case FRIDAY : info = "FRIDAY"; break;
       case SATURDAY : info = "SATURDAY"; break;
    }
    Print("    SYMBOL_SWAP_ROLLOVER3DAYS = ",info); 

    info = "";
    switch ((int) SymbolInfoInteger(_Symbol, SYMBOL_ORDER_GTC_MODE)) {
       case SYMBOL_ORDERS_GTC : info = "SYMBOL_ORDERS_GTC"; break;
       case SYMBOL_ORDERS_DAILY : info = "SYMBOL_ORDERS_DAILY"; break;
       case SYMBOL_ORDERS_DAILY_EXCLUDING_STOPS : info = "SYMBOL_ORDERS_DAILY_EXCLUDING_STOPS"; break;
    }
    Print("    SYMBOL_ORDER_GTC_MODE = ",info); 

    info = "";
    switch ((int) SymbolInfoInteger(_Symbol, SYMBOL_OPTION_MODE)) {
       case SYMBOL_OPTION_MODE_EUROPEAN : info = "SYMBOL_OPTION_MODE_EUROPEAN"; break;
       case SYMBOL_OPTION_MODE_AMERICAN : info = "SYMBOL_OPTION_MODE_AMERICAN"; break;
    }
    Print("    SYMBOL_OPTION_MODE = ",info); 

    info = "";
    switch ((int) SymbolInfoInteger(_Symbol, SYMBOL_OPTION_RIGHT)) {
       case SYMBOL_OPTION_RIGHT_CALL : info = "SYMBOL_OPTION_RIGHT_CALL"; break;
       case SYMBOL_OPTION_RIGHT_PUT : info = "SYMBOL_OPTION_RIGHT_PUT"; break;
    }
    Print("    SYMBOL_OPTION_RIGHT = ",info); 
    Print("");
    
    //---
    return(INIT_SUCCEEDED);
}
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {}

//+------------------------------------------------------------------+
