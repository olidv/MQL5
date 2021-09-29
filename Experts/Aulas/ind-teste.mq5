//+------------------------------------------------------------------+
//|                                                  MM_CROS_IFR.mq5 |
//|                                                  Copyright 2018. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "rafaelfvcs. Copyright 2018."
#property link      "https://www.mql5.com"
#property version   "1.00"
//---
//-------------------------------------------------------------------+
// Atenção: EA para fins APENAS didáticos!
// Isso aqui não confere orientação e/ou sugestão de investimentos!
// O autor não se responsabilizar pelo uso indevido deste material 
//-------------------------------------------------------------------+

// Meus cursos - https://linktr.ee/rafaelfvcs

enum ESTRATEGIA_ENTRADA
  {
   APENAS_MM,  // Apenas Médias Móveis
   APENAS_IFR, // Apenas IFR
   MM_E_IFR    // Médias mais IFR
  };

//---
// Variáveis Input
sinput string s0; //-----------Estratégia de Entrada-------------
input ESTRATEGIA_ENTRADA   estrategia      = APENAS_MM;     // Estratégia de Entrada Trader

sinput string s1; //-----------Médias Móveis-------------
input int mm_rapida_periodo                = 12;            // Periodo Média Rápida
input int mm_lenta_periodo                 = 32;            // Periodo Média Lenta
input ENUM_TIMEFRAMES mm_tempo_grafico     = PERIOD_CURRENT;// Tempo Gráfico
input ENUM_MA_METHOD  mm_metodo            = MODE_EMA;      // Método 
input ENUM_APPLIED_PRICE  mm_preco         = PRICE_CLOSE;   // Preço Aplicado

sinput string s2; //-----------IFR-------------
input int ifr_periodo                      = 5;             // Período IFR
input ENUM_TIMEFRAMES ifr_tempo_grafico    = PERIOD_CURRENT;// Tempo Gráfico  
input ENUM_APPLIED_PRICE ifr_preco         = PRICE_CLOSE;   // Preço Aplicado

input int ifr_sobrecompra                  = 70;            // Nível de Sobrecompra
input int ifr_sobrevenda                   = 30;            // Nível de Sobrevenda

sinput string s3; //-----------Risco-----------
input int num_lots                         = 100;           // Número de Lotes
input double TK                            = 60;            // Take Profit
input double SL                            = 30;            // Stop Loss

sinput string s4; //----------Horário----------
input string hora_limite_fecha_op          = "17:40";       // Horário Limite Fechar Posição 

//+------------------------------------------------------------------+
//|  Variáveis para os indicadores                                   |
//+------------------------------------------------------------------+
//--- Médias Móveis
// RÁPIDA - menor período
int mm_rapida_Handle;      // Handle controlador da média móvel rápida
double mm_rapida_Buffer[4]; // Buffer para armazenamento dos dados das médias

// LENTA - maior período
int mm_lenta_Handle;      // Handle controlador da média móvel lenta
double mm_lenta_Buffer[4]; // Buffer para armazenamento dos dados das médias

//--- IFR
int ifr_Handle;           // Handle controlador para o IFR
double ifr_Buffer[4];      // Buffer para armazenamento dos dados do IFR

//+------------------------------------------------------------------+
//| Variáveis para as funçoes                                        |
//+------------------------------------------------------------------+

int magic_number = 123456;   // Nº mágico do robô

MqlRates velas[4];            // Variável para armazenar velas
MqlTick tick;                // variável para armazenar ticks 

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   mm_rapida_Handle = iMA(_Symbol,mm_tempo_grafico,mm_rapida_periodo,0,mm_metodo,mm_preco);
   mm_lenta_Handle  = iMA(_Symbol,mm_tempo_grafico,mm_lenta_periodo,0,mm_metodo,mm_preco);
   
   ifr_Handle = iRSI(_Symbol,ifr_tempo_grafico,ifr_periodo,ifr_preco);
   
   if(mm_rapida_Handle<0 || mm_lenta_Handle<0 || ifr_Handle<0)
     {
      Alert("Erro ao tentar criar Handles para o indicador - erro: ",GetLastError(),"!");
      return(-1);
     }
   
   CopyRates(_Symbol,_Period,0,4, velas);
   //ArraySetAsSeries(velas,true);

   Print("CopyRates(velas) + ArraySetAsSeries() OnInit(): ");
   ArrayPrint(velas);
   Print("------------------------------------------------------------------\n");

   
   // Para adicionar no gráfico o indicador:
   //ChartIndicatorAdd(0,0,mm_rapida_Handle); 
   //ChartIndicatorAdd(0,0,mm_lenta_Handle);
   //ChartIndicatorAdd(0,1,ifr_Handle);
   //---
  
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   IndicatorRelease(mm_rapida_Handle);
   IndicatorRelease(mm_lenta_Handle);
   IndicatorRelease(ifr_Handle);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
/*
    Print("TICK_FLAG_BID – ", TICK_FLAG_BID);       //  2
    Print("TICK_FLAG_ASK  – ", TICK_FLAG_ASK);      //  4
    Print("TICK_FLAG_LAST – ", TICK_FLAG_LAST);     //  8
    Print("TICK_FLAG_VOLUME – ", TICK_FLAG_VOLUME); // 16
    Print("TICK_FLAG_BUY – ", TICK_FLAG_BUY);       // 32
    Print("TICK_FLAG_SELL – ", TICK_FLAG_SELL);     // 64
*/
    // Copiar um vetor de dados tamanho três para o vetor mm_Buffer
    CopyBuffer(mm_rapida_Handle,0,0,4,mm_rapida_Buffer);
    //ArraySetAsSeries(mm_rapida_Buffer,true);

    Print("CopyBuffer(mm_rapida_Buffer) + ArraySetAsSeries() OnTick(): ");
    ArrayPrint(mm_rapida_Buffer);

    CopyBuffer(mm_lenta_Handle,0,0,4,mm_lenta_Buffer);
    //ArraySetAsSeries(mm_lenta_Buffer,true);
    Print("CopyBuffer(mm_lenta_Buffer) + ArraySetAsSeries() OnTick(): ");
    ArrayPrint(mm_lenta_Buffer);
    
    CopyBuffer(ifr_Handle,0,0,4,ifr_Buffer);
    //ArraySetAsSeries(ifr_Buffer,true);
    Print("CopyBuffer(ifr_Buffer) + ArraySetAsSeries() OnTick(): ");
    ArrayPrint(ifr_Buffer);
    
    //--- Alimentar Buffers das Velas com dados:
    CopyRates(_Symbol,_Period,0,4,velas);
    //ArraySetAsSeries(velas,true);

    Print("CopyRates(velas) + ArraySetAsSeries() OnInit(): ");
    ArrayPrint(velas);
    Print("------------------------------------------------------------------\n");

    // Alimentar com dados variável de tick
    SymbolInfoTick(_Symbol,tick);
   
  }
