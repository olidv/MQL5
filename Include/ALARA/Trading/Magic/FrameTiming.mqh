/*
 ***********************************************************************************************
 Este programa de  computador contem informacoes  confidenciais de propriedade da ALARA CAPITAL,
 e esta  protegido pela lei de copyright. Voce nao  deve divulgar tais informacoes confidenciais
 e  deve usa-las somente em  conformidade com os termos  do contrato de licenca  definidos  pela
 ALARA CAPITAL. A reproducao ou distribuicao nao autorizada deste programa, ou de qualquer parte
 dele,  resultara na  imposicao de  rigorosas penas  civis e  criminais,  e sera  objeto de acao
 judicial promovida na maxima extensao possivel, nos termos da lei.

 Parte integrante do repositorio de componentes, rotinas e artefatos  criados pela ALARA CAPITAL
 para o desenvolvimento de Trading Algorítmico na plataforma MetaQuotes MetaTrader for Desktop.
 ***********************************************************************************************
*/
#property copyright    "Copyright (C) 2020-2022, ALARA CAPITAL. Todos os direitos reservados."
#property link         "https://www.Alara.com.BR/"

//program file         FrameTiming.mqh
//program package      MQL5/Include/ALARA/Trading/Magic/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************

#property library


//+------------------------------------------------------------------+
//| Enumeration EFrameTiming.                                        |
//|                                                                  |
//| Usage: Informa o estilo e temporizacao das operacoes de trading. |
//+------------------------------------------------------------------+
enum EFrameTiming
   {
//--- Periodo em minutos:
    TIMING_M1    = 1,    // o mesmo significado de PERIOD_M1
    TIMING_M2    = 2,    // o mesmo significado de PERIOD_M2
    TIMING_M3    = 3,    // o mesmo significado de PERIOD_M3
    TIMING_M4    = 4,    // o mesmo significado de PERIOD_M4
    TIMING_M5    = 5,    // o mesmo significado de PERIOD_M5
    TIMING_M6    = 6,    // o mesmo significado de PERIOD_M6
    TIMING_M10   = 10,   // o mesmo significado de PERIOD_M10
    TIMING_M12   = 12,   // o mesmo significado de PERIOD_M12
    TIMING_M15   = 15,   // o mesmo significado de PERIOD_M15
    TIMING_M20   = 20,   // o mesmo significado de PERIOD_M20
    TIMING_M30   = 30,   // o mesmo significado de PERIOD_M30

//--- Periodo em horas:
    TIMING_H1    = 61,   // o mesmo significado de PERIOD_H1
    TIMING_H2    = 62,   // o mesmo significado de PERIOD_H2
    TIMING_H3    = 63,   // o mesmo significado de PERIOD_H3
    TIMING_H4    = 64,   // o mesmo significado de PERIOD_H4
    TIMING_H6    = 66,   // o mesmo significado de PERIOD_H6
    TIMING_H8    = 68,   // o mesmo significado de PERIOD_H8
    TIMING_H12   = 72,   // o mesmo significado de PERIOD_H12

//--- Periodo em dia, semana e/ou mes:
    TIMING_D1    = 91,   // o mesmo significado de PERIOD_D1
    TIMING_W1    = 92,   // o mesmo significado de PERIOD_W1
    TIMING_MN1   = 93,   // o mesmo significado de PERIOD_MN1
   };


//+------------------------------------------------------------------+
//| Converte um valor de ENUM_TIMEFRAMES para EFrameTiming.          |
//+------------------------------------------------------------------+
EFrameTiming EncodePeriod(const ENUM_TIMEFRAMES periodo)
   {
    switch(periodo)
       {
        case PERIOD_M1:
            return TIMING_M1;
        case PERIOD_M2:
            return TIMING_M2;
        case PERIOD_M3:
            return TIMING_M3;
        case PERIOD_M4:
            return TIMING_M4;
        case PERIOD_M5:
            return TIMING_M5;
        case PERIOD_M6:
            return TIMING_M6;
        case PERIOD_M10:
            return TIMING_M10;
        case PERIOD_M12:
            return TIMING_M12;
        case PERIOD_M15:
            return TIMING_M15;
        case PERIOD_M20:
            return TIMING_M20;
        case PERIOD_M30:
            return TIMING_M30;
        case PERIOD_H1:
            return TIMING_H1;
        case PERIOD_H2:
            return TIMING_H2;
        case PERIOD_H3:
            return TIMING_H3;
        case PERIOD_H4:
            return TIMING_H4;
        case PERIOD_H6:
            return TIMING_H6;
        case PERIOD_H8:
            return TIMING_H8;
        case PERIOD_H12:
            return TIMING_H12;
        case PERIOD_D1:
            return TIMING_D1;
        case PERIOD_W1:
            return TIMING_W1;
        case PERIOD_MN1:
            return TIMING_MN1;
        default:
            return TIMING_M1;
       }
   }




//+------------------------------------------------------------------+
//| Converte um valor de EFrameTiming para ENUM_TIMEFRAMES.          |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES DecodePeriod(const EFrameTiming periodo)
   {
    switch(periodo)
       {
        case TIMING_M1:
            return PERIOD_M1;
        case TIMING_M2:
            return PERIOD_M2;
        case TIMING_M3:
            return PERIOD_M3;
        case TIMING_M4:
            return PERIOD_M4;
        case TIMING_M5:
            return PERIOD_M5;
        case TIMING_M6:
            return PERIOD_M6;
        case TIMING_M10:
            return PERIOD_M10;
        case TIMING_M12:
            return PERIOD_M12;
        case TIMING_M15:
            return PERIOD_M15;
        case TIMING_M20:
            return PERIOD_M20;
        case TIMING_M30:
            return PERIOD_M30;
        case TIMING_H1:
            return PERIOD_H1;
        case TIMING_H2:
            return PERIOD_H2;
        case TIMING_H3:
            return PERIOD_H3;
        case TIMING_H4:
            return PERIOD_H4;
        case TIMING_H6:
            return PERIOD_H6;
        case TIMING_H8:
            return PERIOD_H8;
        case TIMING_H12:
            return PERIOD_H12;
        case TIMING_D1:
            return PERIOD_D1;
        case TIMING_W1:
            return PERIOD_W1;
        case TIMING_MN1:
            return PERIOD_MN1;
        default:
            return PERIOD_M1;
       }
   }

//+------------------------------------------------------------------+
