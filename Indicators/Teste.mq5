#property indicator_chart_window

int OnInit()
  {
   Comment("Hello World!");
   return(INIT_SUCCEEDED);
  }

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
   return(rates_total);
  }
