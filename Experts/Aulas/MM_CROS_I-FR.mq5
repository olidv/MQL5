//+------------------------------------------------------------------+
//|                                                 MM_CROS_I-FR.mq5 |
//|                              Copyright 2021, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

#property indicator_color3  clrBlue


//+------------------------------------------------------------------+
//| TIPOS E CONSTANTES                                               |
//+------------------------------------------------------------------+
enum ESTRATEGIA_ENTRADA
   {
    APENAS_MM,   // Apenas Médias Móveis
    APENAS_IFR,  // Apenas IFR
    MM_E_IFR     // Médias Móveis & IFR
   };


//+------------------------------------------------------------------+
//| VARIAVEIS INPUT                                                  |
//+------------------------------------------------------------------+
sinput string s0; //---------- Estratégia de Entrada ----------
input ESTRATEGIA_ENTRADA   estrategia      = APENAS_MM;     // Estratégia de Entrada Trader

sinput string s1; //---------- Médias Móveis ----------
input int mm_rapida_periodo                = 12;            // Período Média Rápida
input int mm_lenta_periodo                 = 32;            // Período Média Lenta
input ENUM_TIMEFRAMES mm_tempo_grafico     = PERIOD_CURRENT;// Tempo Gráfico
input ENUM_APPLIED_PRICE mm_preco          = PRICE_CLOSE;   // Preço Aplicado
input ENUM_MA_METHOD  mm_metodo            = MODE_EMA;      // Método

sinput string s2; //---------- IFR ----------
input int ifr_periodo                      = 5;             // Período IFR
input ENUM_TIMEFRAMES ifr_tempo_grafico    = PERIOD_CURRENT;// Tempo Gráfico
input ENUM_APPLIED_PRICE ifr_preco         = PRICE_CLOSE;   // Preço Aplicado
input int ifr_sobrecompra                  = 70;            // Nível de Sobrecompra
input int ifr_sobrevenda                   = 30;            // Nível de Sobrevenda

sinput string s3; //------------------------------
input int num_lots                         = 100;           // Número de Lotes
input double TK                            = 40;            // Take Profit
input double SL                            = 10;            // Stop Loss

sinput string s4; //------------------------------
input string hora_limite_fecha_op          = "17:40";       // Horário Limite Fechar Posição


//+------------------------------------------------------------------+
//| VARIAVEIS PARA OS INDICADORES                                    |
//+------------------------------------------------------------------+
//--- Medias Moveis
// RAPIDA - menor periodo
int mm_rapida_Handle;      // Handle controlador da media movel rapida
double mm_rapida_Buffer[]; // Buffer par armazenamento dos dados das medias

// LENTA - maior periodo
int mm_lenta_Handle;       // Handle controlador da media movel lenta
double mm_lenta_Buffer[];  // Buffer para armazenamento dos dados das medias

//--- IFR
int ifr_Handle;            // Handle controlador para o IFR
double ifr_Buffer[];       // Buffer para armazenamento dos dados do IFR


//+------------------------------------------------------------------+
//| VARIAVEIS PARA AS FUNCOES                                        |
//+------------------------------------------------------------------+
int magic_number = 123456;   // No. magico do robo

MqlRates velas[];            // Variavel para armazenar velas
MqlTick tick;                // Variavel para armazenar ticks


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
//---
    mm_rapida_Handle = iMA(_Symbol, mm_tempo_grafico, mm_rapida_periodo, 0, mm_metodo, mm_preco);
    mm_lenta_Handle = iMA(_Symbol, mm_tempo_grafico, mm_lenta_periodo, 0, mm_metodo, mm_preco);

    ifr_Handle = iRSI(_Symbol, ifr_tempo_grafico, ifr_periodo, ifr_preco);

    if(mm_rapida_Handle < 0 || mm_lenta_Handle < 0 || ifr_Handle < 0)
       {
        Alert("Erro ao tentar criar Handles para o indicador - erro: ", GetLastError(), "!");
        return(INIT_FAILED);
       }

