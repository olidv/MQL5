//+------------------------------------------------------------------+
//|                                                    LivroMQL5.mq5 |
//|                              Copyright 2021, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

MqlRates velas[];
MqlTick tick;

//--- Media Movel
int mm_Handle; // Handle controlador da media movel
double mm_Buffer[]; // Buffer para armazenamento dos dados das medias

//--- IFR
int ifr_Handle; // Handle controlador da media movel
double ifr_Buffer[]; // Buffer para armazenamento dos dados das medias


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   //--- create timer
   //EventSetTimer(2); // a cada 2 segundos a função OnTimer() será chamada
   
   //--- Media Movel
   mm_Handle = iMA(_Symbol, _Period, 7, 0, MODE_SMA, PRICE_CLOSE);

   //--- IFR
   ifr_Handle = iRSI(_Symbol, _Period, 3, PRICE_CLOSE);

   if (mm_Handle < 0 || ifr_Handle < 0) {
      Alert("Erro ao tentar criar Handles para o indicador - erro: ", GetLastError(), "!");
      return(INIT_FAILED); // -1
   }
   
   // Para adicionar no gráfico os indicadores:
   ChartIndicatorAdd(0, 0, mm_Handle);
   ChartIndicatorAdd(0, 1, ifr_Handle);
   
   //---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   //---
   // Copiar um vetor de tamanho tres para o vetor 
   CopyBuffer(mm_Handle, 0, 0, 3, mm_Buffer);
   CopyBuffer(ifr_Handle, 0, 0, 3, ifr_Buffer);
   
   // Ordenar os vetores de dados:
   ArraySetAsSeries(mm_Buffer, true);
   ArraySetAsSeries(ifr_Buffer, true);
   
   Print("mm_Buffer = ", mm_Buffer[0]);
   Print("mm_Buffer = ", ifr_Buffer[0]);
   Print("==================================");
  }

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   // Carrega na variável velas 10 posições com os preços:
   CopyRates(_Symbol, _Period, 0, 10, velas);

   // Ordenar o vetor de 10 posições de modo a posição 0 ser o preço atual
   ArraySetAsSeries(velas, true);
   
   // Fazer o apontamento da variável tick como informações do ativo atual
   SymbolInfoTick(_Symbol, tick);

   Comment("Tick último negócio = " + DoubleToString(tick.last, 2) + "\n" +
           "Tick tempo = " + TimeToString(tick.time));

    //Alert("ok","tudo bem"," ponto final");
    
   int pos = 0; // escolher posicao das velas
   
   //---
   Print("Preço Open = ", velas[0].open);
   Print("Preço Max = ", velas[0].high);
   Print("Preço Close = ", velas[0].close);
   Print("Preço Min = ", velas[0].low);
   
   Print("Tick último negócio = ", tick.last);
   Print("Tick tempo = ", tick.time);

   Print("==================================");
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   //--- destroy timer
   //EventKillTimer();
   
   // remove os indicadores ao retirar o EA
   IndicatorRelease(mm_Handle);
   IndicatorRelease(ifr_Handle);
  }

//+------------------------------------------------------------------+
