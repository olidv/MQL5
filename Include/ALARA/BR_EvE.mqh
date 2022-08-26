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

//program file         BR_EvE.mqh
//program package      MQL5/Include/ALARA/
#property version	   "1.000"
#property description  "..."

//**********************************************************************************************  

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| OBJECT FUNCTIONS.                                                |
//+------------------------------------------------------------------+

//---
#define isNull(v)         (v == NULL)
#define isNotNull(v)      (v != NULL)


//+------------------------------------------------------------------+
//| NUMBER FUNCTIONS.                                                |
//+------------------------------------------------------------------+

//---
#define isZero(v)         (isNull(v) || v == 0)
#define isNotZero(v)      (isNotNull(v) && v != 0)
#define isValuable(v)     (isNotNull(v) && v > 0)
#define isNotValuable(v)  (isNull(v) || v <= 0)


//+------------------------------------------------------------------+
//| STRING FUNCTIONS.                                                |
//+------------------------------------------------------------------+

//---
#define Len(s)            (isNull(s) ? 0 : StringLen(s))


//---
string Trim(string value)
   {
    if(Len(value) == 0)
        return "";

    StringTrimLeft(value);
    StringTrimRight(value);
    return value;
   }


//---
bool isEmpty(string value)
   {
    if(Len(value) == 0)
        return true;

    StringTrimLeft(value);
    StringTrimRight(value);
    return (StringLen(value) == 0);
   }


//---
bool isNotEmpty(string value)
   {
    if(Len(value) != 0)
        return true;

    StringTrimLeft(value);
    StringTrimRight(value);
    return (StringLen(value) != 0);
   }


//+------------------------------------------------------------------+
