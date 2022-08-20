/*
===============================================================================

 package: MQL5\Include\_ALARA

 module : WinAPI_Time.mqh
 
===============================================================================
*/
#property copyright   "Copyright 2021, ALARA Investimentos"
#property link        "http://www.alara.com.br"
#property version     "1.00"
#property description ""
#property description ""

#property library

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
ulong GetMillisecondsDate(SYSTEMTIME &systemTime) {
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    
    return ((ulong) StructToTime(dt_struct)) * 1000;  // deconsidera os milissegundos
}

ulong GetMillisecondsDate() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    
    return ((ulong) StructToTime(dt_struct)) * 1000;  // deconsidera os milissegundos
}

//+------------------------------------------------------------------+
//| Converte apenas a parte de hora para milisegundos.               |
//+------------------------------------------------------------------+
uint GetMillisecondsTime(SYSTEMTIME &systemTime) {
    return (uint) ((((((systemTime.wHour * 60)   // em minutos
                  + systemTime.wMinute) * 60)    // em segundos
                  + systemTime.wSecond) * 1000)  // em milissegundos
                  + systemTime.wMilliseconds);
}

uint GetMillisecondsTime() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    return (uint) ((((((systemTime.wHour * 60)   // em minutos
                  + systemTime.wMinute) * 60)    // em segundos
                  + systemTime.wSecond) * 1000)  // em milissegundos
                  + systemTime.wMilliseconds);
}

//+------------------------------------------------------------------+
//| Converte um valor data-hora do sistema para milisegundos.        |
//+------------------------------------------------------------------+
ulong GetMillisecondsDatetime(SYSTEMTIME &systemTime) {
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    dt_struct.hour = (int) systemTime.wHour;
    dt_struct.min = (int) systemTime.wMinute;
    dt_struct.sec = (int) systemTime.wSecond;
    
    return (((ulong) StructToTime(dt_struct)) * 1000) + systemTime.wMilliseconds;
}

ulong GetMillisecondsDatetime() {
    SYSTEMTIME systemTime;
    GetLocalTime(systemTime);
    
    MqlDateTime dt_struct = {0};
    dt_struct.year = (int) systemTime.wYear;
    dt_struct.mon = (int) systemTime.wMonth;
    dt_struct.day = (int) systemTime.wDay;
    dt_struct.hour = (int) systemTime.wHour;
    dt_struct.min = (int) systemTime.wMinute;
    dt_struct.sec = (int) systemTime.wSecond;

    return (((ulong) StructToTime(dt_struct)) * 1000) + systemTime.wMilliseconds;
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
const ulong HOJE_MILISSEGUNDOS = GetMillisecondsDate();

const uint DIA_INC = 24 * 60 * 60;  // unidade para adicionar 1 dia a uma data.

const uint DIA_END = (24 * 60 * 60) - 1;  // unidade para adicionar 23:59:59 a uma data.

//+------------------------------------------------------------------+
//| Compoe uma data em milisegundos utilizando o horario fornecido.  |
//+------------------------------------------------------------------+
ulong addTimeToHoje(uint localTime) {
    return HOJE_MILISSEGUNDOS + localTime;
}

void incMonth(MqlDateTime &dt_struct) {
//--- Para incrementar, apenas tem que verificar se esta prestes a virar o ano:
    if (dt_struct.mon == 12) {  // pula para o proximo ano:
        dt_struct.mon = 1;
        dt_struct.year = dt_struct.year + 1;
    } else {  // apenas avanca para o proximo mes:
        dt_struct.mon = dt_struct.mon + 1;
    }
}

//+------------------------------------------------------------------+
//| Calculos de periodos de datas, do primeiro ao ultimo dia do mes. |
//+------------------------------------------------------------------+
void PeriodPreviousMonth(datetime &firstDay, datetime &lastDay) {
//--- Obtem a data atual utilizando estrutura para navegar para o mes anterior:
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);

//--- A partir do primeiro dia do mes atual, navega para o ultimo dia do mes anterior:
    dt_struct.day = 1;
    dt_struct.hour = 23;
    dt_struct.min = 59;
    dt_struct.sec = 59;
    lastDay = StructToTime(dt_struct) - DIA_INC;

//--- A partir do primeiro dia do mes atual, navega para o ultimo dia do mes anterior:
    TimeToStruct(lastDay, dt_struct);
    dt_struct.day = 1;
    dt_struct.hour = 0;
    dt_struct.min = 0;
    dt_struct.sec = 0;
    firstDay = StructToTime(dt_struct);
}

void PeriodCurrentMonth(datetime &firstDay, datetime &lastDay) {
//--- Obtem a data atual utilizando estrutura para obter o periodo do mes corrente:
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);

//--- Para o primeiro dia, basta ajustar o dia da estrutura:
    dt_struct.day = 1;  // primeiro dia do mes, inicio do periodo
    dt_struct.hour = 0;
    dt_struct.min = 0;
    dt_struct.sec = 0;
    firstDay = StructToTime(dt_struct);

//--- Avanca para o mes seguinte e retrocede apenas um dia:
    incMonth(dt_struct);  // Incrementa o mes, cuidado se estiver no final do ano
    dt_struct.hour = 23;
    dt_struct.min = 59;
    dt_struct.sec = 59;
    lastDay = StructToTime(dt_struct) - DIA_INC;
}

void PeriodNextMonth(datetime &firstDay, datetime &lastDay) {
//--- Obtem a data atual utilizando estrutura para navegar para o proximo mes:
    MqlDateTime dt_struct = {0};
    TimeLocal(dt_struct);

//--- Pula para o proximo mes e obtem o inicio do periodo:
    incMonth(dt_struct);  // Incrementa o mes, cuidado se estiver no final do ano
    dt_struct.day = 1;  // primeiro dia do mes, inicio do periodo
    dt_struct.hour = 0;
    dt_struct.min = 0;
    dt_struct.sec = 0;
    firstDay = StructToTime(dt_struct);

//--- Avanca para o mes seguinte e retrocede apenas um dia:
    incMonth(dt_struct);  // Incrementa o mes, cuidado se estiver no final do ano
    dt_struct.hour = 23;
    dt_struct.min = 59;
    dt_struct.sec = 59;
    lastDay = StructToTime(dt_struct) - DIA_INC;
}


//+------------------------------------------------------------------+
