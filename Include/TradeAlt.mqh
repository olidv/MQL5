//+------------------------------------------------------------------+
//|                                                     TradeAlt.mqh |
//|                                                      nicholishen |
//|                                   www.reddit.com/u/nicholishenFX |
//+------------------------------------------------------------------+
#property copyright "nicholishen"
#property link      "www.reddit.com/u/nicholishenFX"
#property version   "1.00"
#include <Trade\Trade.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTradeAlt : public CTrade
  {
private:

public:
                     CTradeAlt();
                    ~CTradeAlt();
   bool              PositionClosePartial(const ulong ticket,
                                          const double volume,
                                          const ulong deviation,
                                          const string comentario_);
   bool              PositionClosePartial(const string symbol,
                                          const double volume,
                                          const ulong deviation);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTradeAlt::CTradeAlt()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTradeAlt::~CTradeAlt()
  {
  }
//+------------------------------------------------------------------+
bool CTradeAlt::PositionClosePartial(const string symbol,const double volume,const ulong deviation)
  {
   uint retcode=TRADE_RETCODE_REJECT;
//--- check stopped
   if(IsStopped(__FUNCTION__))
      return(false);
//--- for hedging mode only
   //if(!IsHedging())
   //   return(false);
//--- clean
   ClearStructures();
//--- check filling
   if(!FillingCheck(symbol))
      return(false);
//--- check
   if(SelectPosition(symbol))
     {
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
   m_request.symbol   =symbol;
   m_request.volume   =position_volume;
   m_request.magic    =m_magic;
   m_request.deviation=(deviation==ULONG_MAX) ? m_deviation : deviation;
   m_request.position =PositionGetInteger(POSITION_TICKET);
//--- hedging? just send order
   return(OrderSend(m_request,m_result));
  }

bool CTradeAlt::PositionClosePartial(const ulong ticket,const double volume,const ulong deviation,const string comentario_=NULL)
  {
//--- check stopped
   if(IsStopped(__FUNCTION__))
      return(false);
//--- for hedging mode only
   //if(!IsHedging())
   //   return(false);
//--- check position existence
   if(!PositionSelectByTicket(ticket))
      return(false);
   string symbol=PositionGetString(POSITION_SYMBOL);
//--- clean
   ClearStructures();
//--- check filling
   if(!FillingCheck(symbol))
      return(false);
//--- check
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
   m_request.comment = comentario_;
   m_request.deviation=(deviation==ULONG_MAX) ? m_deviation : deviation;
//--- close position
   return(OrderSend(m_request,m_result));
  }