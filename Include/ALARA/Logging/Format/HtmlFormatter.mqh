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

//program file         HtmlFormatter.mqh
//program package      MQL5/Include/ALARA/Logging/Format/
#property version	   "1.000"
#property description  "..."

//**********************************************************************************************  

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include "AbstractFormatter.mqh"


//+------------------------------------------------------------------+
//| Class CHtmlFormatter.                                            |
//|                                                                  |
//| Usage: Definicao de metodos para as classes concretas que        |
//|        efetuam a formatacao das mensagens de logging.            |
//+------------------------------------------------------------------+
class CHtmlFormatter: public CAbstractFormatter
   {
public:
    //--- Construtores: Inicializa o layout utilizado internamente na formatacao.
    void                CHtmlFormatter(const string layout) : CAbstractFormatter(layout) {};


    //--- Informa o tipo de formato do layout utilizado:
    virtual EFormatType getFormatType();

    //--- Formata um registro de logging de acordo com o layout interno.
    virtual string      formatMessage(const SLogRecord &record);
   };


//+------------------------------------------------------------------+
//| Informa o tipo de formato do layout utilizado.                   |
//+------------------------------------------------------------------+
EFormatType CHtmlFormatter::getFormatType()
   {
    return FORMAT_HTML;
   }

//+------------------------------------------------------------------+
//| Formata um registro de logging de acordo com o layout interno.   |
//+------------------------------------------------------------------+
string CHtmlFormatter::formatMessage(const SLogRecord &record)
   {
// este metodo interno ja efetua toda a validacao necessaria:
    string msg = compilePattern(record);

// retorna a mensagem de logging em uma unica linha (texto simples).
    return msg;
   }


//+------------------------------------------------------------------+