// Para adicionar ao grafico os indicadores:
    ChartIndicatorAdd(0, 0, mm_rapida_Handle);
    ChartIndicatorAdd(0, 0, mm_lenta_Handle);
    ChartIndicatorAdd(0, 1, ifr_Handle);

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
// Copiar um vetor de dados tamanho tres para o vetor mm_buffer
    CopyBuffer(mm_rapida_Handle, 0, 0, 4, mm_rapida_Buffer);
    CopyBuffer(mm_lenta_Handle, 0, 0, 4, mm_lenta_Buffer);

    CopyBuffer(ifr_Handle, 0, 0, 4, ifr_Buffer);

//--- Alimentar Buffers das velas com dados:
    CopyRates(_Symbol, _Period, 0, 4, velas);
    ArraySetAsSeries(velas, true);

// Ordenar o vetor de dados:
    ArraySetAsSeries(mm_rapida_Buffer, true);
    ArraySetAsSeries(mm_lenta_Buffer, true);
    ArraySetAsSeries(ifr_Buffer, true);

//--- Alimentar com dados variaveis de tick
    SymbolInfoTick(_Symbol, tick);

// LOGICA PARA ATIVAR COMPRA:
    bool compra_mm_cros = mm_rapida_Buffer[0] > mm_lenta_Buffer[0] &&
                          mm_rapida_Buffer[2] < mm_lenta_Buffer[2];

    bool compra_ifr = ifr_Buffer[0] <= ifr_sobrevenda;

// LOGICA PARA ATIVAR VENDA:
    bool venda_mm_cros = mm_lenta_Buffer[0] > mm_rapida_Buffer[0] &&
                         mm_lenta_Buffer[2] < mm_rapida_Buffer[2];

    bool venda_ifr = ifr_Buffer[0] >= ifr_sobrecompra;

//---
    bool Comprar = false;  // Pode comprar?
    bool Vender  = false;  // Pode vender?

    if(estrategia == APENAS_MM)
       {
        Comprar = compra_mm_cros;
        Vender  = venda_mm_cros;
       }
    else
        if(estrategia == APENAS_IFR)
           {
            Comprar = compra_ifr;
            Vender  = venda_ifr;
           }
        else
           {
            Comprar = compra_mm_cros && compra_ifr;
            Vender  = venda_mm_cros && venda_ifr;
           }

// Toda vez que existir uma nova vela entrar nesse 'if'
    if(TemosNovaVela())
       {
        // Condicao de compra:
        if(Comprar && PositionSelect(_Symbol) == false)
           {
            desenhaLinhaVertical("Compra", velas[1].time, clrBlue);
            CompraAMercado();

           }

        // Condicao de Venda:
        if(Vender && PositionSelect(_Symbol) == true)
           {
            desenhaLinhaVertical("Venda", velas[1].time, clrRed);
            VendaAMercado();
           }
       }

// Fechar posicoes apos horario limite:
    if(TimeToString(TimeCurrent(), TIME_MINUTES) == hora_limite_fecha_op && PositionSelect(_Symbol) == true)
       {
        Print("-----> Fim do tempo operacional: encerrar posições abertas!");

        if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
           {
            FechaCompra();
           }
        else
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
               {
                FechaVenda();
               }

       }


   }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| FUNCOES PARA AUXILIAR NA VISUALIZACAO DA ESTRATEGIA              |
//+------------------------------------------------------------------+
void desenhaLinhaVertical(string nome, datetime dt, color cor = clrAliceBlue)
   {
    ObjectDelete(0, nome);
    ObjectCreate(0, nome, OBJ_VLINE, 0, dt, 0);
    ObjectSetInteger(0, nome, OBJPROP_COLOR, cor);
   }


