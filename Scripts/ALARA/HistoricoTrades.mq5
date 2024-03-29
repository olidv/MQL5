//+------------------------------------------------------------------+
//|                                              HistoricoTrades.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {

    //--- história do negócio pedido 
    bool result = HistorySelect(0,TimeCurrent()); 
    Print("result = ", result);
    
    //--- cria objetos 
    uint     total=HistoryDealsTotal(); 
    Print("total = ", total);
    
    
    ulong    ticket=0; 
    double   price; 
    datetime time; 
    string   symbol; 
    long     type; 
    long     entry; 
    double   profit; 
    string   name; 
    
    //--- para todos os negócios 
    for(uint i=0; i<total; i++)  { 
      //--- tentar obter ticket negócios 
      ticket=HistoryDealGetTicket(i);
      if(ticket > 0)  { 
         //--- obter as propriedades negócios 
         price =HistoryDealGetDouble(ticket,DEAL_PRICE); 
         time  =(datetime)HistoryDealGetInteger(ticket,DEAL_TIME); 
         symbol=HistoryDealGetString(ticket,DEAL_SYMBOL); 
         type  =HistoryDealGetInteger(ticket,DEAL_TYPE); 
         entry =HistoryDealGetInteger(ticket,DEAL_ENTRY); 
         profit=HistoryDealGetDouble(ticket,DEAL_PROFIT); 
         
         //--- apenas para o símbolo atual 
         if (price && time && symbol==Symbol())  { 
            //--- cria o preço do objeto 
            name="TradeHistory_Deal_"+string(ticket); 
         } 
         
         Print("ticket : ", ticket);
         Print("price : ", price);
         Print("time : ", time);
         Print("symbol : ", symbol);
         Print("type : ", type);
         Print("entry : ", entry);
         Print("profit : ", profit);
         Print("name : ", name);
     } 
  } 
}
//+------------------------------------------------------------------+
