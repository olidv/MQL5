/*
===============================================================================

 package: MQL5\Experts\ALARA\COMMON

 module : EA_CSV_WriteCalendar.mq5

===============================================================================
*/
#property copyright   "Copyright 2021, ALARA Investimentos"
#property link        "http://www.alara.com.br"
#property version     "1.00"
#property description ""
#property description ""


//+------------------------------------------------------------------+
//--- Funcoes para obtencao da hora a partir da Windows API
#include <ALARA\WinAPI_Time.mqh>


//+------------------------------------------------------------------+
//---
#define EA_TIMER_SECONDS  10     // timer em segundos

//---
const string FILE_CALENDAR_BIN = "MT5_Calendar.bin";
const string FILE_CALENDAR_CSV = "_Calendar.csv";


//+------------------------------------------------------------------+
//--- Em 2022-08-16 o calendario possuia 23 paises...
//--- Em 2022-08-16 o pais US posuia 246 eventos...

//---
enum ENUM_CALENDAR_RECORD
   {
    CALENDAR_LOADED_VALUE              = 0,
    CALENDAR_INSERT_VALUE              = 1,
    CALENDAR_UPDATE_TIME               = 2,
    CALENDAR_UPDATE_ACTUAL_VALUE       = 4,
    CALENDAR_UPDATE_PREV_VALUE         = 8,
    CALENDAR_UPDATE_REVISED_PREV_VALUE = 16,
    CALENDAR_UPDATE_FORECAST_VALUE     = 32,
    CALENDAR_UPDATE_IMPACT_TYPE        = 64
   };


//--- Estruturas para armazenar eventos de calendario:
struct SEconomicCalendar  // sem valores string para manter como Estrutura Simples...
   {
    ulong                               event_id;              // identificador de evento
    ulong                               country_id;            // identificador do país pelo padrão ISO 3166-1
    ENUM_CALENDAR_EVENT_TYPE            type;                  // tipo de evento da enumeração ENUM_CALENDAR_EVENT_TYPE
    ENUM_CALENDAR_EVENT_TIMEMODE        time_mode;             // modo de hora do evento
    ENUM_CALENDAR_EVENT_SECTOR          sector;                // setor ao qual está relacionado o evento
    ENUM_CALENDAR_EVENT_FREQUENCY       frequency;             // frequência do evento
    ENUM_CALENDAR_EVENT_IMPORTANCE      importance;            // importância do evento
    ENUM_CALENDAR_EVENT_UNIT            unit;                  // unidade de medida da leitura do calendário econômico
    ENUM_CALENDAR_EVENT_MULTIPLIER      multiplier;            // multiplicador da leitura do calendário econômico
    uint                                digits;                // número de casas decimais

    ulong                               value_id;              // ID do valor
    datetime                            time;                  // hora e data do evento
    datetime                            period;                // período de relatório do evento
    int                                 revision;              // revisão do indicador publicado em relação ao período de relatório
    long                                actual_value;          // valor real em ppm ou LONG_MIN se nenhum valor for especificado
    long                                prev_value;            // valor anterior em ppm ou LONG_MIN se não estiver definido
    long                                revised_prev_value;    // valor anterior revisado em ppm ou LONG_MIN se não estiver definido
    long                                forecast_value;        // valor previsto em ppm ou LONG_MIN se não estiver definido
    ENUM_CALENDAR_EVENT_IMPACT          impact_type;           // impacto potencial na taxa de câmbio

    int                                 record_type;           // informa o tipo de atualizacao aplicada ao valor do evento
   };


//---
SEconomicCalendar st_calendar[];
int size_calendar = 0;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
    ulong start = GetMicrosecondCount();

//--- Inicializa a estrutura com o calendario economico para servir de referencia:
    if(! ReloadCalendar(st_calendar, size_calendar))
       {
        return(INIT_FAILED);
       }

//--- Cria timer, para disparo a cada 5 segundos:
    if(! EventSetTimer(EA_TIMER_SECONDS))
        return(INIT_FAILED);

    Print("------------------------------------------------------------------------");
    Print("OnInit() MicrosecondCount = ", GetMicrosecondCount() - start);
    Print("------------------------------------------------------------------------");

