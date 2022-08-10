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
#define TIMER_SECONDS 300     // timer = 5 minutos

//--- Estrutura propria para armazenar eventos de calendario com valores reais em vez de valores inteiros:
struct SCalendarEventValue
   {
    ulong                               idx_event;             // Index do evento em estrutura correlata.
    ulong                               id_value;              // ID do valor
    datetime                            time;                  // hora e data do evento
    datetime                            period;                // período de relatório do evento
    int                                 revision;              // revisão do indicador publicado em relação ao período de relatório
    double                              actual_value;          // valor atual do indicador
    double                              prev_value;            // valor anterior do indicador
    double                              revised_prev_value;    // valor anterior revisado do indicador
    double                              forecast_value;        // valor previsto do indicador
    ENUM_CALENDAR_EVENT_IMPACT          impact_type;           // impacto potencial na taxa de câmbio
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

        // converte os valores originais em double (forma correta):
        if(values[i].HasActualValue())
            eventValues[i].actual_value=values[i].GetActualValue();
        else
            eventValues[i].actual_value=double("nan");

        if(values[i].HasPreviousValue())
            eventValues[i].prev_value=values[i].GetPreviousValue();
        else
            eventValues[i].prev_value=double("nan");

        if(values[i].HasRevisedValue())
            eventValues[i].revised_prev_value=values[i].GetRevisedValue();
        else
            eventValues[i].revised_prev_value=double("nan");

        if(values[i].HasForecastValue())
            eventValues[i].forecast_value=values[i].GetForecastValue();
        else
            eventValues[i].forecast_value=double("nan");
       }
    if(valoresSemEvento > 0)
       {
        Print("** ATENCAO: Nao encontrou eventos para ", valoresSemEvento, " valor(es)!");
       }

    return countValues;
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
//--- Busca novamente os eventos do calendario, para comparacao:
    SCalendarEventValue vPrevious[], vCurrent[], vNext[];
    int                 cPrevious,   cCurrent,   cNext;
    int oldSizeEvents = sizeEvents;

    Print("[TIMER] Vai efetuar nova coleta de eventos/valores do calendario...");

//--- Obtem os eventos do mes anterior:
    cPrevious = getCalendarValues(vPrevious, firstDayPrevious, lastDayPrevious);
    if(cPrevious != countPrevious)
       {
        Print("** Nova Qtd.Valores do Mes Anterior = ",cPrevious,"  <>  ",countPrevious);
        countPrevious = cPrevious;
       }

//--- Obtem os eventos do mes corrente:
    cCurrent = getCalendarValues(vCurrent, firstDayCurrent, lastDayCurrent);
    if(cCurrent != countCurrent)
       {
        Print("** Nova Qdt.Valores do Mes Corrente = ",cCurrent,"  <>  ",countCurrent);
        countCurrent = cCurrent;
       }

//--- Obtem os eventos do mes posterior:
    cNext = getCalendarValues(vNext, firstDayNext, lastDayNext);
    if(cNext != countNext)
       {
        Print("** Nova Qtd.Valores do Mes Posterior = ",cNext,"  <>  ",countNext);
        countNext = cNext;
       }

    if(oldSizeEvents != sizeEvents)
       {
        Print("** Novos registros de eventos em [dataEvents] = ",sizeEvents,"  <>  ",oldSizeEvents);
       }
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
