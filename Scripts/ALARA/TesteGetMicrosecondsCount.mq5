//+------------------------------------------------------------------+
//|                                    TesteGetMicrosecondsCount.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+ 
//| Teste da função                                                  | 
//+------------------------------------------------------------------+ 
void Test() 
  { 
   int    res_int=0; 
   double res_double=0; 
//---   
   for(int i=0;i<10000;i++) 
     { 
      res_int+=i*i; 
      res_int++; 
      res_double+=i*i; 
      res_double++; 
     } 
  } 
//+------------------------------------------------------------------+ 
//| Função de início do programa script                              | 
//+------------------------------------------------------------------+ 
void OnStart() 
  { 
   uint   ui=0,ui_max=0,ui_min=INT_MAX; 
   ulong  ul=0,ul_max=0,ul_min=INT_MAX; 
//--- número de medidas 
   for(int count=0;count<10000;count++) 
     { 
      uint  ui_res=0; 
      ulong ul_res=0; 
      //---  
      for(int n=0;n<2;n++) 
        { 
         //--- selecionar tipo de medida 
         if(n==0) ui=GetTickCount(); 
         else     ul=GetMicrosecondCount(); 
         //--- executar código  
         Test(); 
         //--- adicionar resultado da medida (dependendo do tipo) 
         if(n==0) ui_res+=GetTickCount()-ui; 
         else     ul_res+=GetMicrosecondCount()-ul;          
        } 
      //--- Calcular o tempo mínimo e máximo para ambas as medições 
      if(ui_min>ui_res) ui_min=ui_res; 
      if(ui_max<ui_res) ui_max=ui_res; 
      if(ul_min>ul_res) ul_min=ul_res; 
      if(ul_max<ul_res) ul_max=ul_res; 
     } 
//--- 
   Print("GetTickCount error(msec): ",ui_max-ui_min); 
   Print("GetMicrosecondCount error(msec): ",DoubleToString((ul_max-ul_min)/1000.0,2)); 
  }
  