//--- Inicializacao do robo efetuada com sucesso.
    return (INIT_SUCCEEDED);
   }


//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
   {
    ulong start = GetMicrosecondCount();

//--- Obtem novo array de valores dos eventos de hoje para o futuro:
    MqlCalendarValue values[];
    int sizeNewCalendar = getCalendarValues(values);
    if(sizeNewCalendar == NULL)
        return;
    PrintFormat("OnTimer: Foram carregados %d eventos do historico do calendario.", sizeNewCalendar);

//--- Percorre o array de valores para preencher os respectivos evento e pais:
    SEconomicCalendar newCalendar[];
    ArrayResize(newCalendar, sizeNewCalendar);
    for(int i=0; i < sizeNewCalendar; i++)
       {
        // registra os dados dos valores do evento:
        newCalendar[i].value_id = values[i].id;
        newCalendar[i].event_id = values[i].event_id;
        newCalendar[i].time = values[i].time;
        newCalendar[i].period = values[i].period;
        newCalendar[i].revision = values[i].revision;
        newCalendar[i].actual_value = values[i].actual_value;
        newCalendar[i].prev_value = values[i].prev_value;
        newCalendar[i].revised_prev_value = values[i].revised_prev_value;
        newCalendar[i].forecast_value = values[i].forecast_value;
        newCalendar[i].impact_type = values[i].impact_type;

        //
        setEventAndCountry(newCalendar[i]);

        // pesquisa no calendario anterior se o valor existe e foi alterado:
        newCalendar[i].record_type = CALENDAR_LOADED_VALUE;
        bool achou = false;
        for(int j=0; j < size_calendar; j++)
           {
            //--- compara o calendario anterior com os novos valores:
            if(newCalendar[i].value_id == st_calendar[j].value_id)
               {
                achou = true;
                // verifica se algum valor do evento foi modificado:
                if(newCalendar[i].time != st_calendar[j].time)
                    newCalendar[i].record_type |= CALENDAR_UPDATE_TIME;

                if(newCalendar[i].actual_value != st_calendar[j].actual_value)
                    newCalendar[i].record_type |= CALENDAR_UPDATE_ACTUAL_VALUE;

                if(newCalendar[i].prev_value != st_calendar[j].prev_value)
                    newCalendar[i].record_type |= CALENDAR_UPDATE_PREV_VALUE;

                if(newCalendar[i].revised_prev_value != st_calendar[j].revised_prev_value)
                    newCalendar[i].record_type |= CALENDAR_UPDATE_REVISED_PREV_VALUE;

                if(newCalendar[i].forecast_value != st_calendar[j].forecast_value)
                    newCalendar[i].record_type |= CALENDAR_UPDATE_FORECAST_VALUE;

                if(newCalendar[i].impact_type != st_calendar[j].impact_type)
                    newCalendar[i].record_type |= CALENDAR_UPDATE_IMPACT_TYPE;

                if(newCalendar[i].record_type != CALENDAR_LOADED_VALUE)
                    PrintFormat("OnTimer: Evento alterado. Valor de record_type = %d.", newCalendar[i].record_type);
               }
           }
        // se nao achou o valor, entao eh um novo registro de evento/valor:
        if(! achou)
           {
            newCalendar[i].record_type = CALENDAR_INSERT_VALUE;
           }
       }

//--- repassa o novo calendario para a referencia principal:
    ZeroMemory(st_calendar);
    ArrayCopy(st_calendar, newCalendar);
    size_calendar = sizeNewCalendar;
    PrintFormat("OnTimer: Novo calendario carregado com %d eventos.", size_calendar);

// se a comparacao foi feita com sucesso, salva as alteracoes:
    WriteUpdates(st_calendar, size_calendar);

    Print("------------------------------------------------------------------------");
    Print("OnTimer() MicrosecondCount = ", GetMicrosecondCount() - start);
    Print("------------------------------------------------------------------------");
   }


//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
//--- Imediatamente cancela timer para nao ser mais disparado.
    EventKillTimer();

