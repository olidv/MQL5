//+------------------------------------------------------------------+
//|                                              Coaching_EA_POO.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    //--- create timer
    EventSetTimer(60);
   
    //---
    return(INIT_SUCCEEDED);
}
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- destroy timer
    EventKillTimer();
   
}
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
    //---
    mae.NomeMae = "";
    //avoh.
    //filha.
}
  
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {
    //---
   
}
  
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade() {
    //---
   
}
  
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result) {
    //---
   
}
  
//+------------------------------------------------------------------+
//| BookEvent function                                               |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol) {
    //---
   
}
  
//+------------------------------------------------------------------+
//| HERANÇA: CLASSE AVOH                                             |
//+------------------------------------------------------------------+
class CGrandMa {

  private:
      
  protected:
  
  public:
    string IdadeAvoh;
    string NomeAvoh;
    
    CGrandMa(void);  // construtor da classe (opcional)

    ~CGrandMa(void);  // destrutor da classe (opcional)

    double SaldoEmContaAvoh(void);
    
};

CGrandMa::CGrandMa(void) {
}

CGrandMa::~CGrandMa(void) {
}

double CGrandMa::SaldoEmContaAvoh(void) {
    return (0.0);
}

CGrandMa avoh;

  
//+------------------------------------------------------------------+
//| CLASSE MAE                                                       |
//+------------------------------------------------------------------+
class CMother : public CGrandMa {

  private:
      
  protected:
  
  public:
    string IdadeMae;
    string NomeMae;
    
    CMother(void);  // construtor da classe (opcional)

    ~CMother(void);  // destrutor da classe (opcional)

    double SaldoEmContaMae(void);
    
};

CMother::CMother(void) {
}

CMother::~CMother(void) {
}

double CMother::SaldoEmContaMae(void) {
    return (0.0);
}

CMother mae;

//+------------------------------------------------------------------+
//| CLASSE PAI                                                       |
//+------------------------------------------------------------------+
class CFather {

  private:
    string IdadePai;
      
  protected:
  
  public:
    string NomePai;
    
    CFather();  // construtor da classe (opcional)

    ~CFather();  // destrutor da classe (opcional)
    
};

CFather::CFather() {
}

CFather::~CFather() {
}

CFather pai;

//+------------------------------------------------------------------+
//| CLASSE FILHO DA MAE                                              |
//+------------------------------------------------------------------+
class CSon : public CMother {

  private:
      
  protected:
  
  public:
    string NomeFilho;
    int IdadeFilho;
    
    CSon();  // construtor da classe (opcional)

    ~CSon();  // destrutor da classe (opcional)

    double SaldoEmContaFilho();
    
};

CSon::CSon() {
}

CSon::~CSon() {
}

double CSon::SaldoEmContaFilho() {
    return (0.0);
}

CSon filho;

//+------------------------------------------------------------------+
//| CLASSE FILHA DO PAI                                              |
//+------------------------------------------------------------------+
class CDaughter : public CMother {

  private:
      
  protected:
  
  public:
    string IdadeFilha;
    string NomeFilha;
    
    CDaughter();  // construtor da classe (opcional)

    ~CDaughter();  // destrutor da classe (opcional)

    double SaldoEmContaFilha();    
};

CDaughter::CDaughter() {
}

CDaughter::~CDaughter() {
}

double CDaughter::SaldoEmContaFilha() {
    return (0.0);
}

CDaughter filha;

//+------------------------------------------------------------------+
