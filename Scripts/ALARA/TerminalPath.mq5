//+------------------------------------------------------------------+
//|                                                 TerminalPath.mq5 |
//|                              Copyright 2021, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  { 
//--- 
   Print("TERMINAL_PATH = ",TerminalInfoString(TERMINAL_PATH)); 
   // TERMINAL_PATH = C:\Apps\B3\MetaTrader 5
   
   Print("TERMINAL_DATA_PATH = ",TerminalInfoString(TERMINAL_DATA_PATH)); 
   // TERMINAL_DATA_PATH = C:\Users\qdev\AppData\Roaming\MetaQuotes\Terminal\9AA5A2E564E1326FB93349159C9D30A4
   
   Print("TERMINAL_COMMONDATA_PATH = ",TerminalInfoString(TERMINAL_COMMONDATA_PATH)); 
   // TERMINAL_COMMONDATA_PATH = C:\Users\qdev\AppData\Roaming\MetaQuotes\Terminal\Common


const string FILE_CARTEIRA_IBOV = "b3_ibov.txt"; // Carteira do IBOV a partir de TERMINAL_DATA_PATH

//int      qtdAtivos;     // Quantidade de ativos na Observação de Mercado
//string   obsAtivos[];   // Armazena a relacao de ativos do observador

  }
//+------------------------------------------------------------------+

