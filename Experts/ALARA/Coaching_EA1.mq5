//+------------------------------------------------------------------+
//|                                                 Coaching_EA1.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+

// Em 1º lugar, as diretivas de pré-processamento: 
// Propriedades do programa
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"
#property description  ""

// inclusão de arquivos
// importação de bibliotecas

// definição de constantes

//+------------------------------------------------------------------+
//| INPUTS - PARÂMETROS EXTERNOS                                     |
//+------------------------------------------------------------------+
// As variáveis de entrada (input) vem em 2º lugar, 
// e então após os inputs vem o código fonte do EA.
//input int MaxTrades = 5;  // Máximo de Trades
//input int MA_Period = 30; // Período Média Móvel
// O editor muda a cor (vermelho) para destacar que é variável de entrada...

//+------------------------------------------------------------------+
//| VARIÁVEIS GLOBAIS: Em 3º lugar após variáveis de entrada/externa |
//+------------------------------------------------------------------+

//--- ARRAY = VETOR DE DADOS
// Todo vetor de dados (array) precisa ter: 
//double myArray[] = {2.5, 1.2, 3.7}; // 1) Tipo; 2) Identificador; 3) colchetes; 4) entre chaves os valores;

//+------------------------------------------------------------------+
//| ACESSO A DADOS NA LINGUAGEM MQL5                                 |
//+------------------------------------------------------------------+
//--- 1) Acesso a dados de preço (OHLC) : Funções ArraySetAsSeries()  CopyRates()
MqlRates candle[]; // candle do ativo corrente - os dados (preços) serão fornecidos pelo terminal.
MqlRates candlePETR[]; 

//--- 2) Acesso a dados de ticks : Função SymbolInfoTick()
MqlTick tick;

//--- 3) Acesso a dados de book : Funções MarketBookAdd()  MarketBookGet()  MarketBookRelease()
MqlBookInfo book[]; // ** além da estrutura, precisa de um array para os dados.

//--- 4) Acesso a dados de indicadores : 
// Todo indicador precisa de um (1) handle (sempre inteiro), (2) buffers (sempre double);
// Todo handle precisa ser do tipo int; é a fonte de dados - de onde obtém os dados;
// Todo buffer precisa ser do tipo double; é o vetor de dados propriamente - para onde copia os dados;
//--- Indicador Médias Móveis
int MA_Handle;
double MA_Buffer[];
//---
int MA_Handle2;
double MA_Buffer2[];

//--- Indicador Estocástico
int STO_Handle;  // 
double STO_SignalBuffer[];  // linha vermelha (sinal)
double STO_MainBuffer[];  // linha azul (estocástico)

