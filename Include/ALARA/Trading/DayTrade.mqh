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

//program file         DayTrade.mqh
//program package      MQL5/Include/ALARA/Trading/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include <Object.mqh>
#include <ALARA\BR_EvE.mqh>              // Funcoes utilitarias de uso geral (Enumerators e Evaluators).
#include <ALARA\Logging\LogManager.mqh>  // Funcoes para acesso, configuracao e registro de logging.

#include "OrderInfo.mqh"
#include "HistoryOrderInfo.mqh"
#include "PositionInfo.mqh"
#include "DealInfo.mqh"


//+------------------------------------------------------------------+
//---
#define ORDER_FILL_MODE  ORDER_FILLING_IOC
#define ORDER_DEVIATION  10
#define ORDER_EXPERT_ID  0


//+------------------------------------------------------------------+
//--- EX: Cria uma instancia da classe especificando o simbolo para trading:
//CDayTrade tradeDolar("WDOU22");


//+------------------------------------------------------------------+
//| Class CDayTrade.                                                 |
//|                                                                  |
//| Usage: Classe principal para gerenciamento e execucao da         |
//|        impressao/registro das mensagens de logging.              |
//+------------------------------------------------------------------+
class CDayTrade : public CObject
   {
private:
    //--- INFORMACOES SOBRE O ATIVO EM OPERACAO:
    string                   m_symbol;               // simbolo usado em todas as operacoes

    //--- CONFIGURACAO E PARAMETRIZACAO DO TRADING:
    bool                     m_async_mode;           // modo de envio das operacoes: sincrono (default) ou assincrono
    string                   m_order_func;           // descricao do tipo de funcao chamada: "OrderSendAsync" ou "OrderSend"
    ENUM_ORDER_TYPE_FILLING  m_type_filling;         // politica de preenchimento de volume: default = ORDER_FILLING_FOK
    ENUM_ORDER_TYPE_TIME     m_type_time;            // tempo de duracao de uma ordem
    ENUM_ACCOUNT_MARGIN_MODE m_margin_mode;          // tipo de mercado e forma de registrar as posicoes
    ulong                    m_deviation;            // deviation default
    ulong                    m_magic;                // expert magic number
    ulong                    m_latency_order;        // medida da latencia em microsegundos no envio de ordens.

    //--- ESTRUTURAS INTERNAS PARA REQUISICAO E RESULTADO DE ORDENS:
    MqlTradeRequest          m_request;              // request data
    MqlTradeResult           m_result;               // result data
    MqlTradeCheckResult      m_check_result;         // result check data

protected:
    //--- HELPERS: FUNCOES INTERNAS AUXILIARES:
    void              ClearStructures(void);
    bool              IsStopped(const string function);
    bool              SelectPosition(void);

    //--- TRANSACOES BASICAS DE COMPRA E VENDA, EM NIVEL MAIS BASICO:
    bool              SendOrder(const MqlTradeRequest &request,MqlTradeResult &result);

    bool              OrderInsert(const ENUM_ORDER_TYPE order_type,const double volume,const double price,
                                  const double stop_limit,const double sl,const double tp,const string comment);
    bool              OrderUpdate(const ulong ticket,const double sl,const double tp);
    bool              OrderUpdate(const ulong ticket,const double price,const double stop_limit,const double sl,const double tp);
    bool              OrderDelete(const ulong ticket);

public:
    //--- Construtor parametrico
                     CDayTrade(const string simbol);
    //--- Destrutor default
                    ~CDayTrade(void) {};

    //--- GETTERS E SETTERS PARA CONFIGURACAO E PARAMETRIZACAO DO TRADING:
    bool              IsNetting(void) const { return (m_margin_mode == ACCOUNT_MARGIN_MODE_RETAIL_NETTING); }
    bool              IsHedging(void) const { return (m_margin_mode == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING); }

    bool              isAsyncMode(void) const { return (m_async_mode == true); }
    void              SetAsyncMode(const bool mode = true) { m_async_mode = mode; m_order_func = mode ? "OrderSendAsync" : "OrderSend"; }

    void              SetTypeTime(const ENUM_ORDER_TYPE_TIME type_time) { m_type_time = type_time; }

    void              SetMarginMode(const ENUM_ACCOUNT_MARGIN_MODE mode) { m_margin_mode = mode; }
    void              SetMarginModeByAccount(void) { m_margin_mode = (ENUM_ACCOUNT_MARGIN_MODE) AccountInfoInteger(ACCOUNT_MARGIN_MODE); }

    void              SetDeviationInPoints(const ulong deviation) { m_deviation = deviation; }

    void              SetExpertMagicNumber(const ulong magic) { m_magic = magic; }

    void              SetTypeFilling(const ENUM_ORDER_TYPE_FILLING type_filling) { m_type_filling = type_filling; }
    bool              SetTypeFillingBySymbol(void);

    //--- OPERACOES DE COMPRA E VENDA DE ATIVOS, SEGUNDO NOMENCLATURA DO MERCADO:
    bool              Buy(const double volume,const double sl=NULL,const double tp=NULL,const string comment=NULL);
    bool              Sell(const double volume,const double sl=NULL,const double tp=NULL,const string comment=NULL);

    bool              BuyLimit(const double volume,const double price,const double sl=NULL,const double tp=NULL,const string comment=NULL);
    bool              SellLimit(const double volume,const double price,const double sl=NULL,const double tp=NULL,const string comment=NULL);

    bool              BuyStop(const double volume,const double price,const double sl=NULL,const double tp=NULL,const string comment=NULL);
    bool              SellStop(const double volume,const double price,const double sl=NULL,const double tp=NULL,const string comment=NULL);

    bool              BuyStopLimit(const double volume,const double price,const double stop_limit,const double sl=NULL,const double tp=NULL,const string comment=NULL);
    bool              SellStopLimit(const double volume,const double price,const double stop_limit,const double sl=NULL,const double tp=NULL,const string comment=NULL);

    //--- OPERACOES PARA MODIFICACAO E FECHAMENTO DE POSICOES DE NEGOCIACAO:
    bool              PositionModify(const double sl=NULL,const double tp=NULL);
    bool              PositionModify(const double price=NULL,const double stop_limit=NULL,const double sl=NULL,const double tp=NULL);

    bool              PositionModify(const ulong ticket,const double sl=NULL,const double tp=NULL);
    bool              PositionModify(const ulong ticket,const double price=NULL,const double stop_limit=NULL,const double sl=NULL,const double tp=NULL);

    bool              PositionClose(const ulong deviation=ULONG_MAX);
    bool              PositionClose(const ulong ticket,const ulong deviation=ULONG_MAX);
    bool              PositionCloseBy(const ulong ticket,const ulong ticket_by);
    bool              PositionClosePartial(const double volume,const ulong deviation=ULONG_MAX);
    bool              PositionClosePartial(const ulong ticket,const double volume,const ulong deviation=ULONG_MAX);

    //--- ACESSO AS ESTRUTURAS INTERNAS PARA REQUISICAO E RESULTADO DE ORDENS.
    void              Request(MqlTradeRequest &request)   const;
    ENUM_TRADE_REQUEST_ACTIONS RequestAction(void)        const { return(m_request.action);                              }
    string            RequestActionDescription(void)      const { return FormatRequest(m_request);                       }
    ulong             RequestMagic(void)                  const { return(m_request.magic);                               }
    ulong             RequestOrder(void)                  const { return(m_request.order);                               }
    ulong             RequestPosition(void)               const { return(m_request.position);                            }
    ulong             RequestPositionBy(void)             const { return(m_request.position_by);                         }
    string            RequestSymbol(void)                 const { return(m_request.symbol);                              }
    double            RequestVolume(void)                 const { return(m_request.volume);                              }
    double            RequestPrice(void)                  const { return(m_request.price);                               }
    double            RequestStopLimit(void)              const { return(m_request.stoplimit);                           }
    double            RequestSL(void)                     const { return(m_request.sl);                                  }
    double            RequestTP(void)                     const { return(m_request.tp);                                  }
    ulong             RequestDeviation(void)              const { return(m_request.deviation);                           }
    ENUM_ORDER_TYPE   RequestType(void)                   const { return(m_request.type);                                }
    string            RequestTypeDescription(void)        const { return FormatOrderType((uint) m_request.order);        }
    ENUM_ORDER_TYPE_FILLING RequestTypeFilling(void)      const { return(m_request.type_filling);                        }
    string            RequestTypeFillingDescription(void) const { return FormatOrderTypeFilling(m_request.type_filling); }
    ENUM_ORDER_TYPE_TIME RequestTypeTime(void)            const { return(m_request.type_time);                           }
    string            RequestTypeTimeDescription(void)    const { return FormatOrderTypeTime(m_request.type_time);       }
    datetime          RequestExpiration(void)             const { return(m_request.expiration);                          }
    string            RequestComment(void)                const { return(m_request.comment);                             }

    //---
    void              Result(MqlTradeResult &result)      const;
    uint              ResultRetcode(void)                 const { return(m_result.retcode);                               }
    string            ResultRetcodeDescription(void)      const { return FormatRequestResult(m_request,m_result);         }
    int               ResultRetcodeExternal(void)         const { return(m_result.retcode_external);                      }
    ulong             ResultDeal(void)                    const { return(m_result.deal);                                  }
    ulong             ResultOrder(void)                   const { return(m_result.order);                                 }
    double            ResultVolume(void)                  const { return(m_result.volume);                                }
    double            ResultPrice(void)                   const { return(m_result.price);                                 }
    double            ResultBid(void)                     const { return(m_result.bid);                                   }
    double            ResultAsk(void)                     const { return(m_result.ask);                                   }
    string            ResultComment(void)                 const { return(m_result.comment);                               }

    //---
    void              CheckResult(MqlTradeCheckResult &check_result) const;
    uint              CheckResultRetcode(void)            const { return(m_check_result.retcode);                         }
    double            CheckResultBalance(void)            const { return(m_check_result.balance);                         }
    double            CheckResultEquity(void)             const { return(m_check_result.equity);                          }
    double            CheckResultProfit(void)             const { return(m_check_result.profit);                          }
    double            CheckResultMargin(void)             const { return(m_check_result.margin);                          }
    double            CheckResultMarginFree(void)         const { return(m_check_result.margin_free);                     }
    double            CheckResultMarginLevel(void)        const { return(m_check_result.margin_level);                    }
    string            CheckResultComment(void)            const { return(m_check_result.comment);                         }

    //---
    string            CheckResultRetcodeDescription(void) const;
    virtual double    CheckVolume(double volume,double price,ENUM_ORDER_TYPE order_type);

    //--- FORMATACAO EM TEXTO DAS ESTRUTURAS DE REQUISICAO, ORDENS E POSICOES.
    string            FormatRequest(const MqlTradeRequest &request) const;
    string            FormatRequestResult(const MqlTradeRequest &request,const MqlTradeResult &result) const;

    //---
    string            FormatOrderType(const uint type) const;
    string            FormatOrderStatus(const uint status) const;
    string            FormatOrderTypeFilling(const uint type) const;
    string            FormatOrderTypeTime(const uint type) const;
    string            FormatOrderPrice(const double price_order,const double price_trigger,const uint digits) const;

    //---
    string            FormatPositionType(const uint type) const;

   };
