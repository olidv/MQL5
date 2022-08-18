/*
===============================================================================

 package: MQL5\Experts\ALARA\COMMON

 module : EA_CSV_WriteCalendar.mq5

===============================================================================
*/
#property service
#property copyright   "Copyright 2021, ALARA Investimentos"
#property link        "http://www.alara.com.br"
#property version     "1.00"
#property description ""


//+------------------------------------------------------------------+
//--- Funcoes para obtencao da hora a partir da Windows API
#include <ALARA\WinAPI_Time.mqh>


//+------------------------------------------------------------------+
//--- timer em milissegundos = 10 segundos
#define TIMER_SECONDS       10
#define TIMER_MILLISECONDS  10000


//+------------------------------------------------------------------+
//--- Em 2022-08-16 o calendario possuia 23 paises...
//--- Em 2022-08-16 o pais US posuia 246 eventos...

//--- indica a operacao realizada no registro de evento do calendario economico:
enum ECalendarRecord
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


//--- Estrutura para armazenar eventos e valores de calendario:
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


//--- VARIAVEIS GLOBAIS:
SEconomicCalendar st_calendar[];
int size_calendar          = 0;
ulong countCalendarUpdates = 0,
      countCalendarInserts = 0;


//--- Arquivo CSV para salvar as alteracoes ocorridas no calendario economico:
const string FILE_CALENDAR_CSV = "_Calendar.csv";

// Data (apenas dd/mm/yyyy) do arquivo CSV gerado - parte do nome do arquivo;
datetime dtDiaColeta       = GetDate();
string   strDiaColeta      = TimeToString(dtDiaColeta, TIME_DATE);
int      hndCsvFileUpdates = INVALID_HANDLE;  // handle para arquivo CSV gerado.


//+------------------------------------------------------------------+
//| Service program start function                                   |
//+------------------------------------------------------------------+
void OnStart()
   {
//--- Obtem a data do dia da coleta - apenas dia/mes/ano, sem parte horas.
    PrintFormat("INICIO [CALENDAR] EM %s : WRITE EVENT/VALUE UPDATES CSV FILE  |  TIMER = %d seg", strDiaColeta, TIMER_SECONDS);
    Print("---------------------------------------------------------------------------------------");

//--- Inicializa a estrutura com o calendario economico para servir de referencia:
    if(! LoadCalendar(st_calendar, size_calendar))
       {
        return;
       }

//--- Efetua abertura do arquivo CSV para escrita das alteracoes no calendario.
    if(! OpenFileUpdates(strDiaColeta))
       {
        return;
       }

//--- Loop continuo para varredura das alteracoes no calendario economico:
    while(! IsStopped())
       {
        //Print("Seviço esta em execução");

        //--- verifica se houve alguma mudanca no calendario economico apos alguns segundos:
        if(compareCalendarValues(st_calendar, size_calendar))     // retorna TRUE se houve alteracoes ou inclusoes
           {
            // se a comparacao foi feita com sucesso, salva as alteracoes no arquivo CSV:
            WriteFileUpdates(st_calendar, size_calendar);
           }

        //--- a cada iteracao, verifica se passou para o dia seguinte:
        datetime dtAgora = GetDate();
        if(dtAgora > dtDiaColeta)
           {
            //--- fecha o arquivo CSV e encerra coleta do dia anterior:
            CloseFileUpdates();

            // atualiza a data do servico:
            dtDiaColeta = dtAgora;
            strDiaColeta = TimeToString(dtDiaColeta, TIME_DATE);

            //--- inicia coleta do dia corrente e abre o novo arquivo CSV:
            if(! OpenFileUpdates(strDiaColeta))
               {
                return;  // se ocorrer erro, nao tem como prosseguir no servico...
               }
           }

        //--- aguarda alguns segundos antes da proxima iteracao:
        Sleep(TIMER_MILLISECONDS);
       }

//--- ao final, fecha o arquivo CSV contendo alteracoes no calendario:
    CloseFileUpdates();

    Print("--------------------------------------------------------------------------------------------------------------------");
    PrintFormat("FIM [CALENDARIO] EM %s : Total de %d Eventos Alterados no Dia.  |  Total de %d Eventos Incluidos no Dia.", strDiaColeta, countCalendarUpdates, countCalendarInserts);
   }


