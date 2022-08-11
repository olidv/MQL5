//+------------------------------------------------------------------+
//|                                                    InfoTimer.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+

//--- Funcoes para obtencao da hora a partir da Windows API
#include <ALARA\WinAPI_Time.mqh>

//+------------------------------------------------------------------+
//| NOVAS DEFINICOES                                                 |
//+------------------------------------------------------------------+
#define TIMER_SECONDS 60     // timer = 5 minutos

//--- Estrutura propria para armazenar eventos de calendario com valores reais em vez de valores inteiros:
struct SCalendarEventValue
   {
    ulong                               id_value;              // ID do valor
    ulong                               idx_event;             // Index do evento em estrutura correlata.
    datetime                            time;                  // hora e data do evento
    datetime                            period;                // período de relatório do evento
    int                                 revision;              // revisão do indicador publicado em relação ao período de relatório
    ENUM_CALENDAR_EVENT_IMPACT          impact_type;           // impacto potencial na taxa de câmbio
    long                                actual_value;          // valor atual do indicador
    long                                prev_value;            // valor anterior do indicador
    long                                revised_prev_value;    // valor anterior revisado do indicador
    long                                forecast_value;        // valor previsto do indicador
   };

//+------------------------------------------------------------------+
//| VARIAVEIS GLOBAIS                                                |
//+------------------------------------------------------------------+
MqlCalendarEvent dataEvents[];
int              sizeEvents = 0;

datetime firstDayPrevious, lastDayPrevious,
         firstDayCurrent,  lastDayCurrent,
         firstDayNext,     lastDayNext;

SCalendarEventValue valuesPrevious[], valuesCurrent[], valuesNext[];
int                 countPrevious,    countCurrent,    countNext;

//+------------------------------------------------------------------+
//| FUNCOES HELPERS                                                  |
//+------------------------------------------------------------------+
int getIdxCalendarEvent(ulong event_id)
   {
    int idx = -1;  // recebe o indice o evento na estrutura array global...

    if(sizeEvents > 0)
       {
        // procura o evento indicado no array global de eventos:
        for(int i=0; i < sizeEvents; i++)
           {
            if(dataEvents[i].id == event_id)
               {
                idx = i;
               }
           }
       }

// se nao achou o evento, eh preciso buscar o evento no servidor:
    if(idx == -1)
       {
        MqlCalendarEvent event = {0};
        if(CalendarEventById(event_id, event))
           {
            idx = sizeEvents;
            sizeEvents++;
            ArrayResize(dataEvents, sizeEvents);
            dataEvents[idx] = event;
           }
       }

    return idx;
   }

