//+------------------------------------------------------------------+
//|                                                      WinTime.mqh |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property library
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
//| Converte uma estrutura SYSTEMTIME para o tipo date sem hora.     |
//+------------------------------------------------------------------+
datetime GetDate(SYSTEMTIME &systemTime) {
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    
    return StructToTime(dt_struct);
}

datetime GetDate() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    
    return StructToTime(dt_struct);
}

//+------------------------------------------------------------------+
//| Retorna a data atual, sem a parte de horas (hor,min,seg).        |
//+------------------------------------------------------------------+
datetime GetHoje() {
   MqlDateTime dt_struct = {0};

   TimeLocal(dt_struct);
   dt_struct.hour = 0;
   dt_struct.min = 0;
   dt_struct.sec = 0;

   return StructToTime(dt_struct);
}

//+------------------------------------------------------------------+
//| Converte uma estrutura SYSTEMTIME para o tipo interno datetime.  |
//+------------------------------------------------------------------+
datetime GetDatetime(SYSTEMTIME &systemTime) {
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    dt_struct.hour = (int) systemTime.wHour;
    dt_struct.min = (int) systemTime.wMinute;
    dt_struct.sec = (int) systemTime.wSecond;
    
    return StructToTime(dt_struct);
}

datetime GetDatetime() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    dt_struct.hour = (int) systemTime.wHour;
    dt_struct.min = (int) systemTime.wMinute;
    dt_struct.sec = (int) systemTime.wSecond;
    
    return StructToTime(dt_struct);
}

//+------------------------------------------------------------------+
//| Converte apenas a parte de hora para milisegundos.               |
//+------------------------------------------------------------------+
long GetMillisecondsDate(SYSTEMTIME &systemTime) {
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    
    return ((long) StructToTime(dt_struct)) * 1000;  // deconsidera os milissegundos
}

long GetMillisecondsDate() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    
    return ((long) StructToTime(dt_struct)) * 1000;  // deconsidera os milissegundos
}

//+------------------------------------------------------------------+
//| Converte apenas a parte de hora para milisegundos.               |
//+------------------------------------------------------------------+
int GetMillisecondsTime(SYSTEMTIME &systemTime) {
    return (int) ((((((systemTime.wHour * 60)   // em minutos
                 + systemTime.wMinute) * 60)    // em segundos
                 + systemTime.wSecond) * 1000)  // em milissegundos
                 + systemTime.wMilliseconds);
}

int GetMillisecondsTime() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    return (int) ((((((systemTime.wHour * 60)   // em minutos
                 + systemTime.wMinute) * 60)    // em segundos
                 + systemTime.wSecond) * 1000)  // em milissegundos
                 + systemTime.wMilliseconds);
}

//+------------------------------------------------------------------+
//| Converte um valor data-hora do sistema para milisegundos.        |
//+------------------------------------------------------------------+
long GetMillisecondsDatetime(SYSTEMTIME &systemTime) {
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    dt_struct.hour = (int) systemTime.wHour;
    dt_struct.min = (int) systemTime.wMinute;
    dt_struct.sec = (int) systemTime.wSecond;
    
    return (((long) StructToTime(dt_struct)) * 1000) + systemTime.wMilliseconds;
}

long GetMillisecondsDatetime() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    dt_struct.hour = (int) systemTime.wHour;
    dt_struct.min = (int) systemTime.wMinute;
    dt_struct.sec = (int) systemTime.wSecond;

    return (((long) StructToTime(dt_struct)) * 1000) + systemTime.wMilliseconds;
}

//+------------------------------------------------------------------+
//| Converte um valor data-hora do sistema para string formatada.    |
//+------------------------------------------------------------------+
string SystemTimeToString(SYSTEMTIME &systemTime) {
    return StringFormat("%04d.%02d.%02d %02d:%02d:%02d.%03d",
                        systemTime.wYear,systemTime.wMonth,systemTime.wDay,
                        systemTime.wHour,systemTime.wMinute,systemTime.wSecond,systemTime.wMilliseconds);
}

string SystemTimeToString() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    return StringFormat("%04d.%02d.%02d %02d:%02d:%02d.%03d",
                        systemTime.wYear,systemTime.wMonth,systemTime.wDay,
                        systemTime.wHour,systemTime.wMinute,systemTime.wSecond,systemTime.wMilliseconds);
}

//+------------------------------------------------------------------+
//| Constantes exports                                               |
//+------------------------------------------------------------------+
const long HOJE_MILISSEGUNDOS = GetMillisecondsDate();

//+------------------------------------------------------------------+