//--- INDICADORES CUSTOMIZADOS
int     OZY_Handle;
double  OZY_ValueBuffer[];
double  OZY_ColorBuffer[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    //---
    //Print("Estamos dentro do corpo da função OnInit()");
    
    // Define o temporizador do robô:
    //EventSetTimer(2); // dispara OnTimer() a cada 2 segundos
    
    EventSetMillisecondTimer(250); // 4x por segundo
    // a precisão é de no mínimo 20milisegundos (após testes)

    // Inverter a indexação das variáveis de preço.
    // Faz aqui e apenas 1x, para todo o código.
    ArraySetAsSeries(candle, true); // true significa ordem reversa de indexação.
    ArraySetAsSeries(candlePETR, true); // para a cotação de PETR

    // É preciso abrir o acesso aos dados do book:
    MarketBookAdd(_Symbol); // Abertura da Profundidade de Mercado (DOM = Depth of Market)

    // Inicializar os handles conforme o respectivo indicador:
    MA_Handle = iMA(_Symbol, _Period, 30, 0, MODE_EMA, PRICE_CLOSE);
    ArraySetAsSeries(MA_Buffer, true);
    
    MA_Handle2 = iMA(_Symbol, _Period, 60, 0, MODE_SMA, PRICE_CLOSE);
    ArraySetAsSeries(MA_Buffer2, true);
    
    STO_Handle = iStochastic(_Symbol, _Period, 5, 3, 3, MODE_SMA, STO_LOWHIGH);
    ArraySetAsSeries(STO_MainBuffer, true);
    ArraySetAsSeries(STO_SignalBuffer, true);

    OZY_Handle = iCustom(_Symbol, _Period, "ozymandias_lite.ex5", 2, MODE_SMA, 0);
    ArraySetAsSeries(OZY_ValueBuffer, true);
    ArraySetAsSeries(OZY_ColorBuffer, true);
    
    // Neste evento os parâmetros já foram fornecidos pelo usuário...    
    //Print("O valor do parâmetro 1 é igual a ", MaxTrades);
    //Print("O valor do parâmetro 2 é igual a ", MA_Period);
    //Print("------------------------------------------");        
    
    //---
    return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //---
    //Print("Estamos dentro do corpo da função OnDeinit()");
   
    EventKillTimer();
    
    // Encerra a inscrição ao book de mercado (DOM)
    MarketBookRelease(_Symbol); // Tira da memória o espaço alocado.
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
    //--- contabiliza os ticks
    static long count = 0;
    //Print("OnTick() : ", ++count);
    
    //+------------------------------------------------------------------+
    //--- 2) Acesso a dados de ticks : Função SymbolInfoTick()
    
    SymbolInfoTick(_Symbol, tick);
    //Print("TICK  Hora: ", tick.time, " / Último Negócio: ", tick.last, " / Volume: ", tick.volume);

    // Teste para Análise de Tape Reading:
    if (tick.last == tick.ask) {  // Preço corrente de compra
        //Print("TICK  Atividade Compradora!");
    } else if (tick.last == tick.bid) {  // Preço corrente de venda
        //Print("TICK  Atividade Vendedora!");
    }
    
    //Print("------------------------------------------");        
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void OnTimer() {
    //---
    Print("Estamos dentro do corpo da função OnTimer()");

    //+------------------------------------------------------------------+
    //--- Acesso a dados de preço (OHLC) : Funções ArraySetAsSeries()  CopyRates()

    // CopyRates(Symbol(), Period(), ... -> usando funções
    CopyRates(_Symbol, _Period, 0, 5, candle); // usando variáveis de sistema
    CopyRates("PETR4", PERIOD_D1, 0, 5, candlePETR); // usando variáveis de sistema
    //Print("Máxima do candle atual: ", DoubleToString(candle[0].high, 5));

    //Print(_Symbol);
    //for (int i = 0; i < ArraySize(candle); i++)
        //Print("RATES[", i, "]  Open: ", candle[i].open, " / High: ", candle[i].high, " / Low: ", candle[i].low, " / Close: ", candle[i].close);

    //Print("------------------------------------------");        
    
    //Print("PETR4");
    //for (int i = 0; i < ArraySize(candlePETR); i++)
        //Print("RATES[", i, "]  Open: ", candlePETR[i].open, " / High: ", candlePETR[i].high, " / Low: ", candlePETR[i].low, " / Close: ", candlePETR[i].close);

    //Print("------------------------------------------");        
 
 
    //+------------------------------------------------------------------+
    //--- 4) Acesso a dados de indicadores
    
    //--- Indicadores com APENAS um buffer:
    CopyBuffer(MA_Handle, 0, 0, 5, MA_Buffer);
    CopyBuffer(MA_Handle2, 0, 0, 5, MA_Buffer2);
    
    //Print("Symbol: ", _Symbol, " Digits: ", _Digits);
    
    //Print("1º O valor da média móvel do candle corrente = ", NormalizeDouble(MA_Buffer[0], _Digits));
    //Print("1º O valor da média móvel do candle anterior = ", NormalizeDouble(MA_Buffer[1], _Digits), "\n");

    //Print("2º O valor atual da segunda média = ", NormalizeDouble(MA_Buffer2[0], _Digits));

    //Print("------------------------------------------");        

    //Print("iMA");
    //for (int i = 0; i < ArraySize(MA_Buffer); i++)
    //    Print("BUFFER[", i, "] : ", NormalizeDouble(MA_Buffer[i], _Digits));
   
    //Print("------------------------------------------");        

    //--- CRUZAMENTO DE MÉDIAS MÓVEIS
    
    // verifica se foi criada uma nova barra no gráfico:
    bool newBar = isNewBar(); // true se houver barra nova, falso se não houver sido criado.
    bool newM1Bar = isNewM1Bar(); // true se houver nova barra no tempo M1 (1 minuto).
    
    //if (newBar && MA_Buffer[2] < MA_Buffer2[2] && MA_Buffer[1] > MA_Buffer2[1]) {
    if (newBar && ! PositionSelect(_Symbol)) { // não pode enviar ordem se já tiver posição no ativo corrente 
        Print("SINAL DE COMPRA !!!!");
        
        //--- Setup de compra
        Print("Compra a mercado");
        
        // Envia ordem de compra.
        CompraAMercado();
        
    //} else {
    //    Print("SINAL DE VENDA !!!!");
    
        //--- TODO setup de venda 
        // Envia ordem de venda
        // VendaAMercado()  
    }
       
    //--- Verifica se já tem alguma posição anterior
    static bool ordemNaPedra = false;
    
    if (PositionSelect(_Symbol)) {
        //--- Realização parcial
        if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY && ! ordemNaPedra) {
            ordemNaPedra = true;
            // VendaPendente();
            
        } else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL && ! ordemNaPedra) {
            ordemNaPedra = true;
            CompraPendente();
        } 
    
    } else {  // nao há nenhuma posição anterior
        ordemNaPedra = false;
    }
       
    //Print("------------------------------------------");        


    //--- SETUP PARA CANCELAMENTO DE ORDEM
    int ordersTotal = OrdersTotal();  // retorna a quantidade atual de ordens pendentes

    // se ainda há ordens, mas não há posições...
    if (ordersTotal >= 1 && ! PositionSelect(_Symbol)) {  // então sofreu stop-loss
        
        //--- percorre em ordem reversa e cancela todas as ordens
        for (int i = ordersTotal - 1; i >= 0; i++) {
            ulong ticket = OrderGetTicket(i);
            CancelaOrdem(ticket);
        }
    }
       
    //Print("------------------------------------------");        
    
    //--- Indicadores com mais de um buffer:
    CopyBuffer(STO_Handle, 0, 0, 5, STO_MainBuffer);
    CopyBuffer(STO_Handle, 1, 0, 5, STO_SignalBuffer);
    
    //Print("Main: ", NormalizeDouble(STO_MainBuffer[0], _Digits), " / Signal: ", NormalizeDouble(STO_SignalBuffer[0], _Digits));

    //Print("------------------------------------------");        

    //--- Indicadores CUSTOMIZADOS:
    CopyBuffer(OZY_Handle, 0, 0, 5, OZY_ValueBuffer);
    CopyBuffer(OZY_Handle, 1, 0, 5, OZY_ColorBuffer);

    //Print("OZY Value: ", NormalizeDouble(OZY_ValueBuffer[1], _Digits), " / Color: ", NormalizeDouble(OZY_ColorBuffer[1], _Digits));
    //Print("OZY Value: ", NormalizeDouble(OZY_ValueBuffer[0], _Digits), " / Color: ", NormalizeDouble(OZY_ColorBuffer[0], _Digits));

    //Print("------------------------------------------");        
    
}