//---


//--- INSTANCIAMENTO DA CLASSE E INICIALIZACAO DOS PARAMETROS:

//+------------------------------------------------------------------+
//| Constructor parametrico.                                         |
//+------------------------------------------------------------------+
CDayTrade::CDayTrade(const string simbol) :
    m_async_mode(false),
    m_type_filling(ORDER_FILL_MODE),
    m_type_time(ORDER_TIME_DAY),
    m_margin_mode(ACCOUNT_MARGIN_MODE_RETAIL_NETTING),
    m_deviation(ORDER_DEVIATION),
    m_magic(ORDER_EXPERT_ID)
   {
//--- check symbol
    m_symbol = isEmpty(simbol) ? Symbol() : simbol;

//--- initialize protected data
    ClearStructures();
   }


//--- HELPERS: FUNCOES INTERNAS AUXILIARES:

//+------------------------------------------------------------------+
//| Clear structures m_request,m_result and m_check_result           |
//+------------------------------------------------------------------+
void CDayTrade::ClearStructures(void)
   {
    ZeroMemory(m_request);
    ZeroMemory(m_result);
    ZeroMemory(m_check_result);
   }


//+------------------------------------------------------------------+
//| Checks forced shutdown of MQL5-program                           |
//+------------------------------------------------------------------+
bool CDayTrade::IsStopped(const string function)
   {
    if(!::IsStopped())
        return(false);

//--- MQL5 program is stopped
    LogFatal("%s: MQL5 program is stopped. Trading is disabled.",function);

    m_result.retcode=TRADE_RETCODE_CLIENT_DISABLES_AT;
    return(true);
   }


//+------------------------------------------------------------------+
//| Position select depending on netting or hedging                  |
//+------------------------------------------------------------------+
bool CDayTrade::SelectPosition()
   {
    bool achou = false;

//---
    ResetLastError();
    if(IsHedging())
       {
        for(uint i = 0, total = PositionsTotal(); i < total; i++)
           {
            if(PositionGetSymbol(i) == m_symbol && PositionGetInteger(POSITION_MAGIC) == m_magic)
               {
                achou = true;
                break;
               }
           }
       }
    else
        achou = PositionSelect(m_symbol);

//---
    return(achou);
   }


