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
#property version    "1.000"
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
int Len(string s)
   {
    return (isNull(s) ? 0 : StringLen(s));
   }


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
//| NUMBER FUNCTIONS.                                                |
//+------------------------------------------------------------------+

//---
string ToString(long number, int str_len=0, ushort fill_symbol=' ')
   {
    return IntegerToString(number, str_len, fill_symbol);
   }


//---
string ToString(double number)
   {
    if(isZero(number))
        return "0.0";

    string strVal = DoubleToString(number);
    int posDot = StringFind(strVal, ".");
    if(posDot == -1)
        return strVal;

//--- extrai os valores das casas decimais ate o ultimo zero:
    int lenVal = StringLen(strVal);
    int lastDig = lenVal - 1;
    ushort chrAt = StringGetCharacter(strVal, lastDig);
    while(chrAt == '0')
       {
        --lastDig;
        chrAt = StringGetCharacter(strVal, lastDig);
       }

    if(chrAt == '.')
        ++lastDig;

    return StringSubstr(strVal, 0, lastDig + 1);
   }


//---
string ToString(double number, int digits, int str_len=0, ushort fill_symbol=' ')
   {
    string strVal = DoubleToString(number, digits);
    int lenVal = StringLen(strVal);

//--- formata o valor de acordo com os parametros:
    if(lenVal < str_len)
       {
        string fill;
        StringInit(fill, str_len - lenVal, fill_symbol);
        strVal = fill + strVal;
       }

    return strVal;
   }


//---
int Len(long number)
   {
    return StringLen(ToString(number));
   }


//---
int Len(double number)
   {
    return StringLen(ToString(number));
   }


//+------------------------------------------------------------------+
