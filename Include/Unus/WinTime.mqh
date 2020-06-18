//+------------------------------------------------------------------+
//|                                                      WinTime.mqh |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
//#property copyright "Copyright 2020, ALARA Investimentos"
//#property link      "http://www.alara.com.br"
//#property version   "1.00"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
#define WORD ushort

struct SYSTEMTIME {
    WORD wYear;
    WORD wMonth;
    WORD wDayOfWeek;
    WORD wDay;
    WORD wHour;
    WORD wMinute;
    WORD wSecond;
    WORD wMilliseconds;
};

//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
#import "kernel32.dll"
    void GetSystemTime(SYSTEMTIME &system_time);
    void GetLocalTime(SYSTEMTIME &system_time);
#import

//+------------------------------------------------------------------+
//| Functions exports                                                |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Converte apenas a parte de hora para milisegundos.               |
//+------------------------------------------------------------------+
int GetMillisecondsHour() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    return GetMillisecondsHour(systemTime);
}

int GetMillisecondsHour(SYSTEMTIME &systemTime) {
    return (int) ((((systemTime.wHour * 60) + systemTime.wMinute) * 60) + systemTime.wSecond) * 1000 // em milissegundos
           + systemTime.wMilliseconds;
}

//+------------------------------------------------------------------+
//| Converte uma estrutura SYSTEMTIME para o tipo interno datetime.  |
//+------------------------------------------------------------------+
datetime GetDatetime() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    return GetDatetime(systemTime);
}

datetime GetDatetime(SYSTEMTIME &systemTime) {
    MqlDateTime dt_struct;
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    dt_struct.hour = (int) systemTime.wHour;
    dt_struct.min = (int) systemTime.wMinute;
    dt_struct.sec = (int) systemTime.wSecond;
    //dt_struct.day_of_week = (int) systemTime.wDayOfWeek;
    //dt_struct.day_of_year = ?
    
    return StructToTime(dt_struct);
}

//+------------------------------------------------------------------+
//| Converte um valor data-hora do sistema para milisegundos.        |
//+------------------------------------------------------------------+
long GetMillisecondsTime() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    return GetMillisecondsTime(systemTime);
}

long GetMillisecondsTime(SYSTEMTIME &systemTime) {
    long dtSeconds = (long) GetDatetime(systemTime);
    
    return (dtSeconds * 1000) + systemTime.wMilliseconds;
}

//+------------------------------------------------------------------+
//| Converte um valor data-hora do sistema para string formatada.    |
//+------------------------------------------------------------------+
string SystemTimeToString() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    return SystemTimeToString(systemTime);
}

string SystemTimeToString(SYSTEMTIME &systemTime) {
    return StringFormat("%04d.%02d.%02d %02d:%02d:%02d.%03d",
                        systemTime.wYear,systemTime.wMonth,systemTime.wDay,
                        systemTime.wHour,systemTime.wMinute,systemTime.wSecond,systemTime.wMilliseconds);
}

//+------------------------------------------------------------------+