//--- TRANSACOES BASICAS DE COMPRA E VENDA, EM NIVEL MAIS BASICO:

//+------------------------------------------------------------------+
//| Send order                                                       |
//+------------------------------------------------------------------+
bool CDayTrade::SendOrder(const MqlTradeRequest &request, MqlTradeResult &result)
   {
//--- action
    ResetLastError();
    ulong start = GetMicrosecondCount();
    bool ok_order = (m_async_mode) ? OrderSendAsync(request,result) : OrderSend(request,result);
    m_latency_order = GetMicrosecondCount() - start;

//--- check
    if(ok_order)
        LogInfo("%s: %s [%s]",m_order_func,FormatRequest(request),FormatRequestResult(request,result));
    else
        LogError("%s: %s [%s]",m_order_func,FormatRequest(request),FormatRequestResult(request,result));

//--- return the result
    return(ok_order);
   }


//+------------------------------------------------------------------+
//| Installation pending order                                       |
//+------------------------------------------------------------------+
bool CDayTrade::OrderInsert(const ENUM_ORDER_TYPE order_type,const double volume,const double price,const double stop_limit,
                            const double sl,const double tp,const string comment)
   {
//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- clean
    ClearStructures();

//--- check order type for request action:
    m_request.action = (order_type==ORDER_TYPE_BUY || order_type==ORDER_TYPE_SELL) ? TRADE_ACTION_DEAL : TRADE_ACTION_PENDING;

//--- setting request
    m_request.type        =order_type;
    m_request.volume      =volume;

    m_request.price       =price;
    m_request.stoplimit   =stop_limit;
    m_request.sl          =sl;
    m_request.tp          =tp;
    m_request.comment     =comment;

    m_request.symbol      =m_symbol;
    m_request.magic       =m_magic;

    m_request.type_filling=m_type_filling;

    m_request.type_time   =m_type_time;
//m_request.expiration  =0;

    m_request.deviation=m_deviation;

//--- action and return the result
    return(SendOrder(m_request,m_result));
   }


//+------------------------------------------------------------------+
//| Modify specified pending order                                   |
//+------------------------------------------------------------------+
bool CDayTrade::OrderUpdate(const ulong ticket,const double sl,const double tp)
   {
//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- check order existence
    ResetLastError();
    ulong start = GetMicrosecondCount();
    bool retOk = OrderSelect(ticket);
    m_latency_order = GetMicrosecondCount() - start;
    if(! retOk)
        return(false);

//--- clean
    ClearStructures();

//--- setting request
    m_request.action      =TRADE_ACTION_SLTP;
    m_request.symbol      =m_symbol;
    m_request.magic       =m_magic;

    m_request.order       =ticket;
    m_request.sl          =sl;
    m_request.tp          =tp;

    m_request.type_time   =m_type_time;
//m_request.expiration  =0;

//--- execute action and return the result
    return(SendOrder(m_request,m_result));
   }


//+------------------------------------------------------------------+
//| Modify specified pending order                                   |
//+------------------------------------------------------------------+
bool CDayTrade::OrderUpdate(const ulong ticket,const double price,const double stop_limit,const double sl,const double tp)
   {
//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- check order existence
    ResetLastError();
    ulong start = GetMicrosecondCount();
    bool retOk = OrderSelect(ticket);
    m_latency_order = GetMicrosecondCount() - start;
    if(! retOk)
        return(false);

//--- clean
    ClearStructures();

//--- setting request
    m_request.action      =TRADE_ACTION_MODIFY;
    m_request.symbol      =m_symbol;
    m_request.magic       =m_magic;

    m_request.order       =ticket;
    m_request.price       =price;
    m_request.stoplimit   =stop_limit;
    m_request.sl          =sl;
    m_request.tp          =tp;

    m_request.type_time   =m_type_time;
//m_request.expiration  =0;

//--- execute action and return the result
    return(SendOrder(m_request,m_result));
   }


//+------------------------------------------------------------------+
//| Delete specified pending order                                   |
//+------------------------------------------------------------------+
bool CDayTrade::OrderDelete(const ulong ticket)
   {
//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- clean
    ClearStructures();

//--- setting request
    m_request.action    =TRADE_ACTION_REMOVE;
    m_request.order     =ticket;

    m_request.magic     =m_magic;

//--- execute action and return the result
    return(SendOrder(m_request,m_result));
   }


//--- GETTERS E SETTERS PARA CONFIGURACAO E PARAMETRIZACAO DO TRADING:

