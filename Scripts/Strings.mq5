//+------------------------------------------------------------------+
//|                                                      Strings.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() 
{
    //---
   long length=10000; 
   string a="a",b="b",c; 
//--- primeiro método 
   uint start=GetTickCount(),stop; 
   long i; 
   c = a;
   for(i=0;i<length;i++) 
   { 
      c += b; 
   } 
   stop=GetTickCount(); 
   Print("tempo para 'c += b' = ",(stop-start)," milissegundos, i = ",i); 
  
//--- segundo método 
   start=GetTickCount(); 
   c = a;
   for(i=0;i<length;i++) 
   { 
      StringAdd(c,b); 
   } 
   stop=GetTickCount(); 
   Print("tempo para 'StringAdd(c,b)' = ",(stop-start)," milissegundos, i = ",i); 
  
//--- terceiro método 
   start=GetTickCount(); 
   for(i=0;i<length;i++) 
   { 
      StringConcatenate(c, c, b); 
   } 
   stop=GetTickCount(); 
   Print("tempo para 'StringConcatenate(c,b)' = ",(stop-start)," milissegundos, i = ",i); 
}

//+------------------------------------------------------------------+