//+------------------------------------------------------------------+
//| Obtem valores de todos os eventos no calendario a partir de hoje.|
//+------------------------------------------------------------------+
int getCalendarValues(MqlCalendarValue &values[])
   {
//--- Obtem novo array de valores dos eventos de hoje para o futuro:
    ResetLastError();
    int count = CalendarValueHistory(values, dtDiaColeta);
    if(count <= 0)   // Se nao encontrou valores dos eventos, entao pula fora:
       {
        PrintFormat("ERRO: CalendarValueHistory(%s) retornou 0! LastError = %d.", strDiaColeta, GetLastError());
        return NULL;
       }

    return count;
   }


//+------------------------------------------------------------------+
//| Obtem os dados do evento e do pais relativos ao valor historico. |
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

//--- salva apenas as informacoes numericas, para manter a estrutura simples:
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


//+-------------------------------------------------------------------------------+
//| Inicializa a estrutura com o calendario economico para servir de referencia.  |
//+-------------------------------------------------------------------------------+
bool LoadCalendar(SEconomicCalendar &array_calendar[], int &array_size)
   {
//--- Obtem novo array de valores do calendario de hoje para o futuro:
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

        // obtem os dados do evento e do pais relativos ao valor historico:
        setEventAndCountry(array_calendar[i]);
       }
//PrintFormat("ReloadCalendar: Carregou %d eventos do calendario.", array_size);

    return true;
   }


//+------------------------------------------------------------------+
//| Compara o calendario anterior com o calendario.ion                                                   |
//+------------------------------------------------------------------+
bool compareCalendarValues(SEconomicCalendar &array_calendar[], int &array_size)
   {
    bool has_changed = false;

//--- Obtem novo array de valores dos eventos de hoje para o futuro:
    MqlCalendarValue values[];
    int sizeNewCalendar = getCalendarValues(values);
    if(sizeNewCalendar == NULL)
        return false;
//PrintFormat("OnTimer: Foram carregados %d eventos do historico do calendario.", sizeNewCalendar);

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
        for(int j=0; j < array_size; j++)
           {
            //--- compara o calendario anterior com os novos valores:
            if(newCalendar[i].value_id == array_calendar[j].value_id)
               {
                achou = true;
                // verifica se algum valor do evento foi modificado:
                if(newCalendar[i].time != array_calendar[j].time)
                   {
                    newCalendar[i].record_type |= CALENDAR_UPDATE_TIME;
                    //Print("** Alterou .time");
                   }

                if(newCalendar[i].actual_value != array_calendar[j].actual_value)
                   {
                    newCalendar[i].record_type |= CALENDAR_UPDATE_ACTUAL_VALUE;
                    //Print("** Alterou .actual_value");
                   }

                if(newCalendar[i].prev_value != array_calendar[j].prev_value)
                   {
                    newCalendar[i].record_type |= CALENDAR_UPDATE_PREV_VALUE;
                    //Print("** Alterou .prev_value");
                   }

                if(newCalendar[i].revised_prev_value != array_calendar[j].revised_prev_value)
                   {
                    newCalendar[i].record_type |= CALENDAR_UPDATE_REVISED_PREV_VALUE;
                    //Print("** Alterou .revised_prev_value");
                   }

                if(newCalendar[i].forecast_value != array_calendar[j].forecast_value)
                   {
                    newCalendar[i].record_type |= CALENDAR_UPDATE_FORECAST_VALUE;
                    //Print("** Alterou .forecast_value");
                   }

                if(newCalendar[i].impact_type != array_calendar[j].impact_type)
                   {
                    newCalendar[i].record_type |= CALENDAR_UPDATE_IMPACT_TYPE;
                    //Print("** Alterou .impact_type");
                   }

                if(newCalendar[i].record_type != CALENDAR_LOADED_VALUE)
                   {
                    ++countCalendarUpdates;
                    has_changed = true;
                    //PrintFormat("OnTimer: Evento alterado. Valor de record_type = %d.", newCalendar[i].record_type);
                   }
               }
           }
        // se nao achou o valor, entao eh um novo registro de evento/valor:
        if(! achou)
           {
            newCalendar[i].record_type = CALENDAR_INSERT_VALUE;
            ++countCalendarInserts;
            has_changed = true;
           }
       }

