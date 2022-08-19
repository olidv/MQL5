//+------------------------------------------------------------------+
//|                                                      Strings.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

#include <ALARA\BR_EvE.mqh>              // Funcoes utilitarias de uso geral (Enumerators e Evaluators).

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int OnInit()
   {
//---
    ulong LIMITE=10000;
    ulong i = 0, j = 0;

//---
    string a="a",b="b",c;

//--- primeiro método
    uint start=GetTickCount(),stop;
    c = a;
    for(i=0; i<LIMITE; i++)
       {
        c += b;
       }
    stop=GetTickCount();
    Print("tempo para 'c += b' = ",(stop-start)," milissegundos, i = ",i);
//Alert("tempo para 'c += b' = ",(stop-start)," milissegundos, i = ",i);

//--- segundo método
    start=GetTickCount();
    c = a;
    for(i=0; i<LIMITE; i++)
       {
        StringAdd(c,b);
       }
    stop=GetTickCount();
    Print("tempo para 'StringAdd(c,b)' = ",(stop-start)," milissegundos, i = ",i);
//Alert("tempo para 'StringAdd(c,b)' = ",(stop-start)," milissegundos, i = ",i);

//--- terceiro método
    start=GetTickCount();
    for(i=0; i<LIMITE; i++)
       {
        StringConcatenate(c, c, b);
       }
    stop=GetTickCount();
    Print("tempo para 'StringConcatenate(c,b)' = ",(stop-start)," milissegundos, i = ",i);
//Alert("tempo para 'StringConcatenate(c,b)' = ",(stop-start)," milissegundos, i = ",i);




    string n;  // declaracao sem valor atribui NULL a 'n' e 'n' eh diferente de ""
    Print("\nstring n;");
    Print("n == NULL : ", n == NULL);
    Print("n == \"\" : ", n == "");

    string x = NULL;
    Print("\nstring x = NULL;");  // declaracao com atribuicao a NULL tambem torna 'n' diferente de ""
    Print("x == NULL : ", x == NULL);
    Print("x == \"\" : ", x == "");

    string y = NULL;  // declaracao com atribuicao a NULL torna 'y' igual a qualquer outra variavel com NULL
    Print("\nstring y = NULL;");
    Print("y == x : ", y == x);

    string z = "";  // declaracao com atribuicao a "" torna 'z' diferente de NULL ou qualquer outra varivel com NULL
    Print("\nstring z = \"\";");
    Print("z == NULL : ", z == NULL);
    Print("z == \"\" : ", z == "");
    Print("z == n : ", z == n);
    Print("z == x : ", z == x);

    Print("\n StringGetCharacter(CASA, 0) = ", StringGetCharacter("CASA", 0));
    Print(StringGetCharacter("CASA", 0) == 'C');

// --- TESTES DO BR-EVE:
    string str = "  valor qualquer  ";
    Print("\nstring str = \"  valor qualquer  \";");
    Print("isEmpty(str) = ", isEmpty(str));
    Print("Apos isEmpty(str), str = .", str, ".");
    Print("Trim(str) = .", Trim(str),".");
    Print("Apos Trim(str), str = .", str, ".");

    string val;
    Print("\nstring val;");
    Print("isEmpty(val) = ", isEmpty(val));

    string valn = NULL;
    Print("\nstring valn = NULL;");
    Print("isEmpty(valn) = ", isEmpty(valn));




//    LIMITE = 10000000;
//    bool teste = true;
//
//    ulong ms = GetMicrosecondCount();
//    for(i=0; i < LIMITE; i++)
//       {
//        teste |= StringLen(str) == 0;
//       }
//    Print("GetMicrosecondCount() = ", GetMicrosecondCount() - ms);
//
//    teste = true;
//
//    ms = GetMicrosecondCount();
//    for(i=0; i < LIMITE; i++)
//       {
//        teste |= (str == "");
//       }
//    Print("GetMicrosecondCount() = ", GetMicrosecondCount() - ms);











//---
    return(INIT_SUCCEEDED);
   }




















//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
//---

   }


//+------------------------------------------------------------------+