//+------------------------------------------------------------------+
//| Obtem valores de eventos do calendario para o periodo fornecido. |
//+------------------------------------------------------------------+
int getCalendarValues(SCalendarEventValue& eventValues[], datetime firstDay, datetime lastDay)
   {
//--- Obtem o array de valores dos eventos para o periodo informado:
    MqlCalendarValue values[];
    const int countValues = CalendarValueHistory(values, firstDay, lastDay, "BR", NULL);
    if(countValues <= 0)     // Se nao encontrou valores dos eventos, entao pula fora:
       {
        return 0;
       }

//--- Percorre o array de valores para obter o respectivo evento:
    ArrayResize(eventValues, countValues);
    int valoresSemEvento = 0;
    for(int i=0; i < countValues; i++)
       {
        // registra os dados dos valores do evento:
        eventValues[i].id_value    = values[i].id;
        eventValues[i].idx_event   = getIdxCalendarEvent(values[i].event_id);
        eventValues[i].time        = values[i].time;
        eventValues[i].period      = values[i].period;
        eventValues[i].revision    = values[i].revision;
        eventValues[i].impact_type = values[i].impact_type;

        eventValues[i].actual_value       = values[i].actual_value;
        eventValues[i].prev_value         = values[i].prev_value;
        eventValues[i].revised_prev_value = values[i].revised_prev_value;
        eventValues[i].forecast_value     = values[i].forecast_value;
       }
    if(valoresSemEvento > 0)
       {
        Print("** ATENCAO: Nao encontrou eventos para ", valoresSemEvento, " valor(es)!");
       }

    return countValues;
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int compareCalendarValues(int id_mes, datetime firstDay, datetime lastDay)
   {
    string mes_str = "";
    int count_oldValues = 0;
    switch(id_mes)
       {
        case -1:
            mes_str = "Mes Anterior";
            count_oldValues = countPrevious;
            break;
        case  0:
            mes_str = "Mes Corrente";
            count_oldValues = countCurrent;
            break;
        case  1:
            mes_str = "Mes Posterior";
            count_oldValues = countNext;
            break;
       }
    Print("    Comparando eventos/valores do ", mes_str, ":");

    SCalendarEventValue newValues[];
    int count_newValues = getCalendarValues(newValues, firstDay, lastDay);

    int c_idx_event = 0, c_time = 0, c_period = 0, c_revision = 0, c_impact_type = 0,
        c_actual_value = 0, c_prev_value = 0, c_revised_prev_value = 0, c_forecast_value = 0;
    for(int i=0; i < count_oldValues; i++)
       {
        SCalendarEventValue oldValue;
        switch(id_mes)
           {
            case -1:
                oldValue = valuesPrevious[i];
                break;
            case  0:
                oldValue = valuesCurrent[i];
                break;
            case  1:
                oldValue = valuesNext[i];
                break;
           }
        for(int j=0; j < count_newValues; j++)
           {

            if(oldValue.id_value == newValues[j].id_value)
               {
                if(oldValue.idx_event != newValues[j].idx_event)
                   {
                    Print("        * idx_event de ",oldValue.idx_event," p/ ",newValues[j].idx_event);
                    c_idx_event++;
                    oldValue.idx_event = newValues[j].idx_event;
                   }

                if(oldValue.time != newValues[j].time)
                   {
                    Print("        * time de ",oldValue.time," p/ ",newValues[j].time);
                    c_time++;
                    oldValue.time = newValues[j].time;
                   }

                if(oldValue.period != newValues[j].period)
                   {
                    Print("        * period de ",oldValue.period," p/ ",newValues[j].period);
                    c_period++;
                    oldValue.period = newValues[j].period;
                   }

                if(oldValue.revision != newValues[j].revision)
                   {
                    Print("        * revision de ",oldValue.revision," p/ ",newValues[j].revision);
                    c_revision++;
                    oldValue.revision = newValues[j].revision;
                   }

                if(oldValue.impact_type != newValues[j].impact_type)
                   {
                    Print("        * impact_type de ",oldValue.impact_type," p/ ",newValues[j].impact_type);
                    c_impact_type++;
                    oldValue.impact_type = newValues[j].impact_type;
                   }

                if(oldValue.actual_value != newValues[j].actual_value)
                   {
                    Print("        * actual_value de ",oldValue.actual_value," p/ ",newValues[j].actual_value);
                    c_actual_value++;
                    oldValue.actual_value = newValues[j].actual_value;
                   }

                if(oldValue.prev_value != newValues[j].prev_value)
                   {
                    Print("        * prev_value de ",oldValue.prev_value," p/ ",newValues[j].prev_value);
                    c_prev_value++;
                    oldValue.prev_value = newValues[j].prev_value;
                   }

                if(oldValue.revised_prev_value != newValues[j].revised_prev_value)
                   {
                    Print("        * revised_prev_value de ",oldValue.revised_prev_value," p/ ",newValues[j].revised_prev_value);
                    c_revised_prev_value++;
                    oldValue.revised_prev_value = newValues[j].revised_prev_value;
                   }

                if(oldValue.forecast_value != newValues[j].forecast_value)
                   {
                    Print("        * forecast_value de ",oldValue.forecast_value," p/ ",newValues[j].forecast_value);
                    c_forecast_value++;
                    oldValue.forecast_value = newValues[j].forecast_value;
                   }
               }
           }
       }

    if(count_newValues != count_oldValues)
        Print("        Nova Qtd.Valores do ",mes_str," = ",count_newValues,"  <>  ",count_oldValues);

    if(c_idx_event > 0)
        Print("        Alterados idx_event = ", c_idx_event);

    if(c_time > 0)
        Print("        Alterados time = ", c_time);

    if(c_period > 0)
        Print("        Alterados period = ", c_period);

    if(c_revision > 0)
        Print("        Alterados revision = ", c_revision);

    if(c_impact_type > 0)
        Print("        Alterados impact_type = ", c_impact_type);

    if(c_actual_value > 0)
        Print("        Alterados actual_value = ", c_actual_value);

    if(c_prev_value > 0)
        Print("        Alterados prev_value = ", c_prev_value);

    if(c_revised_prev_value > 0)
        Print("        Alterados revised_prev_value = ", c_revised_prev_value);

    if(c_forecast_value > 0)
        Print("        Alterados forecast_value = ", c_forecast_value);

    return count_newValues;
   }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
//--- Obtem os eventos do mes anterior:
    PeriodPreviousMonth(firstDayPrevious, lastDayPrevious);
    Print("Intervalo do Mes Anterior  : ", firstDayPrevious, " ... ", lastDayPrevious);

    countPrevious = getCalendarValues(valuesPrevious, firstDayPrevious, lastDayPrevious);
    Print("    Qtd.Valores do Mes Anterior = ",countPrevious);

//--- Obtem os eventos do mes corrente:
    PeriodCurrentMonth(firstDayCurrent, lastDayCurrent);
    Print("Intervalo do Mes Corrente  : ", firstDayCurrent, " ... ", lastDayCurrent);

    countCurrent = getCalendarValues(valuesCurrent, firstDayCurrent, lastDayCurrent);
    Print("    Qdt.Valores do Mes Corrente = ",countCurrent);

//--- Obtem os eventos do mes posterior:
    PeriodNextMonth(firstDayNext, lastDayNext);
    Print("Intervalo do Mes Posterior : ", firstDayNext, " ... ", lastDayNext);

    countNext = getCalendarValues(valuesNext, firstDayNext, lastDayNext);
    Print("    Qtd.Valores do Mes Posterior = ",countNext);

    Print("Estrutura dataEvents contem ", sizeEvents, " registros de eventos.");
    Print("------------------------------------------------------------------------");

//--- configura disparo do timer, para verificar alteracoes no calendario:
    EventSetTimer(TIMER_SECONDS);

//---
    return(INIT_SUCCEEDED);
   }

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
   {
    Print("[TIMER] Vai efetuar nova coleta de eventos/valores do calendario...");

//--- Busca novamente os eventos do calendario, para comparacao:
    int oldSizeEvents = sizeEvents;
    countPrevious = compareCalendarValues(-1, firstDayPrevious, lastDayPrevious);
    countCurrent= compareCalendarValues(0, firstDayCurrent, lastDayCurrent);
    countNext = compareCalendarValues(1, firstDayNext, lastDayNext);

//--- Obteve os eventos novamente para comparar com a coleta anterior:
    if(oldSizeEvents != sizeEvents)
        Print("    ** Novos registros de eventos em [dataEvents] = ",sizeEvents,"  <>  ",oldSizeEvents);

    Print("------------------------------------------------------------------------");
   }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
//--- destroy timer
    EventKillTimer();
   }

//+------------------------------------------------------------------+