//--- repassa o novo calendario para a referencia principal:
    ZeroMemory(array_calendar);
    ArrayCopy(array_calendar, newCalendar);

//--- verifica se houve alteracoes no calendario desdes o ultimo teste:
    has_changed |= (array_size != sizeNewCalendar);
    array_size = sizeNewCalendar;
//if(has_changed)
//   {
//    PrintFormat("OnTimer: Array do calendario tinha %d eventos e agora possui %d.", array_size, sizeNewCalendar);
//   }

//---
//Print("------------------------------------------------------------------------");
    return has_changed;
   }


//+---------------------------------------------------------------------------+
//| Efetua abertura do arquivo CSV para escrita das alteracoes no calendario. |
//+---------------------------------------------------------------------------+
bool OpenFileUpdates(string strCsvFile)
   {
    string fileName = strCsvFile + FILE_CALENDAR_CSV;
    bool fileExist = FileIsExist(fileName);

//--- abre o arquivo para leitura, caso exista, ou apenas escrita se for a primeira vez:
    ResetLastError();
    hndCsvFileUpdates = fileExist ? FileOpen(fileName, FILE_READ|FILE_SHARE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI)
                        : FileOpen(fileName, FILE_SHARE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);
    if(hndCsvFileUpdates == INVALID_HANDLE)
       {
        PrintFormat("ERRO: Operação 'FileOpen(%s)' falhou! LastError = %d.", fileName, GetLastError());
        return false;
       }
    else
        if(fileExist)
           {
            FileSeek(hndCsvFileUpdates, 0, SEEK_END);
           }
        else
           {
            FileWrite(hndCsvFileUpdates, "LOCAL_TIME", "RECORD_TYPE", "VALUE_ID", "TIME", "PERIOD", "REVISION", "ACTUAL_VALUE",
                      "PREV_VALUE", "REVISED_PREV_VALUE", "FORECAST_VALUE", "IMPACT_TYPE", "EVENT_ID", "COUNTRY_ID",
                      "TYPE", "TIME_MODE", "SECTOR", "FREQUENCY", "IMPORTANCE", "UNIT", "MULTIPLIER", "DIGITS");
           }

//---
    return true;
   }


//+------------------------------------------------------------------+
//| Salva as alteracoes verificadas no calendario no arquivo CSV.    |
//+------------------------------------------------------------------+
bool WriteFileUpdates(SEconomicCalendar &array_calendar[], int &array_size)
   {
    long localTime = GetMillisecondsDatetime();

//--- percorre o array do calendar e salva apenas os registros alterados:
    int count = 0;
    for(int i=0; i < array_size; i++)
       {
        // verifica se houve alguma alteracao no registro apos a carga (load):
        if(array_calendar[i].record_type != CALENDAR_LOADED_VALUE)
           {
            ++count;
            FileWrite(hndCsvFileUpdates, localTime,
                      array_calendar[i].record_type,
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
//PrintFormat("WriteFileUpdates: Foram gravados %d eventos alterados em arquivo CSV.", count);

//--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
    FileFlush(hndCsvFileUpdates);

    return true;
   }


//+------------------------------------------------------------------+
//| Fecha o arquivo CSV contendo alteracoes no calendario economico. |
//+------------------------------------------------------------------+
void CloseFileUpdates()
   {
//--- os dados serão gravados no arquivo e não serão perdidos no caso de um erro crítico
    FileFlush(hndCsvFileUpdates);

//--- fecha o arquivo e inutiliza handle:
    FileClose(hndCsvFileUpdates);
    hndCsvFileUpdates = INVALID_HANDLE;  // invalida o handle do arquivo;
   }


//+------------------------------------------------------------------+
