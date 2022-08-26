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

//program file         ChartAppender.mqh
//program package      MQL5/Include/ALARA/Logging/Append/
#property version	   "1.000"
#property description  "..."

//**********************************************************************************************  

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include "AbstractAppender.mqh"


//+------------------------------------------------------------------+
//| Class CChartAppender.                                            |
//|                                                                  |
//| Usage: Registro das mensagens de logging diretamente no grafico. |
//+------------------------------------------------------------------+
class CChartAppender: public CAbstractAppender
   {
protected:
    //--- Grava o registro de logging.
    virtual bool        doAppend(const SLogRecord &record);

public:
    //--- Construtores: Inicializa o layout utilizado internamente na formatacao.
    void                CChartAppender(const string name,
                                       const ELogLevel level,
                                       IFormatter *formatter) : CAbstractAppender(name, level, formatter) {};

    //--- Informa o tipo de processamento e destinatario do appender:
    virtual EAppendType getAppendType();
   };


//+------------------------------------------------------------------+
//| Informa o tipo deste appender.                                   |
//+------------------------------------------------------------------+
EAppendType CChartAppender::getAppendType()
   {
    return APPEND_CHART;
   }


//+------------------------------------------------------------------+
//| Imprime o registro de logging diretamente no grafico corrente.   |
//+------------------------------------------------------------------+
bool CChartAppender::doAppend(const SLogRecord &record)
   {
// formata a mensagem utilizando o formatter interno:
    string msg = getFormatter().formatMessage(record);

// este appender apenas printa a mensagem formatada no grafico corrente:
    Comment(msg);

    return true;
   }


//+------------------------------------------------------------------+
