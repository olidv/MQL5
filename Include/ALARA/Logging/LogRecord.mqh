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

//program file         
//program package      MQL5/Include/ALARA/
#property version	   "1.000"
#property description  "..."

//**********************************************************************************************  

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include "LogLevel.mqh"


//+------------------------------------------------------------------+
//| Structure SLogRecord.                                            |
//|                                                                  |
//| Usage: Registro das informacoes utilizadas no registro do        |
//|        do logging para formatacao e publicacao.                  |
//+------------------------------------------------------------------+
struct SLogRecord final
   {
    ELogLevel        level;       // [%level]  Level da mensagem de logging
    datetime         timestamp;   // [%time]   Data-hora no momento da chamada
    string           package;     // [%pack]   Package do programa onde foi feita a chamada
    string           program;     // [%prog]   Nome do programa onde foi feita a chamada
    string           function;    // [%func]   Nome do metodo onde foi feita a chamada
    ushort           line;        // [%line]   Numero da linha onde foi feita a chamada

    string           name;        // [%name]   Nome do logger que foi executado
    string           message;     // [%msg]    Texto original da mensagem

    SLogRecord       operator+ (const string msg)
       {
        this.message = msg;
        return this;
       }
   };


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel de rastreio/Trace.       |
//+------------------------------------------------------------------+
SLogRecord LogRecordTrace(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_TRACE, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel Debug.                   |
//+------------------------------------------------------------------+
SLogRecord LogRecordDebug(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_DEBUG, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel Informativo.             |
//+------------------------------------------------------------------+
SLogRecord LogRecordInfo(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_INFO, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel de alerta/aviso.         |
//+------------------------------------------------------------------+
SLogRecord LogRecordWarn(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_WARN, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel de Erro.                 |
//+------------------------------------------------------------------+
SLogRecord LogRecordError(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_ERROR, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Cria novo registro de logging com nivel Fatal.                   |
//+------------------------------------------------------------------+
SLogRecord LogRecordFatal(string pathProgram, string file, string function, ushort line) export
   {
    SLogRecord srec = {LOG_LEVEL_FATAL, TimeLocal(), getPackage(pathProgram), file, function, line};

    return srec;
   }


//+------------------------------------------------------------------+
//| Transforma o path do programa em forma de pacote <aa.bb.cc>.     |
//+------------------------------------------------------------------+
string getPackage(string pathProgram)
   {
// De    C:\Users\qdev\AppData\Roaming\MetaQuotes\Terminal\9AA5A2E564E1326FB93349159C9D30A4\MQL5\Experts\ALARA\Logging.mq5
// Para  Experts.ALARA.Logging
    static string TERM_DATA_PATH = TerminalInfoString(TERMINAL_DATA_PATH);
    static int    PACK_INIT_PATH = StringLen(TERM_DATA_PATH) + 6;  // ...\MQL5\...

    string package = pathProgram;
    if(StringFind(pathProgram, TERM_DATA_PATH) == 0)
       {
        int endPath = StringLen(pathProgram) - PACK_INIT_PATH - 4;
        package = StringSubstr(pathProgram, PACK_INIT_PATH, endPath);
        StringReplace(package, "\\", ".");
       }

    return package;
   }


//+------------------------------------------------------------------+
