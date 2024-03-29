//+------------------------------------------------------------------+
//|                                                  Zero_Struct.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

#include <ALARA\WinAPI_Time.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
    //---
    MqlTradeRequest trReq;
    MqlTradeResult  trRes;
    
    MqlTradeRequest zrReq;
    MqlTradeResult  zrRes;
    
    ZeroMemory(zrReq);
    ZeroMemory(zrRes);

    MqlTradeRequest irReq;
    ZeroMemory(irReq);   // {0}
    MqlTradeResult  irRes;
    ZeroMemory(irRes);  // {0}
    
    Print("MqlTradeRequest.action = |", trReq.action,"|", zrReq.action,"|", irReq.action,"|");
    Print("MqlTradeRequest.magic = |", trReq.magic,"|", zrReq.magic,"|", irReq.magic,"|");
    Print("MqlTradeRequest.order = |", trReq.order,"|", zrReq.order,"|", irReq.order,"|");
    Print("MqlTradeRequest.symbol = |", trReq.symbol,"|", zrReq.symbol,"|", irReq.symbol,"|");
    Print("MqlTradeRequest.volume = |", trReq.volume,"|", zrReq.volume,"|", irReq.volume,"|");
    Print("MqlTradeRequest.price = |", trReq.price,"|", zrReq.price,"|", irReq.price,"|");
    Print("MqlTradeRequest.stoplimit = |", trReq.stoplimit,"|", zrReq.stoplimit,"|", irReq.stoplimit,"|");
    Print("MqlTradeRequest.sl = |", trReq.sl,"|", zrReq.sl,"|", irReq.sl,"|");
    Print("MqlTradeRequest.tp = |", trReq.tp,"|", zrReq.tp,"|", irReq.tp,"|");
    Print("MqlTradeRequest.deviation = |", trReq.deviation,"|", zrReq.deviation,"|", irReq.deviation,"|");
    Print("MqlTradeRequest.type = |", trReq.type,"|", zrReq.type,"|", irReq.type,"|");
    Print("MqlTradeRequest.type_filling = |", trReq.type_filling,"|", zrReq.type_filling,"|", irReq.type_filling,"|");
    Print("MqlTradeRequest.type_time = |", trReq.type_time,"|", zrReq.type_time,"|", irReq.type_time,"|");
    Print("MqlTradeRequest.expiration = |", trReq.expiration,"|", zrReq.expiration,"|", irReq.expiration,"|");
    Print("MqlTradeRequest.comment = |", trReq.comment,"|", zrReq.comment,"|", irReq.comment,"|");
    Print("MqlTradeRequest.position = |", trReq.position,"|", zrReq.position,"|", irReq.position,"|");
    Print("MqlTradeRequest.position_by = |", trReq.position_by,"|", zrReq.position_by,"|", irReq.position_by,"|");
    Print("---------------------------------------------------");

    //MqlTradeRequest.action = |0|0|0|
    //MqlTradeRequest.magic = |0|0|0|
    //MqlTradeRequest.order = |0|0|0|
    //MqlTradeRequest.symbol = ||||
    //MqlTradeRequest.volume = |2.259305408155172e-313|0.0|0.0|
    //MqlTradeRequest.price = |1.778636325028488e-322|0.0|0.0|
    //MqlTradeRequest.stoplimit = |2.251788218128192e-313|0.0|0.0|
    //MqlTradeRequest.sl = |1.264808053353591e-321|0.0|0.0|
    //MqlTradeRequest.tp = |-nan|0.0|0.0|
    //MqlTradeRequest.deviation = |18446744073709551615|0|0|
    //MqlTradeRequest.type = |-594349947|0|0|
    //MqlTradeRequest.type_filling = |32759|0|0|
    //MqlTradeRequest.type_time = |0|0|0|
    //MqlTradeRequest.expiration = |wrong datetime|1970.01.01 00:00:00|1970.01.01 00:00:00|
    //MqlTradeRequest.comment = ||||
    //MqlTradeRequest.position = |45707391024|0|0|
    //MqlTradeRequest.position_by = |0|0|0|
    //---------------------------------------------------

    //trReq = {0};    // ERRO: uma vez ja declarada a variavel estrutura, nao pode mais atribuir {0} - apenas na declaracao.
    //trReq = irReq;  // OK: mas pode-se atribuir uma estrutura ja inicializada para facilitar/agilizar.
    //trReq.magic = 1234;
    //Print("MqlTradeRequest.action = |", trReq.action,"|", zrReq.action,"|", irReq.action,"|");
    //Print("MqlTradeRequest.magic = |", trReq.magic,"|", zrReq.magic,"|", irReq.magic,"|");
    //Print("MqlTradeRequest.order = |", trReq.order,"|", zrReq.order,"|", irReq.order,"|");
    //Print("MqlTradeRequest.symbol = |", trReq.symbol,"|", zrReq.symbol,"|", irReq.symbol,"|");
    //Print("MqlTradeRequest.volume = |", trReq.volume,"|", zrReq.volume,"|", irReq.volume,"|");
    //Print("MqlTradeRequest.price = |", trReq.price,"|", zrReq.price,"|", irReq.price,"|");
    //Print("MqlTradeRequest.stoplimit = |", trReq.stoplimit,"|", zrReq.stoplimit,"|", irReq.stoplimit,"|");
    //Print("MqlTradeRequest.sl = |", trReq.sl,"|", zrReq.sl,"|", irReq.sl,"|");
    //Print("MqlTradeRequest.tp = |", trReq.tp,"|", zrReq.tp,"|", irReq.tp,"|");
    //Print("MqlTradeRequest.deviation = |", trReq.deviation,"|", zrReq.deviation,"|", irReq.deviation,"|");
    //Print("MqlTradeRequest.type = |", trReq.type,"|", zrReq.type,"|", irReq.type,"|");
    //Print("MqlTradeRequest.type_filling = |", trReq.type_filling,"|", zrReq.type_filling,"|", irReq.type_filling,"|");
    //Print("MqlTradeRequest.type_time = |", trReq.type_time,"|", zrReq.type_time,"|", irReq.type_time,"|");
    //Print("MqlTradeRequest.expiration = |", trReq.expiration,"|", zrReq.expiration,"|", irReq.expiration,"|");
    //Print("MqlTradeRequest.comment = |", trReq.comment,"|", zrReq.comment,"|", irReq.comment,"|");
    //Print("MqlTradeRequest.position = |", trReq.position,"|", zrReq.position,"|", irReq.position,"|");
    //Print("MqlTradeRequest.position_by = |", trReq.position_by,"|", zrReq.position_by,"|", irReq.position_by,"|");
    //Print("---------------------------------------------------");

    Print("MqlTradeResult.retcode = |", trRes.retcode,"|", zrRes.retcode,"|", irRes.retcode,"|");
    Print("MqlTradeResult.deal = |", trRes.deal,"|", zrRes.deal,"|", irRes.deal,"|");
    Print("MqlTradeResult.order = |", trRes.order,"|", zrRes.order,"|", irRes.order,"|");
    Print("MqlTradeResult.volume = |", trRes.volume,"|", zrRes.volume,"|", irRes.volume,"|");
    Print("MqlTradeResult.price = |", trRes.price,"|", zrRes.price,"|", irRes.price,"|");
    Print("MqlTradeResult.bid = |", trRes.bid,"|", zrRes.bid,"|", irRes.bid,"|");
    Print("MqlTradeResult.ask = |", trRes.ask,"|", zrRes.ask,"|", irRes.ask,"|");
    Print("MqlTradeResult.comment = |", trRes.comment,"|", zrRes.comment,"|", irRes.comment,"|");
    Print("MqlTradeResult.request_id = |", trRes.request_id,"|", zrRes.request_id,"|", irRes.request_id,"|");
    Print("MqlTradeResult.retcode_external = |", trRes.retcode_external,"|", zrRes.retcode_external,"|", irRes.retcode_external,"|");
    Print("---------------------------------------------------");

    //MqlTradeResult.retcode = |2614427648|0|0|
    //MqlTradeResult.deal = |32758|0|0|
    //MqlTradeResult.order = |15848294151029260288|0|0|
    //MqlTradeResult.volume = |-2.642872504999488e-127|0.0|0.0|
    //MqlTradeResult.price = |-1.036906778364611e-129|0.0|0.0|
    //MqlTradeResult.bid = |-5.49767509130035e-171|0.0|0.0|
    //MqlTradeResult.ask = |4.940656458412465e-323|0.0|0.0|
    //MqlTradeResult.comment = ||||
    //MqlTradeResult.request_id = |0|0|0|
    //MqlTradeResult.retcode_external = |0|0|0|
    //---------------------------------------------------
    

    MqlDateTime stDatetime;
    MqlDateTime ztDatetime; // = {0};

    Print("MqlDateTime.year = |", stDatetime.year,"|", ztDatetime.year);
    Print("MqlDateTime.mon = |", stDatetime.mon,"|", ztDatetime.mon);
    Print("MqlDateTime.day = |", stDatetime.day,"|", ztDatetime.day);
    Print("MqlDateTime.day_of_year = |", stDatetime.day_of_year,"|", ztDatetime.day_of_year);
    Print("MqlDateTime.day_of_week = |", stDatetime.day_of_week,"|", ztDatetime.day_of_week);
    Print("MqlDateTime.hour = |", stDatetime.hour,"|", ztDatetime.hour);
    Print("MqlDateTime.min = |", stDatetime.min,"|", ztDatetime.min);
    Print("MqlDateTime.sec = |", stDatetime.sec,"|", ztDatetime.sec);
    Print("---------------------------------------------------");
        
    Print("SystemTimeToString() = ", SystemTimeToString());
    Print("GetMillisecondsDatetime() = ", GetMillisecondsDatetime());
    Print("GetMillisecondsTime() = ", GetMillisecondsTime());
    Print("GetMillisecondsDate() = ", GetMillisecondsDate());
    Print("GetDatetime() = ", GetDatetime());
    Print("GetDate() = ", GetDate());
    Print("HOJE_MILISSEGUNDOS = ", HOJE_MILISSEGUNDOS);
    
    Print("---------------------------------------------------");
        
    
    
    
    
    ulong ZeroMemoryCont = 0;
    ulong InitStructCont = 0;
    
    for (int i = 0; i < 10000; i++) {

        ulong step1 = GetMicrosecondCount();
        for (int j = 0; j < i; j++) {
            ZeroMemoryStruct();
            ulong x = 0;
            x += 10;
        }
        ulong step2 = GetMicrosecondCount();

        for (int j = 0; j < i; j++) {
            InitStruct();
            ulong x = 0;
            x += 10;
        }
        ulong step3 = GetMicrosecondCount();
       
        ZeroMemoryCont += (step2 - step1);       
        InitStructCont += (step3 - step2);       
    }
    
    Print("ZeroMemoryCont = ", ZeroMemoryCont, " microseconds");
    Print("InitStructCont = ", InitStructCont, " microseconds");
    if (ZeroMemoryCont >= InitStructCont) {
        Print("ZeroMemoryCont - InitStructCont = ", ZeroMemoryCont - InitStructCont, " microseconds");
        Print("---------------------------------------------------");
    } else {
        Print("InitStructCont - ZeroMemoryCont = ", InitStructCont - ZeroMemoryCont, " microseconds");
        Print("---------------------------------------------------");
    }
    
    //ZeroMemoryCont = 442 microseconds
    //InitStructCont = 307 microseconds
    //ZeroMemoryCont - InitStructCont = 135 microseconds
    //---------------------------------------------------
}

