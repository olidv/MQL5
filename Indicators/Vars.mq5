#property indicator_chart_window

int teste = 0;

int OnInit()
  {
   return(INIT_SUCCEEDED);
  }

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
   if (teste <= 100)
   {
    Comment(teste + " | O valor é menor ou igual que 100");
   }
   else
   {
    Comment(teste + " | O valor passou de 100");
   }

   teste += 1;

   return(rates_total);
  }