//+------------------------------------------------------------------+
//| Quando ocorre alteração no book de ofertas (DOM).                |
//+------------------------------------------------------------------+
void OnBookEvent(const string& symbol) {
    //--- Este evento possui maior precisão que eventos OnTimer() ou OnTick().

    //+------------------------------------------------------------------+
    //--- 3) Acesso a dados de book : Funções MarketBookAdd()  MarketBookGet()  MarketBookRelease()

    MarketBookGet(symbol, book);
    string ordem, tipo;
    for (int i = 0; i < ArraySize(book); i++) {
        ordem = i < 16 ? "VENDA" : "COMPRA";
        switch (book[i].type) {
            case BOOK_TYPE_SELL: tipo = "Ordem de venda (Offer)";break;
            case BOOK_TYPE_BUY: tipo = "Ordem de compra (Bid)";break;
            case BOOK_TYPE_SELL_MARKET: tipo = "Ordem de venda (Offer)";break;
            case BOOK_TYPE_BUY_MARKET: tipo = "Ordem de venda (Offer)";break;
        }
        
        //Print("BOOK ", ordem, "[", i, "]  Tipo: ", tipo, " / Price: ", book[i].price, " / Volume: ", book[i].volume, " / Volume Real: ", book[i].volume_real);
    }
    
    //Print("------------------------------------------");        
    
}

//+------------------------------------------------------------------+
//| Returns true if a new bar has appeared for a symbol/period pair  |
//+------------------------------------------------------------------+
bool isNewBar() {
    //--- memorize the time of opening of the last bar in the static variable
   static datetime last_time=0;
    //--- current time
   datetime lastbar_time = (datetime) SeriesInfoInteger(Symbol(),Period(),SERIES_LASTBAR_DATE);

    //--- if it is the first call of the function
   if(last_time==0) {
      //--- set the time and exit
      last_time=lastbar_time;
      return(false);
     }

    //--- if the time differs
   if(last_time!=lastbar_time) {
      //--- memorize the time and return true
      last_time=lastbar_time;
      return(true);
     }
    //--- if we passed to this line, then the bar is not new; return false
   return(false);
}

