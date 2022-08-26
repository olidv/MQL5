//+------------------------------------------------------------------+
//|                                                     OlaMundo.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"


#include <ALARA\Trading\Magic\MagicCode.mqh>

//struct Info
//   {
//    double           a;
//    double           b;
//    double           c;
//
//                     Info() : a(1.1), b(2.2), c(3.3)                          { Print("Construtor default Info() executado");}
//                     Info(double pa, double pb, double pc) : a(pa), b(pb), c(pc)    {Print("Construtor parametrico Info(double pa, double pb, double pc) executado");}
//
//    Info              TestFactory(const double pa, const double pb, const double pc) const;
//    static Info       StaticFactory(const double pa, const double pb, const double pc);
//   };
//
////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//Info Info::TestFactory(const double pa, const double pb, const double pc) const
//   {
//    Print("Inicio Metodo TestFactory(pa, pb, pc)");
//    Info result(pa, pb, pc);
//    Print("Final Metodo TestFactory(pa, pb, pc)");
//    return result;
//   }
//
////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//static Info Info::StaticFactory(const double pa, const double pb, const double pc)
//   {
//    Print("Inicio Metodo StaticFactory(pa, pb, pc)");
//    Info result(pa, pb, pc);
//    Print("Final Metodo StaticFactory(pa, pb, pc)");
//    return result;
//   }

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
   {
//---
//    datetime hoje = D'01.01.2016 13:43:23';
//
//    Alert("titulo qualquer", 234, false, TimeCurrent());
//
//    Sleep(5000);
//
//    Alert("segundo titulo", 2, true, TimeCurrent());

//int i = NULL;
//PrintFormat("Teste PrintFormat: %d", NULL);


//int i = 0;
//Print(LogFormat("Teste 1 de logging: %s %f %d", "i", 6.7, TimeLocal()));
//Print(LogFormat("Teste 2 de logging: %d %d %d", i));
//Print(LogFormat("Teste 3 de logging: %d %f %d ", i, 6.7));


//--- get possible filling policy types by symbol

//Print("\nORDER_FILLING_FOK = ", ORDER_FILLING_FOK);
//Print("ORDER_FILLING_IOC = ", ORDER_FILLING_IOC);
//Print("ORDER_FILLING_RETURN = ", ORDER_FILLING_RETURN);

//Print("\n\tSYMBOL_FILLING_FOK = ", SYMBOL_FILLING_FOK);
//Print("\tSYMBOL_FILLING_IOC = ", SYMBOL_FILLING_IOC);

//    uint filling = (uint) SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE);
//    Print("Simbolo ", Symbol(), " tem preenchimento SYMBOL_FILLING_MODE = ", filling);
//
//    if((filling & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
//       {
//        Print("    Simbolo ", Symbol(), " tem preenchimento SYMBOL_FILLING_FOK.");
//       }
//
//    if((filling&SYMBOL_FILLING_IOC)==SYMBOL_FILLING_IOC)
//       {
//        Print("    Simbolo ", Symbol(), " tem preenchimento SYMBOL_FILLING_IOC.");
//       }


//ENUM_SYMBOL_TRADE_EXECUTION exec = (ENUM_SYMBOL_TRADE_EXECUTION) SymbolInfoInteger(Symbol(), SYMBOL_TRADE_EXEMODE);
//Print(Symbol(), " : SYMBOL_TRADE_EXEMODE = ", EnumToString(exec));

//    Print("ENUM_TIMEFRAMES:");
//    Print("    PERIOD_M1 = ", PERIOD_M1);
//    Print("    PERIOD_M2 = ", PERIOD_M2);
//    Print("    PERIOD_M3 = ", PERIOD_M3);
//    Print("    PERIOD_M4 = ", PERIOD_M4);
//    Print("    PERIOD_M5 = ", PERIOD_M5);
//    Print("    PERIOD_M6 = ", PERIOD_M6);
//    Print("    PERIOD_M10 = ", PERIOD_M10);
//    Print("    PERIOD_M12 = ", PERIOD_M12);
//    Print("    PERIOD_M15 = ", PERIOD_M15);
//    Print("    PERIOD_M20 = ", PERIOD_M20);
//    Print("    PERIOD_M30 = ", PERIOD_M30);
//
//    Print("    PERIOD_H1 = ", PERIOD_H1);
//    Print("    PERIOD_H2 = ", PERIOD_H2);
//    Print("    PERIOD_H3 = ", PERIOD_H3);
//    Print("    PERIOD_H4 = ", PERIOD_H4);
//    Print("    PERIOD_H6 = ", PERIOD_H6);
//    Print("    PERIOD_H8 = ", PERIOD_H8);
//    Print("    PERIOD_H12 = ", PERIOD_H12);
//
//    Print("    PERIOD_D1 = ", PERIOD_D1);
//    Print("    PERIOD_W1 = ", PERIOD_W1);
//    Print("    PERIOD_MN1 = ", PERIOD_MN1);
//    Print("    PERIOD_CURRENT = ", PERIOD_CURRENT);
//
//    Print("\n(uint) (234567 / 1000) = ", (uint) (234567 / 1000));
//    Print("(uint) (234567 % 1000) = ", (uint) (234567 % 1000));
//
//    Print("\n(uint) 234567 / 1000 = ", (uint) 234567 / 1000);
//    Print("(uint) 234567 % 1000 = ", (uint) 234567 % 1000);
//
//    Print("\n234567 / 1000 = ", 234567 / 1000);
//    Print("234567 % 1000 = ", 234567 % 1000);~


//    Print("Vai declarar estruturas");
//    Info info1, info2, info3;
//    Print("estruturas inicializadas");
//
//    info2 = info1.TestFactory(4.4, 5.5, 6.6);
//    Print("estrutura info2 inicializada");
//    info3 = Info::StaticFactory(7.7, 8.8, 9.9);
//    Print("estrutura info3 inicializada");
//
//    Print(info1.a); // Prints 1.1 OK!
//    Print(info2.a); // Prints 4.4 OK!
//    Print(info3.a); // Prints 1.1 ERROR! should be 7.7
//
//    double a = 3.4;
//    double b = 3.4;
//    double c = 3.4;
//    Info varInfo(a, b, c);


    SMagicCode mCode;
    Print("SMagicCode.brokerLogin  = ", EnumToString(mCode.brokerLogin));
    Print("SMagicCode.assetSimbol  = ", EnumToString(mCode.assetSimbol));
    Print("SMagicCode.frameTiming  = ", EnumToString(mCode.frameTiming));
    Print("SMagicCode.tradingType  = ", EnumToString(mCode.tradingType));
    Print("SMagicCode.fillingType  = ", EnumToString(mCode.fillingType));
    Print("SMagicCode.modoAssincro = ", mCode.modoAssincro);
    Print("SMagicCode.idExpertAd   = ", mCode.idExpertAd);
    Print("SMagicCode.seqOperacao  = ", mCode.seqOperacao);

    Print("\n Magic-Number = ", mCode.EncodeMagicNumber(),"/n");
    
    SMagicCode mCode2(mCode.EncodeMagicNumber());
    Print("SMagicCode.brokerLogin  = ", EnumToString(mCode2.brokerLogin));
    Print("SMagicCode.assetSimbol  = ", EnumToString(mCode2.assetSimbol));
    Print("SMagicCode.frameTiming  = ", EnumToString(mCode2.frameTiming));
    Print("SMagicCode.tradingType  = ", EnumToString(mCode2.tradingType));
    Print("SMagicCode.fillingType  = ", EnumToString(mCode2.fillingType));
    Print("SMagicCode.modoAssincro = ", mCode2.modoAssincro);
    Print("SMagicCode.idExpertAd   = ", mCode2.idExpertAd);
    Print("SMagicCode.seqOperacao  = ", mCode2.seqOperacao);

   }


//+------------------------------------------------------------------+