//+------------------------------------------------------------------+
//| Set order filling type according to symbol filling mode          |
//+------------------------------------------------------------------+
bool CDayTrade::SetTypeFillingBySymbol()
   {
//--- get possible filling policy types by symbol
    ResetLastError();
    uint filling = (uint) SymbolInfoInteger(m_symbol, SYMBOL_FILLING_MODE);

    if((filling & SYMBOL_FILLING_IOC) == SYMBOL_FILLING_IOC)
       {
        m_type_filling = ORDER_FILLING_IOC;
        return(true);
       }

    if((filling & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
       {
        m_type_filling = ORDER_FILLING_FOK;
        return(true);
       }

//---
    return(false);
   }


//--- OPERACOES DE COMPRA E VENDA DE ATIVOS, SEGUNDO NOMENCLATURA DO METATRADER:

//+------------------------------------------------------------------+
//| Send BUY operation                                               |
//+------------------------------------------------------------------+
bool CDayTrade::Buy(const double volume,const double sl=NULL,const double tp=NULL,const string comment=NULL)
   {
//--- check volume
    if(isNotValuable(volume))  // eh preciso um valor acima de 0.0
       {
        m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

//---
    return OrderInsert(ORDER_TYPE_BUY, volume, NULL, NULL, sl, tp, comment);
   }


//+------------------------------------------------------------------+
//| Send SELL operation                                              |
//+------------------------------------------------------------------+
bool CDayTrade::Sell(const double volume,const double sl=NULL,const double tp=NULL,const string comment=NULL)
   {
//--- check volume
    if(isNotValuable(volume))  // eh preciso um valor acima de 0.0
       {
        m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

//---
    return OrderInsert(ORDER_TYPE_SELL, volume, NULL, NULL, sl, tp, comment);
   }


//+------------------------------------------------------------------+
//| Send BUY_LIMIT order                                             |
//+------------------------------------------------------------------+
bool CDayTrade::BuyLimit(const double volume,const double price,const double sl=NULL,const double tp=NULL,const string comment=NULL)
   {
//--- check volume
    if(isNotValuable(volume))  // eh preciso um valor acima de 0.0
       {
        m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

//--- send "BUY_LIMIT" order
    return OrderInsert(ORDER_TYPE_BUY_LIMIT, volume, price, NULL, sl, tp, comment);
   }


//+------------------------------------------------------------------+
//| Send SELL_LIMIT order                                            |
//+------------------------------------------------------------------+
bool CDayTrade::SellLimit(const double volume,const double price,const double sl=NULL,const double tp=NULL,const string comment=NULL)
   {
//--- check volume
    if(isNotValuable(volume))  // eh preciso um valor acima de 0.0
       {
        m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

//--- send "SELL_LIMIT" order
    return OrderInsert(ORDER_TYPE_SELL_LIMIT, volume, price, NULL, sl, tp, comment);
   }


//+------------------------------------------------------------------+
//| Send BUY_STOP order                                              |
//+------------------------------------------------------------------+
bool CDayTrade::BuyStop(const double volume,const double price,const double sl=NULL,const double tp=NULL,const string comment=NULL)
   {
//--- check volume
    if(isNotValuable(volume))  // eh preciso um valor acima de 0.0
       {
        m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

//--- send "BUY_STOP" order
    return OrderInsert(ORDER_TYPE_BUY_STOP, volume, price, NULL, sl, tp, comment);
   }


//+------------------------------------------------------------------+
//| Send SELL_STOP order                                             |
//+------------------------------------------------------------------+
bool CDayTrade::SellStop(const double volume,const double price,const double sl=NULL,const double tp=NULL,const string comment=NULL)
   {
//--- check volume
    if(isNotValuable(volume))  // eh preciso um valor acima de 0.0
       {
        m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

//--- send "SELL_STOP" order
    return OrderInsert(ORDER_TYPE_SELL_STOP, volume, price, NULL, sl, tp, comment);
   }


//+------------------------------------------------------------------+
//| Send BUY_STOP_LIMIT order                                              |
//+------------------------------------------------------------------+
bool CDayTrade::BuyStopLimit(const double volume,const double price,const double stop_limit,const double sl=NULL,const double tp=NULL,const string comment=NULL)
   {
//--- check volume
    if(isNotValuable(volume))  // eh preciso um valor acima de 0.0
       {
        m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

//--- send "BUY_STOP" order
    return OrderInsert(ORDER_TYPE_BUY_STOP_LIMIT, volume, price, stop_limit, sl, tp, comment);
   }


//+------------------------------------------------------------------+
//| Send SELL_STOP_LIMIT order                                             |
//+------------------------------------------------------------------+
bool CDayTrade::SellStopLimit(const double volume,const double price,const double stop_limit,const double sl=NULL,const double tp=NULL,const string comment=NULL)
   {
//--- check volume
    if(isNotValuable(volume))  // eh preciso um valor acima de 0.0
       {
        m_result.retcode=TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

//--- send "SELL_STOP" order
    return OrderInsert(ORDER_TYPE_SELL_STOP_LIMIT, volume, price, stop_limit, sl, tp, comment);
   }


//--- OPERACOES PARA MODIFICACAO E FECHAMENTO DE POISICOES DE NEGOCIACAO:

//+------------------------------------------------------------------+
//| Modify specified opened position                                 |
//+------------------------------------------------------------------+
bool CDayTrade::PositionModify(const double sl=NULL,const double tp=NULL)
   {
    ulong ticket;

//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- check position existence
    if(SelectPosition())
        ticket = PositionGetInteger(POSITION_TICKET);
    else
        return(false);

//--- clean
    ClearStructures();

//--- setting request
    m_request.position = ticket;
    m_request.action   = TRADE_ACTION_SLTP;
    m_request.symbol   = m_symbol;
    m_request.magic    = m_magic;

    if(sl != NULL)
        m_request.sl = sl;

    if(tp != NULL)
        m_request.tp = tp;

//--- action and return the result
    return(SendOrder(m_request,m_result));
   }


//+------------------------------------------------------------------+
//| Modify specified opened position                                 |
//+------------------------------------------------------------------+
bool CDayTrade::PositionModify(const double price=NULL,const double stop_limit=NULL,const double sl=NULL,const double tp=NULL)
   {
    ulong ticket;

//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- check position existence
    if(SelectPosition())
        ticket = PositionGetInteger(POSITION_TICKET);
    else
        return(false);

//--- clean
    ClearStructures();

//--- setting request
    m_request.position = ticket;
    m_request.action   = TRADE_ACTION_MODIFY;
    m_request.symbol   = m_symbol;
    m_request.magic    = m_magic;

    if(price != NULL)
        m_request.price =price;

    if(stop_limit != NULL)
        m_request.stoplimit = stop_limit;

    if(sl != NULL)
        m_request.sl = sl;

    if(tp != NULL)
        m_request.tp = tp;

//--- action and return the result
    return(SendOrder(m_request,m_result));
   }


//+------------------------------------------------------------------+
//| Modify specified opened position                                 |
//+------------------------------------------------------------------+
bool CDayTrade::PositionModify(const ulong ticket,const double sl=NULL,const double tp=NULL)
   {
//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- check position existence
    ResetLastError();
    if(!PositionSelectByTicket(ticket))
        return(false);

//--- clean
    ClearStructures();

//--- setting request
    m_request.position=ticket;
    m_request.action  =TRADE_ACTION_SLTP;
    m_request.symbol  =m_symbol;
    m_request.magic   =m_magic;

    if(sl != NULL)
        m_request.sl = sl;

    if(tp != NULL)
        m_request.tp = tp;

//--- action and return the result
    return(SendOrder(m_request,m_result));
   }

//+------------------------------------------------------------------+
//| Modify specified opened position                                 |
//+------------------------------------------------------------------+
bool CDayTrade::PositionModify(const ulong ticket,const double price=NULL,const double stop_limit=NULL,const double sl=NULL,const double tp=NULL)
   {
//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- check position existence
    ResetLastError();
    if(!PositionSelectByTicket(ticket))
        return(false);

//--- clean
    ClearStructures();

//--- setting request
    m_request.position=ticket;
    m_request.action  =TRADE_ACTION_SLTP;
    m_request.symbol  =m_symbol;
    m_request.magic   =m_magic;

    if(price != NULL)
        m_request.price =price;

    if(stop_limit != NULL)
        m_request.stoplimit = stop_limit;

    if(sl != NULL)
        m_request.sl = sl;

    if(tp != NULL)
        m_request.tp = tp;

//--- action and return the result
    return(SendOrder(m_request,m_result));
   }


//+------------------------------------------------------------------+
//| Close specified opened position                                  |
//+------------------------------------------------------------------+
bool CDayTrade::PositionClose(const ulong deviation)
   {
    bool partial_close=false;
    int  retry_count  =10;
    uint retcode      =TRADE_RETCODE_REJECT;

//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- clean
    ClearStructures();

    ResetLastError();
    do
       {
        //--- check
        if(SelectPosition())
           {
            if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
               {
                //--- prepare request for close BUY position
                m_request.type =ORDER_TYPE_SELL;
                m_request.price=SymbolInfoDouble(m_symbol,SYMBOL_BID);
               }
            else
               {
                //--- prepare request for close SELL position
                m_request.type =ORDER_TYPE_BUY;
                m_request.price=SymbolInfoDouble(m_symbol,SYMBOL_ASK);
               }
           }
        else
           {
            //--- position not found
            m_result.retcode=retcode;
            return(false);
           }

        //--- setting request
        m_request.action   =TRADE_ACTION_DEAL;
        m_request.symbol   =m_symbol;
        m_request.volume   =PositionGetDouble(POSITION_VOLUME);
        m_request.magic    =m_magic;
        m_request.deviation=(deviation==ULONG_MAX) ? m_deviation : deviation;

        //--- check volume
        double max_volume=SymbolInfoDouble(m_symbol,SYMBOL_VOLUME_MAX);
        if(m_request.volume>max_volume)
           {
            m_request.volume=max_volume;
            partial_close=true;
           }
        else
            partial_close=false;

        //--- hedging? just send order
        if(IsHedging())
           {
            m_request.position=PositionGetInteger(POSITION_TICKET);
            return(SendOrder(m_request,m_result));
           }

        //--- order send
        if(!SendOrder(m_request,m_result))
           {
            if(--retry_count!=0)
                continue;
            if(retcode==TRADE_RETCODE_DONE_PARTIAL)
                m_result.retcode=retcode;
            return(false);
           }

        //--- WARNING. If position volume exceeds the maximum volume allowed for deal,
        //--- and when the asynchronous trade mode is on, for safety reasons, position is closed not completely,
        //--- but partially. It is decreased by the maximum volume allowed for deal.
        if(m_async_mode)
            break;

        retcode=TRADE_RETCODE_DONE_PARTIAL;
        if(partial_close)
            Sleep(1000);
       }
    while(partial_close);

//--- succeed
    return(true);
   }


//+------------------------------------------------------------------+
//| Close specified opened position                                  |
//+------------------------------------------------------------------+
bool CDayTrade::PositionClose(const ulong ticket,const ulong deviation)
   {
//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- check position existence
    ResetLastError();
    if(!PositionSelectByTicket(ticket))
        return(false);

    string symbol=PositionGetString(POSITION_SYMBOL);

//--- clean
    ClearStructures();

//--- check
    ResetLastError();
    if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
       {
        //--- prepare request for close BUY position
        m_request.type =ORDER_TYPE_SELL;
        m_request.price=SymbolInfoDouble(symbol,SYMBOL_BID);
       }
    else
       {
        //--- prepare request for close SELL position
        m_request.type =ORDER_TYPE_BUY;
        m_request.price=SymbolInfoDouble(symbol,SYMBOL_ASK);
       }

//--- setting request
    m_request.action   =TRADE_ACTION_DEAL;
    m_request.position =ticket;
    m_request.symbol   =symbol;
    m_request.volume   =PositionGetDouble(POSITION_VOLUME);
    m_request.magic    =m_magic;
    m_request.deviation=(deviation==ULONG_MAX) ? m_deviation : deviation;

//--- close position
    return(SendOrder(m_request,m_result));
   }


//+------------------------------------------------------------------+
//| Close one position by other                                      |
//+------------------------------------------------------------------+
bool CDayTrade::PositionCloseBy(const ulong ticket,const ulong ticket_by)
   {
//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- check hedging mode
    if(!IsHedging())
        return(false);

//--- check position existence
    ResetLastError();
    if(!PositionSelectByTicket(ticket))
        return(false);

    string symbol=PositionGetString(POSITION_SYMBOL);
    ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

    ResetLastError();
    if(!PositionSelectByTicket(ticket_by))
        return(false);

    string symbol_by=PositionGetString(POSITION_SYMBOL);
    ENUM_POSITION_TYPE type_by=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

//--- check positions
    if(type==type_by)
        return(false);
    if(symbol!=symbol_by)
        return(false);

//--- clean
    ClearStructures();

//--- setting request
    m_request.action     =TRADE_ACTION_CLOSE_BY;
    m_request.position   =ticket;
    m_request.position_by=ticket_by;
    m_request.magic      =m_magic;

//--- close position
    return(SendOrder(m_request,m_result));
   }


//+------------------------------------------------------------------+
//| Partial close specified opened position (for hedging mode only)  |
//+------------------------------------------------------------------+
bool CDayTrade::PositionClosePartial(const double volume,const ulong deviation)
   {
    uint retcode=TRADE_RETCODE_REJECT;

//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- for hedging mode only
    if(!IsHedging())
        return(false);

//--- clean
    ClearStructures();

//--- check
    ResetLastError();
    if(SelectPosition())
       {
        if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           {
            //--- prepare request for close BUY position
            m_request.type =ORDER_TYPE_SELL;
            m_request.price=SymbolInfoDouble(m_symbol,SYMBOL_BID);
           }
        else
           {
            //--- prepare request for close SELL position
            m_request.type =ORDER_TYPE_BUY;
            m_request.price=SymbolInfoDouble(m_symbol,SYMBOL_ASK);
           }
       }
    else
       {
        //--- position not found
        m_result.retcode=retcode;
        return(false);
       }

//--- check volume
    double position_volume=PositionGetDouble(POSITION_VOLUME);
    if(position_volume>volume)
        position_volume=volume;

//--- setting request
    m_request.action   =TRADE_ACTION_DEAL;
    m_request.symbol   =m_symbol;
    m_request.volume   =position_volume;
    m_request.magic    =m_magic;
    m_request.deviation=(deviation==ULONG_MAX) ? m_deviation : deviation;
    m_request.position =PositionGetInteger(POSITION_TICKET);

//--- hedging? just send order
    return(SendOrder(m_request,m_result));
   }


//+------------------------------------------------------------------+
//| Partial close specified opened position (for hedging mode only)  |
//+------------------------------------------------------------------+
bool CDayTrade::PositionClosePartial(const ulong ticket,const double volume,const ulong deviation)
   {
//--- check stopped
    if(IsStopped(__FUNCTION__))
        return(false);

//--- for hedging mode only
    if(!IsHedging())
        return(false);

//--- check position existence
    ResetLastError();
    if(!PositionSelectByTicket(ticket))
        return(false);
    string symbol=PositionGetString(POSITION_SYMBOL);

//--- clean
    ClearStructures();

//--- check
    ResetLastError();
    if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
       {
        //--- prepare request for close BUY position
        m_request.type =ORDER_TYPE_SELL;
        m_request.price=SymbolInfoDouble(symbol,SYMBOL_BID);
       }
    else
       {
        //--- prepare request for close SELL position
        m_request.type =ORDER_TYPE_BUY;
        m_request.price=SymbolInfoDouble(symbol,SYMBOL_ASK);
       }

//--- check volume
    double position_volume=PositionGetDouble(POSITION_VOLUME);
    if(position_volume>volume)
        position_volume=volume;

//--- setting request
    m_request.action   =TRADE_ACTION_DEAL;
    m_request.position =ticket;
    m_request.symbol   =symbol;
    m_request.volume   =position_volume;
    m_request.magic    =m_magic;
    m_request.deviation=(deviation==ULONG_MAX) ? m_deviation : deviation;

//--- close position
    return(SendOrder(m_request,m_result));
   }


//--- ACESSO AS ESTRUTURAS INTERNAS PARA REQUISICAO E RESULTADO DE ORDENS.

//+------------------------------------------------------------------+
//| Get the request structure                                        |
//+------------------------------------------------------------------+
void CDayTrade::Request(MqlTradeRequest &request) const
   {
    request.action      =m_request.action;
    request.magic       =m_request.magic;
    request.order       =m_request.order;
    request.symbol      =m_request.symbol;
    request.volume      =m_request.volume;
    request.price       =m_request.price;
    request.stoplimit   =m_request.stoplimit;
    request.sl          =m_request.sl;
    request.tp          =m_request.tp;
    request.deviation   =m_request.deviation;
    request.type        =m_request.type;
    request.type_filling=m_request.type_filling;
    request.type_time   =m_request.type_time;
    request.expiration  =m_request.expiration;
    request.comment     =m_request.comment;
    request.position    =m_request.position;
    request.position_by =m_request.position_by;
   }


//+------------------------------------------------------------------+
//| Get the result structure                                         |
//+------------------------------------------------------------------+
void CDayTrade::Result(MqlTradeResult &result) const
   {
    result.retcode   =m_result.retcode;
    result.deal      =m_result.deal;
    result.order     =m_result.order;
    result.volume    =m_result.volume;
    result.price     =m_result.price;
    result.bid       =m_result.bid;
    result.ask       =m_result.ask;
    result.comment   =m_result.comment;
    result.request_id=m_result.request_id;
    result.retcode_external=m_result.retcode_external;
   }


//+------------------------------------------------------------------+
//| Get the check result structure                                   |
//+------------------------------------------------------------------+
void CDayTrade::CheckResult(MqlTradeCheckResult &check_result) const
   {
//--- copy structure
    check_result.retcode     =m_check_result.retcode;
    check_result.balance     =m_check_result.balance;
    check_result.equity      =m_check_result.equity;
    check_result.profit      =m_check_result.profit;
    check_result.margin      =m_check_result.margin;
    check_result.margin_free =m_check_result.margin_free;
    check_result.margin_level=m_check_result.margin_level;
    check_result.comment     =m_check_result.comment;
   }


//+------------------------------------------------------------------+
//| Get the check retcode value as string                            |
//+------------------------------------------------------------------+
string CDayTrade::CheckResultRetcodeDescription(void) const
   {
    MqlTradeResult result;
//---
    result.retcode=m_check_result.retcode;
    return FormatRequestResult(m_request,result);
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CDayTrade::CheckVolume(double volume,double price,ENUM_ORDER_TYPE order_type)
   {
//--- check
    if(order_type!=ORDER_TYPE_BUY && order_type!=ORDER_TYPE_SELL)
        return(0.0);

    double free_margin=AccountInfoDouble(ACCOUNT_FREEMARGIN);
    if(free_margin<=0.0)
        return(0.0);

//--- clean
    ClearStructures();

//--- setting request
    m_request.action=TRADE_ACTION_DEAL;
    m_request.symbol=m_symbol;
    m_request.volume=volume;
    m_request.type  =order_type;
    m_request.price =price;

//--- action and return the result
    ResetLastError();
    if(! OrderCheck(m_request,m_check_result) && m_check_result.margin_free<0.0)
       {
        double coeff=free_margin/(free_margin-m_check_result.margin_free);
        double lots=NormalizeDouble(volume*coeff,2);
        if(lots<volume)
           {
            //--- normalize and check limits
            ResetLastError();
            double stepvol=SymbolInfoDouble(m_symbol,SYMBOL_VOLUME_STEP);
            if(stepvol>0.0)
                volume=stepvol*(MathFloor(lots/stepvol)-1);
            //---
            ResetLastError();
            double minvol=SymbolInfoDouble(m_symbol,SYMBOL_VOLUME_MIN);
            if(volume<minvol)
                volume=0.0;
           }
       }

    return(volume);
   }


//--- FORMATACAO EM TEXTO DAS ESTRUTURAS DE REQUISICAO, ORDENS E POSICOES.

//+------------------------------------------------------------------+
//| Converts the parameters of a trade request to text               |
//+------------------------------------------------------------------+
string CDayTrade::FormatRequest(const MqlTradeRequest &request) const
   {
    string str = "";
    string tmp_string;
    long   tmp_long;

//--- set up
    int    digits=_Digits;
    ENUM_SYMBOL_TRADE_EXECUTION trade_execution=0;

    ResetLastError();
    if(SymbolInfoInteger(m_symbol,SYMBOL_DIGITS,tmp_long))
        digits=(int)tmp_long;

    ResetLastError();
    if(SymbolInfoInteger(m_symbol,SYMBOL_TRADE_EXEMODE,tmp_long))
        trade_execution=(ENUM_SYMBOL_TRADE_EXECUTION)tmp_long;

//--- see what is wanted
    switch(request.action)
       {
        //--- instant execution of a deal
        case TRADE_ACTION_DEAL:
            switch(trade_execution)
               {
                //--- request execution
                case SYMBOL_TRADE_EXECUTION_REQUEST:
                    if(IsHedging() && request.position!=0)
                        str=StringFormat("request %s %s position #%I64u %s at %s",
                                         FormatOrderType(request.type),
                                         DoubleToString(request.volume,2),
                                         request.position,
                                         request.symbol,
                                         DoubleToString(request.price,digits));
                    else
                        str=StringFormat("request %s %s %s at %s",
                                         FormatOrderType(request.type),
                                         DoubleToString(request.volume,2),
                                         request.symbol,
                                         DoubleToString(request.price,digits));

                    //--- Is there SL or TP?
                    if(request.sl!=0.0)
                       {
                        tmp_string=StringFormat(" sl: %s",DoubleToString(request.sl,digits));
                        str+=tmp_string;
                       }
                    if(request.tp!=0.0)
                       {
                        tmp_string=StringFormat(" tp: %s",DoubleToString(request.tp,digits));
                        str+=tmp_string;
                       }
                    break;

                //--- instant execution
                case SYMBOL_TRADE_EXECUTION_INSTANT:
                    if(IsHedging() && request.position!=0)
                        str=StringFormat("instant %s %s position #%I64u %s at %s",
                                         FormatOrderType(request.type),
                                         DoubleToString(request.volume,2),
                                         request.position,
                                         request.symbol,
                                         DoubleToString(request.price,digits));
                    else
                        str=StringFormat("instant %s %s %s at %s",
                                         FormatOrderType(request.type),
                                         DoubleToString(request.volume,2),
                                         request.symbol,
                                         DoubleToString(request.price,digits));

                    //--- Is there SL or TP?
                    if(request.sl!=0.0)
                       {
                        tmp_string=StringFormat(" sl: %s",DoubleToString(request.sl,digits));
                        str+=tmp_string;
                       }
                    if(request.tp!=0.0)
                       {
                        tmp_string=StringFormat(" tp: %s",DoubleToString(request.tp,digits));
                        str+=tmp_string;
                       }
                    break;

                //--- market execution
                case SYMBOL_TRADE_EXECUTION_MARKET:
                    if(IsHedging() && request.position!=0)
                        str=StringFormat("market %s %s position #%I64u %s",
                                         FormatOrderType(request.type),
                                         DoubleToString(request.volume,2),
                                         request.position,
                                         request.symbol);
                    else
                        str=StringFormat("market %s %s %s",
                                         FormatOrderType(request.type),
                                         DoubleToString(request.volume,2),
                                         request.symbol);

                    //--- Is there SL or TP?
                    if(request.sl!=0.0)
                       {
                        tmp_string=StringFormat(" sl: %s",DoubleToString(request.sl,digits));
                        str+=tmp_string;
                       }
                    if(request.tp!=0.0)
                       {
                        tmp_string=StringFormat(" tp: %s",DoubleToString(request.tp,digits));
                        str+=tmp_string;
                       }
                    break;

                //--- exchange execution
                case SYMBOL_TRADE_EXECUTION_EXCHANGE:
                    if(IsHedging() && request.position!=0)
                        str=StringFormat("exchange %s %s position #%I64u %s",
                                         FormatOrderType(request.type),
                                         DoubleToString(request.volume,2),
                                         request.position,
                                         request.symbol);
                    else
                        str=StringFormat("exchange %s %s %s",
                                         FormatOrderType(request.type),
                                         DoubleToString(request.volume,2),
                                         request.symbol);

                    //--- Is there SL or TP?
                    if(request.sl!=0.0)
                       {
                        tmp_string=StringFormat(" sl: %s",DoubleToString(request.sl,digits));
                        str+=tmp_string;
                       }
                    if(request.tp!=0.0)
                       {
                        tmp_string=StringFormat(" tp: %s",DoubleToString(request.tp,digits));
                        str+=tmp_string;
                       }
                    break;
               }
            //--- end of TRADE_ACTION_DEAL processing
            break;

        //--- setting a pending order
        case TRADE_ACTION_PENDING:
            str=StringFormat("%s %s %s at %s",
                             FormatOrderType(request.type),
                             DoubleToString(request.volume,2),
                             request.symbol,
                             FormatOrderPrice(request.price,request.stoplimit,digits));

            //--- Is there SL or TP?
            if(request.sl!=0.0)
               {
                tmp_string=StringFormat(" sl: %s",DoubleToString(request.sl,digits));
                str+=tmp_string;
               }
            if(request.tp!=0.0)
               {
                tmp_string=StringFormat(" tp: %s",DoubleToString(request.tp,digits));
                str+=tmp_string;
               }
            break;

        //--- Setting SL/TP
        case TRADE_ACTION_SLTP:
            if(IsHedging() && request.position!=0)
                str=StringFormat("modify position #%I64u %s (sl: %s, tp: %s)",
                                 request.position,
                                 request.symbol,
                                 DoubleToString(request.sl,digits),
                                 DoubleToString(request.tp,digits));
            else
                str=StringFormat("modify %s (sl: %s, tp: %s)",
                                 request.symbol,
                                 DoubleToString(request.sl,digits),
                                 DoubleToString(request.tp,digits));
            break;

        //--- modifying a pending order
        case TRADE_ACTION_MODIFY:
            str=StringFormat("modify #%I64u at %s (sl: %s tp: %s)",
                             request.order,
                             FormatOrderPrice(request.price,request.stoplimit,digits),
                             DoubleToString(request.sl,digits),
                             DoubleToString(request.tp,digits));
            break;

        //--- deleting a pending order
        case TRADE_ACTION_REMOVE:
            str=StringFormat("cancel #%I64u",request.order);
            break;

        //--- close by
        case TRADE_ACTION_CLOSE_BY:
            if(IsHedging() && request.position!=0)
                str=StringFormat("close position #%I64u by #%I64u",request.position,request.position_by);
            else
                str=StringFormat("wrong action close by (#%I64u by #%I64u)",request.position,request.position_by);
            break;

        default:
            str="unknown action "+(string)request.action;
            break;
       }

//--- return the result
    return(str);
   }


//+------------------------------------------------------------------+
//| Converts the result of a request to text                         |
//+------------------------------------------------------------------+
string CDayTrade::FormatRequestResult(const MqlTradeRequest &request,const MqlTradeResult &result) const
   {
    string str;
    int    digits=_Digits;
    long   tmp_long;

//--- set up
    ENUM_SYMBOL_TRADE_EXECUTION trade_execution=0;
    ResetLastError();
    if(SymbolInfoInteger(m_symbol,SYMBOL_DIGITS,tmp_long))
        digits=(int)tmp_long;

    ResetLastError();
    if(SymbolInfoInteger(m_symbol,SYMBOL_TRADE_EXEMODE,tmp_long))
        trade_execution=(ENUM_SYMBOL_TRADE_EXECUTION)tmp_long;

//--- see the response code
    switch(result.retcode)
       {
        case TRADE_RETCODE_REQUOTE:
            str=StringFormat("requote (%s/%s)",
                             DoubleToString(result.bid,digits),
                             DoubleToString(result.ask,digits));
            break;

        case TRADE_RETCODE_DONE:
            if(request.action==TRADE_ACTION_DEAL &&
               (trade_execution==SYMBOL_TRADE_EXECUTION_REQUEST ||
                trade_execution==SYMBOL_TRADE_EXECUTION_INSTANT ||
                trade_execution==SYMBOL_TRADE_EXECUTION_MARKET))
                str=StringFormat("done at %s",DoubleToString(result.price,digits));
            else
                str="done";
            break;

        case TRADE_RETCODE_DONE_PARTIAL:
            if(request.action==TRADE_ACTION_DEAL &&
               (trade_execution==SYMBOL_TRADE_EXECUTION_REQUEST ||
                trade_execution==SYMBOL_TRADE_EXECUTION_INSTANT ||
                trade_execution==SYMBOL_TRADE_EXECUTION_MARKET))
                str=StringFormat("done partially %s at %s",
                                 DoubleToString(result.volume,2),
                                 DoubleToString(result.price,digits));
            else
                str=StringFormat("done partially %s",
                                 DoubleToString(result.volume,2));
            break;

        case TRADE_RETCODE_REJECT:
            str="rejected";
            break;
        case TRADE_RETCODE_CANCEL:
            str="canceled";
            break;
        case TRADE_RETCODE_PLACED:
            str="placed";
            break;
        case TRADE_RETCODE_ERROR:
            str="common error";
            break;
        case TRADE_RETCODE_TIMEOUT:
            str="timeout";
            break;
        case TRADE_RETCODE_INVALID:
            str="invalid request";
            break;
        case TRADE_RETCODE_INVALID_VOLUME:
            str="invalid volume";
            break;
        case TRADE_RETCODE_INVALID_PRICE:
            str="invalid price";
            break;
        case TRADE_RETCODE_INVALID_STOPS:
            str="invalid stops";
            break;
        case TRADE_RETCODE_TRADE_DISABLED:
            str="trade disabled";
            break;
        case TRADE_RETCODE_MARKET_CLOSED:
            str="market closed";
            break;
        case TRADE_RETCODE_NO_MONEY:
            str="not enough money";
            break;
        case TRADE_RETCODE_PRICE_CHANGED:
            str="price changed";
            break;
        case TRADE_RETCODE_PRICE_OFF:
            str="off quotes";
            break;
        case TRADE_RETCODE_INVALID_EXPIRATION:
            str="invalid expiration";
            break;
        case TRADE_RETCODE_ORDER_CHANGED:
            str="order changed";
            break;
        case TRADE_RETCODE_TOO_MANY_REQUESTS:
            str="too many requests";
            break;
        case TRADE_RETCODE_NO_CHANGES:
            str="no changes";
            break;
        case TRADE_RETCODE_SERVER_DISABLES_AT:
            str="auto trading disabled by server";
            break;
        case TRADE_RETCODE_CLIENT_DISABLES_AT:
            str="auto trading disabled by client";
            break;
        case TRADE_RETCODE_LOCKED:
            str="locked";
            break;
        case TRADE_RETCODE_FROZEN:
            str="frozen";
            break;
        case TRADE_RETCODE_INVALID_FILL:
            str="invalid fill";
            break;
        case TRADE_RETCODE_CONNECTION:
            str="no connection";
            break;
        case TRADE_RETCODE_ONLY_REAL:
            str="only real";
            break;
        case TRADE_RETCODE_LIMIT_ORDERS:
            str="limit orders";
            break;
        case TRADE_RETCODE_LIMIT_VOLUME:
            str="limit volume";
            break;
        case TRADE_RETCODE_POSITION_CLOSED:
            str="position closed";
            break;
        case TRADE_RETCODE_INVALID_ORDER:
            str="invalid order";
            break;
        case TRADE_RETCODE_CLOSE_ORDER_EXIST:
            str="close order already exists";
            break;
        case TRADE_RETCODE_LIMIT_POSITIONS:
            str="limit positions";
            break;

        default:
            str="unknown retcode "+(string)result.retcode;
       }

//--- return the result
    return(str);
   }


//+------------------------------------------------------------------+
//| Converts the order type to text                                  |
//+------------------------------------------------------------------+
string CDayTrade::FormatOrderType(const uint type) const
   {
    string str;

//--- see the type
    switch(type)
       {
        case ORDER_TYPE_BUY:
            str="buy";
            break;
        case ORDER_TYPE_SELL:
            str="sell";
            break;
        case ORDER_TYPE_BUY_LIMIT:
            str="buy limit";
            break;
        case ORDER_TYPE_SELL_LIMIT:
            str="sell limit";
            break;
        case ORDER_TYPE_BUY_STOP:
            str="buy stop";
            break;
        case ORDER_TYPE_SELL_STOP:
            str="sell stop";
            break;
        case ORDER_TYPE_BUY_STOP_LIMIT:
            str="buy stop limit";
            break;
        case ORDER_TYPE_SELL_STOP_LIMIT:
            str="sell stop limit";
            break;

        default:
            str="unknown order type "+(string)type;
       }

//--- return the result
    return(str);
   }


//+------------------------------------------------------------------+
//| Converts the order filling type to text                          |
//+------------------------------------------------------------------+
string CDayTrade::FormatOrderTypeFilling(const uint type) const
   {
    string str;

//--- see the type
    switch(type)
       {
        case ORDER_FILLING_RETURN:
            str="return remainder";
            break;
        case ORDER_FILLING_IOC:
            str="cancel remainder";
            break;
        case ORDER_FILLING_FOK:
            str="fill or kill";
            break;

        default:
            str="unknown type filling "+(string)type;
            break;
       }

//--- return the result
    return(str);
   }


//+------------------------------------------------------------------+
//| Converts the type of order by expiration to text                 |
//+------------------------------------------------------------------+
string CDayTrade::FormatOrderTypeTime(const uint type) const
   {
    string str;

//--- see the type
    switch(type)
       {
        case ORDER_TIME_GTC:
            str="gtc";
            break;
        case ORDER_TIME_DAY:
            str="day";
            break;
        case ORDER_TIME_SPECIFIED:
            str="specified";
            break;
        case ORDER_TIME_SPECIFIED_DAY:
            str="specified day";
            break;

        default:
            str="unknown type time "+(string)type;
       }

//--- return the result
    return(str);
   }


//+------------------------------------------------------------------+
//| Converts the order prices to text                                |
//+------------------------------------------------------------------+
string CDayTrade::FormatOrderPrice(const double price_order,const double price_trigger,const uint digits) const
   {
    string str;

//--- Is there its trigger price?
    if(price_trigger)
       {
        string price = DoubleToString(price_order,digits);
        string trigger = DoubleToString(price_trigger,digits);
        str = StringFormat("%s (%s)",price,trigger);
       }
    else
        str = DoubleToString(price_order,digits);

//--- return the result
    return(str);
   }


//+------------------------------------------------------------------+
//| Converts the position type to text                               |
//+------------------------------------------------------------------+
string CDayTrade::FormatPositionType(const uint type) const
   {
    string str;

//--- see the type
    switch(type)
       {
        case POSITION_TYPE_BUY:
            str="buy";
            break;
        case POSITION_TYPE_SELL:
            str="sell";
            break;

        default:
            str="unknown position type "+(string)type;
       }

//--- return the result
    return(str);
   }


//+------------------------------------------------------------------+