//+------------------------------------------------------------------+
//| Returns true if a new bar has appeared for a symbol/period pair  |
//+------------------------------------------------------------------+
bool isNewM1Bar() {
    //--- memorize the time of opening of the last bar in the static variable
   static datetime last_time=0;
    //--- current time
   datetime lastbar_time = (datetime) SeriesInfoInteger(Symbol(),PERIOD_M1,SERIES_LASTBAR_DATE);

    //--- if it is the first call of the function
   if(last_time==0) {
      //--- set the time and exit
      last_time=lastbar_time;
      return(false);
     }

    //--- if the time differs
   if(last_time!=lastbar_time) {
      //--- memorize the time and return true
      last_time=lastbar_time;
      return(true);
     }
    //--- if we passed to this line, then the bar is not new; return false
   return(false);
}

//+------------------------------------------------------------------+

void CompraAMercado() {
    //---
    MqlTradeRequest requisicao; //= {0};
    MqlTradeResult resposta; // = {0};
    
    // limpa variaveis do tipo structure, se nao for utilizado {0} na declaracao.
    //ZeroMemory(requisicao); 
    //ZeroMemory(resposta);

    //--- definir TODAS as caracteristicas da ordem:
    requisicao.action = TRADE_ACTION_DEAL;  // ordem a mercado
    requisicao.magic = 1234;  // número magico de identificação do robo (EA)
    //requisicao.order = ?;  // ticket da ordem (controle interno das ordens) - não é obrigatório
    requisicao.symbol = _Symbol;  // envia ordem para o ativo corrente
    requisicao.volume = 1;  // número de contratos (mini indice) ou ações (mercado a vista)
    requisicao.price = 0;  // ordem a mercado -> 0 = qualquer preço
    //requisicao.stoplimit = 0;  // usado em ordem do tipo stop - não usado na ordem a mercado
    requisicao.sl = tick.ask - 250;  // quando se deseja estipular o stop-loss, ou 0 caso contrário
                                     // para ordem de venda, usar o tick.bid (+ e -)
    requisicao.tp = tick.ask + 250;  // quando se deseja estipular o take profit, ou 0 caso contrário
    requisicao.deviation = 0;  // slippage da ordem, não considerado para ordem a mercado - 0 = não definido
    requisicao.type = ORDER_TYPE_BUY;  // Ordem de Comprar a Mercado
    //requisicao.type_filling = ORDER_FILLING_RETURN;  // leva o que está disponível no book e fica na pedra como melhor vendedor
                                                     // normalmente é o único disponível nas corretoras
    //requisicao.type_filling = ORDER_FILLING_IOC;  // soh leva o que está disponível no book - o resto será cancelado
    requisicao.type_filling = ORDER_FILLING_FOK;  // se não houver o volume total disponível, a ordem será cancelada (tudo ou nada)

    //--- envio da ordem
    ResetLastError();
    bool ok = OrderSend(requisicao, resposta); // envia a ordem para o servidor do MT5, que em seguida enviará à bolsa (para ficar na pedra)
    // verificacao de erro retornado pelo terminal
    if (ok) {  
        Print("A ordem foi corretamente ENVIADA para a corretora.");
                    
        //--- Tratamento da ordem com sucesso
        if (resposta.retcode == 10008 || resposta.retcode == 10009) {
            Print("Ordem corretamente executada / colocada !!! / retorno = ", resposta.retcode);
        
        } else { // identifica o erro ou status, do erro após enviar a ordem
                 // erro de execução retornado pelo servidor (ponta), ao tentar processar a ordem
            Print("Erro ao executar ordem. Erro : # ", GetLastError(), " / retorno = ", resposta.retcode);

            ExpertRemove(); // interrompe o robô
        }
    
    } else {  // verificacao de erro retornado pelo terminal, ao tentar enviar a ordem
        Print("Erro ao enviar ordem. Erro : # ", GetLastError());

        //--- 1) remover o expert advisor
        //--- 2) retry no envio da ordem
        //--- 3) enviar uma notificação / e-mail
        //--- 4) imprimir um alerta
        ExpertRemove(); // interrompe o robô
    }

    //--- TODO verificações de segurança
    
}

