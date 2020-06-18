// Simple example to show how to use the extension.
// Open a positions and a pending orders, put SL and TP to see the results.

// Risk/reward function only work with one order each time by ticket (ID).
// In this case we use the generic symbol identification, it means the first.
// Only after determine SL and TP the risk/reward will be calculated.

// You can modify each day and month, translate, for example. Default is english.

#property indicator_chart_window
#property indicator_plots 0
#include <SymbolTradeMadeSimple.mqh>
string abc;

int OnInit()
  {
    SymbolChartClean(ChartID(),false,false,false);
    return(INIT_SUCCEEDED);
  }

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
    Comment("=== This symbol was CLENAED ==="+
           "\n"+ChartID()+
           "\n=== This symbol ==="+
           "\n"+
           "\n"+_Symbol+" "+SymbolTimeframe()+
           "\n"+
           "\nFloating result: "+SymbolOpenResult(_Symbol)+
           "\nFloating pips: "+NormalizeDouble(SymbolOpenPips(_Symbol),2)+
           "\nFloating percentage: "+SymbolOpenPercentage(_Symbol)+"%"+
           "\n"+
           "\nOpen positions: "+SymbolOpenPositionsTotal(_Symbol)+
           "\nOpen volume: "+SymbolOpenPositionsVolume(_Symbol)+
           "\nPosition risk/reward: 1:"+SymbolRiskRewardSL(_Symbol,PositionSelect(_Symbol),true)+
           "\n"+
           "\nPending orders: "+SymbolPendingOrdersTotal(_Symbol)+
           "\nPending volume: "+SymbolPendingOrdersVolume(_Symbol)+
           "\n"+
           "\n=== This account ==="+
           "\nMode: "+AccountMode()+
           "\nType: "+AccountType()+
           "\n"+
           "\n=== Others ==="+
           "\nCandle time: "+CandleTime(_Symbol,_Period)+
           "\nDay of week string: "+AccountDayOfWeek()+ // You can modify each day, translate, for example. Default is english.
           "\nDay of week integer: "+AccountDayOfWeekInt()+
           "\nMonth of year: "+AccountMonthOfYear()+ // You can modify each month, translate, for example. Default is english.
           "\n"+
           "\nActual time: "+TimeCurrent()+
           "\nActual time minus 5 hours: "+FixDatetimeHours(TimeCurrent(),5,true)+
           "\nActual time minus 5 minutes: "+FixDatetimeMinutes(TimeCurrent(),5,true)+
           "\nActual time minus 5 seconds: "+FixDatetimeSeconds(TimeCurrent(),5,true)
           );
    return(rates_total);
  }