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

//program file         AssetSimbol.mqh
//program package      MQL5/Include/ALARA/Trading/Magic/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************

#property library


//+------------------------------------------------------------------+
//| Enumeration EAssetSimbol.                                       |
//|                                                                  |
//| Usage: Informa a identificacao do ativo operado (B3 / FOREX).    |
//+------------------------------------------------------------------+
enum EAssetSimbol
   {
//--- Contratos de Mercado Futuro da Bolsa de Valores B3:
    ASSET_B3_FUT_IND       = 1,   //
    ASSET_B3_FUT_WIN       = 2,   //
    ASSET_B3_FUT_DOL       = 3,   //
    ASSET_B3_FUT_WDO       = 4,   //
    ASSET_B3_FUT_ISP       = 5,   //
    ASSET_B3_FUT_WSP       = 6,   //

//--- Acoes de Mercado a Vista da Bolsa de Valores B3:
    ASSET_B3_VTA_PETR3     = 107,   //
    ASSET_B3_VTA_PETR4     = 108,   //

//--- Opcoes de Acoes da Bolsa de Valores B3:
    ASSET_B3_OPC_PETRU369   = 407,   //
    ASSET_B3_OPC_PETRI443   = 408,   //


//--- Pares de Moedas do Mercado de Cambio FOREX:
    ASSET_FX_PAR_EURUSD    = 801,   //
   };


//+------------------------------------------------------------------+
//| Converte um simbolo (string) para sua representacao EAssetSimbol.|
//+------------------------------------------------------------------+
EAssetSimbol EncodeSymbol(const string simbolo)
   {
//--- Pares de Moedas do Mercado de Cambio FOREX:
    if(simbolo == "EURUSD")
        return ASSET_FX_PAR_EURUSD;

//--- Opcoes de Acoes da Bolsa de Valores B3:
    if(simbolo == "PETRU369")
        return ASSET_B3_OPC_PETRU369;

    if(simbolo == "PETRI443")
        return ASSET_B3_OPC_PETRI443;

//--- Acoes de Mercado a Vista da Bolsa de Valores B3:
    if(simbolo == "PETR3")
        return ASSET_B3_VTA_PETR3;

    if(simbolo == "PETR4")
        return ASSET_B3_VTA_PETR4;

//--- Contratos de Mercado Futuro da Bolsa de Valores B3:
    const string contrato = StringSubstr(simbolo, 0, 3);

    if(simbolo == "IND")
        return ASSET_B3_FUT_IND;

    if(simbolo == "WIN")
        return ASSET_B3_FUT_WIN;

    if(simbolo == "DOL")
        return ASSET_B3_FUT_DOL;

    if(simbolo == "WDO")
        return ASSET_B3_FUT_WDO;

    if(simbolo == "ISP")
        return ASSET_B3_FUT_ISP;

    if(simbolo == "WSP")
        return ASSET_B3_FUT_WSP;

//--- se nao encontrar o simbolo, retorna o "default" mini contrato de ibovespa.
    return ASSET_B3_FUT_WIN;
   }


//+------------------------------------------------------------------+
//| Converte um valor EAssetSimbol para respectivo simbolo (string). |
//+------------------------------------------------------------------+
string DecodeSymbol(const EAssetSimbol simbolo)
   {
    switch(simbolo)
       {
        //--- Pares de Moedas do Mercado de Cambio FOREX:
        case ASSET_FX_PAR_EURUSD:
            return "EURUSD";

        //--- Opcoes de Acoes da Bolsa de Valores B3:
        case ASSET_B3_OPC_PETRU369:
            return "PETRU369";

        case ASSET_B3_OPC_PETRI443:
            return "PETRI443";

        //--- Acoes de Mercado a Vista da Bolsa de Valores B3:
        case ASSET_B3_VTA_PETR3:
            return "PETR3";

        case ASSET_B3_VTA_PETR4:
            return "PETR4";

        //--- Contratos de Mercado Futuro da Bolsa de Valores B3:
        case ASSET_B3_FUT_IND:
            return "IND";

        case ASSET_B3_FUT_WIN:
            return "WIN";

        case ASSET_B3_FUT_DOL:
            return "DOL";

        case ASSET_B3_FUT_WDO:
            return "WDO";

        case ASSET_B3_FUT_ISP:
            return "ISP";

        case ASSET_B3_FUT_WSP:
            return "WSP";

        //--- improvavel, mas para evitar erro de compilacao...
        default:
            return NULL;
       }
   }


//+------------------------------------------------------------------+
