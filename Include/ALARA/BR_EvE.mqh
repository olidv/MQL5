/*
===============================================================================

 package: MQL5\Include\_ALARA

 module : BR_EvE.mqh

===============================================================================
*/
#property library

#property copyright   "Copyright 2021, ALARA Investimentos"
#property link        "http://www.alara.com.br"
#property version     "1.00"
#property description ""
#property description ""


//+------------------------------------------------------------------+
//| EX5s                                                      |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| OBJECT FUNCTIONS.                                                |
//+------------------------------------------------------------------+

//---
template<typename TValue>
bool isNull(TValue value)
   {
    return (value == NULL);
   }


//---
template<typename TValue>
bool isNotNull(TValue value)
   {
    return (value != NULL);
   }


//+------------------------------------------------------------------+
//| STRING FUNCTIONS.                                                |
//+------------------------------------------------------------------+

//---
int Len(string value)
   {
    return (value == NULL) ? 0 : StringLen(value);
   }


//---
string Trim(string value)
   {
    if(value == NULL || StringLen(value) == 0)
        return "";

    StringTrimLeft(value);
    StringTrimRight(value);
    return value;
   }


//---
bool isEmpty(string value)
   {
    if(value == NULL || StringLen(value) == 0)
        return true;

    StringTrimLeft(value);
    StringTrimRight(value);
    return (StringLen(value) == 0);
   }


//---
bool isNotEmpty(string value)
   {
    if(value != NULL && StringLen(value) > 0)
        return true;

    StringTrimLeft(value);
    StringTrimRight(value);
    return (StringLen(value) != 0);
   }


//+------------------------------------------------------------------+
//| NUMBER FUNCTIONS.                                                |
//+------------------------------------------------------------------+

//---
template<typename TNumber>
bool isZero(TNumber value)
   {
    return (value == NULL || value == 0);
   }


//---
template<typename TNumber>
bool isNotZero(TNumber value)
   {
    return (value != NULL && value != 0);
   }


//---
template<typename TNumber>
bool isValuable(TNumber value)
   {
    return (value != NULL && value > 0);
   }


//---
template<typename TNumber>
bool isNotValuable(TNumber value)
   {
    return (value == NULL || value <= 0);
   }


//+------------------------------------------------------------------+