//+------------------------------------------------------------------+
//| FUNCOES PARA ENVIO DE ORDENS                                     |
//+------------------------------------------------------------------+
bool CompraAMercado()
   {
    MqlTradeRequest requisicao; // requisicao
    MqlTradeResult  resposta;   // resposta

    ZeroMemory(requisicao);
    ZeroMemory(resposta);

//--- Caracteristicas da ordem de Compra:
    requisicao.action       = TRADE_ACTION_DEAL;                              // Executa ordem a mercado
    requisicao.magic        = magic_number;                                   // Nº magico da ordem
    requisicao.symbol       = _Symbol;                                        // Simbolo do ativo
    requisicao.volume       = num_lots;                                       // Nº de lotes
    requisicao.price        = NormalizeDouble(tick.ask, _Digits);             // Preço para a compra
    requisicao.sl           = NormalizeDouble(tick.ask - SL*_Point, _Digits); // Preço Stop Loss
    requisicao.tp           = NormalizeDouble(tick.ask + TK*_Point, _Digits); // Preço Take Profit (Alvo de Ganho)
    requisicao.deviation    = 0;                                              // Desvio permitido do preço
    requisicao.type         = ORDER_TYPE_BUY;                                 // Tipo da ordem
    requisicao.type_filling = ORDER_FILLING_FOK;                              // Tipo de preenchimento da ordem

//---
    if(! OrderSend(requisicao, resposta))
       {
        Print("Erro ao enviar Ordem de Compra. Erro = ", GetLastError());
        ResetLastError();
        return false;
       }

//---
    if(resposta.retcode == 10008     // 10008 TRADE_RETCODE_PLACED Ordem colocada
       || resposta.retcode == 10009)   // 10009 TRADE_RETCODE_DONE Solicitação concluída
       {
        Print("Ordem de Compra executada com sucesso!");

       }
    else
       {
        Print("Erro ao enviar Ordem de Compra. Erro = ", GetLastError());
        ResetLastError();
        return false;
       }

//---
    return true;
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VendaAMercado()
   {
    MqlTradeRequest requisicao; // requisicao
    MqlTradeResult  resposta;   // resposta

    ZeroMemory(requisicao);
    ZeroMemory(resposta);

//--- Caracteristicas da ordem de Venda:
    requisicao.action       = TRADE_ACTION_DEAL;                              // Executa ordem a mercado
    requisicao.magic        = magic_number;                                   // Nº magico da ordem
    requisicao.symbol       = _Symbol;                                        // Simbolo do ativo
    requisicao.volume       = num_lots;                                       // Nº de lotes
    requisicao.price        = NormalizeDouble(tick.bid, _Digits);             // Preço para a compra
    requisicao.sl           = NormalizeDouble(tick.bid + SL*_Point, _Digits); // Preço Stop Loss
    requisicao.tp           = NormalizeDouble(tick.bid - TK*_Point, _Digits); // Preço Take Profit (Alvo de Ganho)
    requisicao.deviation    = 0;                                              // Desvio permitido do preço
    requisicao.type         = ORDER_TYPE_SELL;                                // Tipo da ordem
    requisicao.type_filling = ORDER_FILLING_FOK;                              // Tipo de preenchimento da ordem

//---
    if(! OrderSend(requisicao, resposta))
       {
        Print("Erro ao enviar Ordem de Venda. Erro = ", GetLastError());
        ResetLastError();
        return false;
       }

//---
    if(resposta.retcode == 10008     // 10008 TRADE_RETCODE_PLACED Ordem colocada
       || resposta.retcode == 10009)   // 10009 TRADE_RETCODE_DONE Solicitação concluída
       {
        Print("Ordem de Venda executada com sucesso!");

       }
    else
       {
        Print("Erro ao enviar Ordem de Venda. Erro = ", GetLastError());
        ResetLastError();
        return false;
       }

//---
    return true;
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FechaCompra()
   {
    MqlTradeRequest requisicao; // requisicao
    MqlTradeResult  resposta;   // resposta

    ZeroMemory(requisicao);
    ZeroMemory(resposta);

//--- Caracteristicas da ordem de Venda:
    requisicao.action       = TRADE_ACTION_DEAL;                              // Executa ordem a mercado
    requisicao.magic        = magic_number;                                   // Nº magico da ordem
    requisicao.symbol       = _Symbol;                                        // Simbolo do ativo
    requisicao.volume       = num_lots;                                       // Nº de lotes
    requisicao.price        = 0;                                              // Indica fechamento da ordem
    requisicao.type         = ORDER_TYPE_SELL;                                // Tipo da ordem
    requisicao.type_filling = ORDER_FILLING_RETURN;                           // Tipo de preenchimento da ordem

//---
    if(! OrderSend(requisicao, resposta))
       {
        Print("Erro ao enviar Ordem para Fechamento da Compra. Erro = ", GetLastError());
        ResetLastError();
        return false;
       }

//---
    if(resposta.retcode == 10008     // 10008 TRADE_RETCODE_PLACED Ordem colocada
       || resposta.retcode == 10009)   // 10009 TRADE_RETCODE_DONE Solicitação concluída
       {
        Print("Ordem para Fechamento da Compra executada com sucesso!");

       }
    else
       {
        Print("Erro ao enviar Ordem para Fechamento da Compra. Erro = ", GetLastError());
        ResetLastError();
        return false;
       }

//---
    return true;
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FechaVenda()
   {
    MqlTradeRequest requisicao; // requisicao
    MqlTradeResult  resposta;   // resposta

    ZeroMemory(requisicao);
    ZeroMemory(resposta);

//--- Caracteristicas da ordem de Compra:
    requisicao.action       = TRADE_ACTION_DEAL;                              // Executa ordem a mercado
    requisicao.magic        = magic_number;                                   // Nº magico da ordem
    requisicao.symbol       = _Symbol;                                        // Simbolo do ativo
    requisicao.volume       = num_lots;                                       // Nº de lotes
    requisicao.price        = 0;                                              // Indica o fechamento da ordem
    requisicao.type         = ORDER_TYPE_BUY;                                 // Tipo da ordem
    requisicao.type_filling = ORDER_FILLING_RETURN;                           // Tipo de preenchimento da ordem

//---
    if(! OrderSend(requisicao, resposta))
       {
        Print("Erro ao enviar Ordem para Fechamento da Venda. Erro = ", GetLastError());
        ResetLastError();
        return false;
       }

//---
    if(resposta.retcode == 10008     // 10008 TRADE_RETCODE_PLACED Ordem colocada
       || resposta.retcode == 10009)   // 10009 TRADE_RETCODE_DONE Solicitação concluída
       {
        Print("Ordem para Fechamento da Venda executada com sucesso!");

       }
    else
       {
        Print("Erro ao enviar Ordem para Fechamento da Venda. Erro = ", GetLastError());
        ResetLastError();
        return false;
       }

//---
    return true;
   }


//+------------------------------------------------------------------+
//| FUNCOES UTEIS                                                    |
//+------------------------------------------------------------------+
//--- Para Mudança de Candle
bool TemosNovaVela()
   {
//--- memoriza o tempo de abertura da ultima barra (vela) numa variavel
    static datetime last_time = 0;

//--- tempo atual
    datetime lastbar_time = (datetime) SeriesInfoInteger(Symbol(), Period(), SERIES_LASTBAR_DATE);

//--- se for a primeira chamada da funcao:
    if(last_time == 0)
       {
        //--- atribuir valor temporal e sair
        last_time = lastbar_time;
        return false;
       }

//--- se o tempo estiver diferente:
    if(last_time != lastbar_time)
       {
        //--- memorizar esse tempo e retornar true
        last_time = lastbar_time;
        return true;
       }

//--- se passarmos desta linha, entao a barra não é nova; retornar false
    return false;
   }

//+------------------------------------------------------------------+