//--- ao final, salva o calendario para a proxima execucao:
    WriteCalendar(st_calendar, size_calendar);
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getCalendarValues(MqlCalendarValue &values[])
   {
    datetime dtHoje = GetDate();

//--- Obtem novo array de valores dos eventos de hoje para o futuro:
    ResetLastError();
    int count = CalendarValueHistory(values, dtHoje);
    if(count <= 0)   // Se nao encontrou valores dos eventos, entao pula fora:
       {
        PrintFormat("ERRO: CalendarValueHistory(%s) retornou 0! LastError = %d.", TimeToString(dtHoje,TIME_DATE), GetLastError());
        return NULL;
       }

    return count;
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool setEventAndCountry(SEconomicCalendar &struct_calendar)
   {
//---
    MqlCalendarEvent event;
    ResetLastError();
    if(! CalendarEventById(struct_calendar.event_id, event))
       {
        PrintFormat("ERRO: CalendarEventById(%d) retornou FALSE! LastError = %d.", struct_calendar.event_id, GetLastError());
        return false;
       }

//---
    struct_calendar.country_id = event.country_id;
    struct_calendar.type = event.type;
    struct_calendar.time_mode = event.time_mode;
    struct_calendar.sector = event.sector;
    struct_calendar.frequency = event.frequency;
    struct_calendar.importance = event.importance;
    struct_calendar.unit = event.unit;
    struct_calendar.multiplier = event.multiplier;
    struct_calendar.digits = event.digits;

    return true;
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ReadCalendar(SEconomicCalendar &array_calendar[], int &array_size)
   {
//--- verifica se o arquivo ja existe:
    if(! FileIsExist(FILE_CALENDAR_BIN, FILE_COMMON))
       {
        return false;
       }

//--- efetua abertura do arquivo para leitura apenas:
    ResetLastError();
    int hndBinFile = FileOpen(FILE_CALENDAR_BIN, FILE_READ|FILE_BIN|FILE_COMMON);
    if(hndBinFile == INVALID_HANDLE)
       {
        PrintFormat("ERRO: Operação 'FileOpen(%s)' falhou! LastError = %d", FILE_CALENDAR_BIN, GetLastError());
        return false;
       }

//--- percorre o arquivo do calendar e relaciona (array) os registros lidos:
    int i = 0, size = 1000;
    ZeroMemory(array_calendar);
    ArrayResize(array_calendar, size);

    FileSeek(hndBinFile, 0, SEEK_SET);
    while(!FileIsEnding(hndBinFile) && !IsStopped())
       {
        if(i == size)
           {
            size += 1000;
            ArrayResize(array_calendar, size);
           }

        FileReadStruct(hndBinFile, array_calendar[i]);
        ++i;
       }

//---
    array_size = i;
    PrintFormat("ReadCalendar: Foram lidos %d eventos de arquivo BIN.", array_size);

//--- fecha o arquivo e inutiliza handle:
    FileClose(hndBinFile);
    hndBinFile = INVALID_HANDLE;  // invalida o handle do arquivo;

//---
    return true;
   }


//+-------------------------------------------------------------------------------+
//| Inicializa a estrutura com o calendario economico para servir de referencia.  |
//+-------------------------------------------------------------------------------+
bool ReloadCalendar(SEconomicCalendar &array_calendar[], int &array_size)
   {
//--- verifica se o arquivo existe e faz a leitura do calendario anterior:
    if(ReadCalendar(array_calendar, array_size))
       {
        PrintFormat("ReloadCalendar: Carregou %d eventos do arquivo BIN.", array_size);
        return true;
       }

//--- se nao pode ler do arquivo, obtem novo array de valores do calendario de hoje para o futuro:
    MqlCalendarValue values[];
    array_size = getCalendarValues(values);
    if(array_size == NULL)
        return false;

//--- Percorre o array de valores para preencher os respectivos evento e pais:
    ZeroMemory(array_calendar);
    ArrayResize(array_calendar, array_size);
    for(int i=0; i < array_size; i++)
       {
        // registra os dados dos valores do evento:
        array_calendar[i].value_id = values[i].id;
        array_calendar[i].event_id = values[i].event_id;
        array_calendar[i].time = values[i].time;
        array_calendar[i].period = values[i].period;
        array_calendar[i].revision = values[i].revision;
        array_calendar[i].actual_value = values[i].actual_value;
        array_calendar[i].prev_value = values[i].prev_value;
        array_calendar[i].revised_prev_value = values[i].revised_prev_value;
        array_calendar[i].forecast_value = values[i].forecast_value;
        array_calendar[i].impact_type = values[i].impact_type;
        array_calendar[i].record_type = CALENDAR_LOADED_VALUE;

        //
        setEventAndCountry(array_calendar[i]);
       }
    PrintFormat("ReloadCalendar: Carregou %d eventos do calendario.", array_size);

    return true;
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WriteUpdates(SEconomicCalendar &array_calendar[], int &array_size)
   {
    string fileName = TimeToString(GetDate(), TIME_DATE) + FILE_CALENDAR_CSV;
    bool fileExist = FileIsExist(fileName);

    ResetLastError();
    int hndCsvFile = fileExist ? FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                     : FileOpen(fileName, FILE_WRITE|FILE_CSV|FILE_ANSI);
    if(hndCsvFile == INVALID_HANDLE)
       {
        PrintFormat("ERRO: Operação 'FileOpen(%s)' falhou! LastError = %d.", fileName, GetLastError());
       }
    else
        if(fileExist)
           {
            FileSeek(hndCsvFile, 0, SEEK_END);
           }
        else
           {
            FileWrite(hndCsvFile, "RECORD_TYPE", "VALUE_ID", "TIME", "PERIOD", "REVISION", "ACTUAL_VALUE",
                      "PREV_VALUE", "REVISED_PREV_VALUE", "FORECAST_VALUE", "IMPACT_TYPE", "EVENT_ID", "COUNTRY_ID",
                      "TYPE", "TIME_MODE", "SECTOR", "FREQUENCY", "IMPORTANCE", "UNIT", "MULTIPLIER", "DIGITS");
           }

//--- percorre o array do calendar e salva apenas os registros alterados:
    int count = 0;
    for(int i=0; i < array_size; i++)
       {
        // verifica se houve alguma alteracao no registro apos a carga (load):
        if(array_calendar[i].record_type != CALENDAR_LOADED_VALUE)
           {
            ++count;
            FileWrite(hndCsvFile, array_calendar[i].record_type,
                      array_calendar[i].value_id,
                      array_calendar[i].time,
                      array_calendar[i].period,
                      array_calendar[i].revision,
                      array_calendar[i].actual_value,
                      array_calendar[i].prev_value,
                      array_calendar[i].revised_prev_value,
                      array_calendar[i].forecast_value,
                      array_calendar[i].impact_type,
                      array_calendar[i].event_id,
                      array_calendar[i].country_id,
                      array_calendar[i].type,
                      array_calendar[i].time_mode,
                      array_calendar[i].sector,
                      array_calendar[i].frequency,
                      array_calendar[i].importance,
                      array_calendar[i].unit,
                      array_calendar[i].multiplier,
                      array_calendar[i].digits);
           }
       }
    PrintFormat("WriteUpdates: Foram gravados %d eventos alterados em arquivo CSV.", count);

//--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
    FileFlush(hndCsvFile);

//--- fecha o arquivo e inutiliza handle:
    FileClose(hndCsvFile);
    hndCsvFile = INVALID_HANDLE;  // invalida o handle do arquivo;

    return true;
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WriteCalendar(SEconomicCalendar &array_calendar[], int &array_size)
   {
//--- efetua abertura do arquivo, sempre sobrescrevendo se existir:
    ResetLastError();
    int hndBinFile = FileOpen(FILE_CALENDAR_BIN, FILE_WRITE|FILE_BIN|FILE_COMMON);
    if(hndBinFile == INVALID_HANDLE)
       {
        PrintFormat("ERRO: Operação 'FileOpen(%s)' falhou! LastError = %d.", FILE_CALENDAR_BIN, GetLastError());
        return false;
       }

//--- percorre o array do calendar e salva todos os registros do calendario:
    for(int i=0; i < array_size; i++)
       {
        FileWriteStruct(hndBinFile, array_calendar[i]);
       }
    PrintFormat("WriteCalendar: Foram gravados %d eventos em arquivo BIN.", array_size);

//--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
    FileFlush(hndBinFile);

//--- fecha o arquivo e inutiliza handle:
    FileClose(hndBinFile);
    hndBinFile = INVALID_HANDLE;  // invalida o handle do arquivo;

    return true;
   }


//+------------------------------------------------------------------+