void ZeroMemoryStruct() {
    MqlTradeRequest trReq;
    ZeroMemory(trReq);

//    trReq.action = TRADE_ACTION_DEAL;
//    trReq.magic = 0;
//    trReq.order = 0;
//    trReq.symbol = "ABC";
//    trReq.volume = 10;
//    trReq.price = 10.2;
//    trReq.stoplimit = 100.7;
//    trReq.sl = 200.87;
//    trReq.tp = 300.34;
//    trReq.deviation = 0;
//    trReq.type = 0;
//    trReq.type_filling = 0;
//    trReq.type_time = 0;
//    trReq.expiration = TimeCurrent();
//    trReq.comment = "comentário";
//    trReq.position = 0;
//    trReq.position_by = 0;
    
    MqlTradeRequest trReq1;
    ZeroMemory(trReq1);

    MqlTradeRequest trReq2;
    ZeroMemory(trReq2);
    
    MqlTradeRequest trReq3;
    ZeroMemory(trReq3);

    MqlTradeRequest trReq4;
    ZeroMemory(trReq4);
    
    MqlTradeRequest trReq5;
    ZeroMemory(trReq5);

    MqlTradeRequest trReq6;
    ZeroMemory(trReq6);
}


void InitStruct() {
    MqlTradeRequest trReq; // = {0};

    //trReq.action = TRADE_ACTION_DEAL;
    //trReq.magic = 0;
    //trReq.order = 0;
    //trReq.symbol = "ABC";
    //trReq.volume = 10;
    //trReq.price = 10.2;
    //trReq.stoplimit = 100.7;
    //trReq.sl = 200.87;
    //trReq.tp = 300.34;
    //trReq.deviation = 0;
    //trReq.type = 0;
    //trReq.type_filling = 0;
    //trReq.type_time = 0;
    //trReq.expiration = TimeCurrent();
    //trReq.comment = "comentário";
    //trReq.position = 0;
    //trReq.position_by = 0;
    
    MqlTradeRequest trReq1; // = {0};
    MqlTradeRequest trReq2; // = {0};
    MqlTradeRequest trReq3; // = {0};
    MqlTradeRequest trReq4; // = {0};
    MqlTradeRequest trReq5; // = {0};
    MqlTradeRequest trReq6; // = {0};
}

//+------------------------------------------------------------------+