//+------------------------------------------------------------------+
//| COMPRA PENDENTE (deixar na pedra = Ordem Limitada)               |
//+------------------------------------------------------------------+
void CompraPendente() {

    MqlTradeRequest requisicao; // = {0};
    MqlTradeResult resposta; // = {0};
    
    // limpa variaveis do tipo structure, se nao for utilizado {0} na declaracao.
    //ZeroMemory(requisicao); 
    //ZeroMemory(resposta);


    //--- definir TODAS as caracteristicas da ordem:
    requisicao.action = TRADE_ACTION_PENDING;  // ordem limitada (coloca na pedra - book)
    requisicao.magic = 1234;  // número magico de identificação do robo (EA)
    //requisicao.order = ?;  // ticket da ordem (controle interno das ordens) - não é obrigatório
    requisicao.symbol = _Symbol;  // envia ordem para o ativo corrente
    requisicao.volume = 1;  // número de contratos (mini indice) ou ações (mercado a vista)
    requisicao.price = tick.ask - 50;  // ordem limitada -> preço não pode ser zerada
                                       // preço do melhor vendedor menos 50pts : recuando 50pts para NÃO executar a mercado
    //requisicao.stoplimit = 0;  // usado em ordem do tipo stop - não usado na ordem a mercado
    requisicao.sl = 0;  // quando se deseja estipular o stop-loss, ou 0 caso contrário
    requisicao.tp = 0;  // quando se deseja estipular o take profit, ou 0 caso contrário
    requisicao.deviation = 0;  // slippage da ordem, não considerado para ordem a mercado : 0 = não definido
    requisicao.type = ORDER_TYPE_BUY_LIMIT;  // Ordem Limitada de Compra
    requisicao.type_filling = ORDER_FILLING_RETURN;  // soh o tipo RETURN fica na pedra
    requisicao.type_time = ORDER_TIME_DAY;  // válida até o final do dia
    requisicao.expiration = 0;  // como é válida soh até o final do dia, não precisa da hora de expiração
    requisicao.comment = "Compra pendente";

    //--- envio da ordem
    ResetLastError();
    bool ok = OrderSend(requisicao, resposta); // envia a ordem para o servidor do MT5, que em seguida enviará à bolsa (para ficar na pedra)
    if (ok) {
        Print("A ordem foi corretamente ENVIADA para o servidor da corretora.");
                    
        //--- Tratamento da ordem com sucesso:
        // 10008 TRADE_RETCODE_PLACED  Ordem colocada         -> Para Ordens Limitadas ou Stop
        // 10009 TRADE_RETCODE_DONE    Solicitação concluída  -> Para Ordens a Mercado
        if (resposta.retcode == 10008 || resposta.retcode == 10009) {
            Print("Ordem corretamente executada / colocada !!! / retorno = ", resposta.retcode);

        // Quando o Tipo de Preenchimento = RETURN, o codigo abaixo nao eh erro. Apenas se nao foi previsto.
        // 10010 TRADE_RETCODE_DONE_PARTIAL  Somente parte da solicitação foi concluída  -> 
        
        } else { // identifica o erro ou status
            Print("Erro ao enviar ordem. Erro : # ", GetLastError(), " / retorno = ", resposta.retcode);

            ExpertRemove(); // interrompe o robô
        }
    
    } else {  // erro na execução
        Print("Erro ao enviar ordem. Erro : # ", GetLastError());

        //--- 1) remover o expert advisor
        //--- 2) retry no envio da ordem
        //--- 3) enviar uma notificação / e-mail
        //--- 4) imprimir um alerta
        ExpertRemove(); // interrompe o robô
    }

    //--- TODO verificações de segurança
}    

//--- TODO Venda Pendente

//+------------------------------------------------------------------+
//| CANCELA ORDEM                                                    |
//+------------------------------------------------------------------+
void CancelaOrdem(ulong ticket) {
    //--- o ticket da ordem pode ser consultado na coluna "Bilhete" da aba Histórico na Caixa de Ferramentas
    
    MqlTradeRequest requisicao; // = {0};
    MqlTradeResult resposta; // = {0};
    
    // limpa variaveis do tipo structure, se nao for utilizado {0} na declaracao.
    //ZeroMemory(requisicao); 
    //ZeroMemory(resposta);

    //--- definir TODAS as caracteristicas da ordem:
    requisicao.action = TRADE_ACTION_REMOVE;  // para cancelar a ordem 
    requisicao.order = ticket;

    //--- envio da ordem
    ResetLastError();
    bool ok = OrderSend(requisicao, resposta); // envia a ordem para o servidor do MT5
    if (ok) {
        Print("A ordem foi corretamente ENVIADA para a corretora.");
                    
        //--- Tratamento da ordem com sucesso
        if (resposta.retcode == 10008 || resposta.retcode == 10009) {
            Print("Ordem corretamente executada / colocada !!! / retorno = ", resposta.retcode);
        
        } else { // identifica o erro ou status
            Print("Erro ao enviar ordem. Erro : # ", GetLastError(), " / retorno = ", resposta.retcode);

            ExpertRemove(); // interrompe o robô
        }
    
    } else {  // erro na execução
        Print("Erro ao enviar ordem. Erro : # ", GetLastError());
        ExpertRemove(); // interrompe o robô
    }
}
