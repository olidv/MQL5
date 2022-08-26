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

//program file         SExpertMagicNumber.mqh
//program package      MQL5/Include/ALARA/Trading/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include <ALARA\Trading\Magic\AssetSimbol.mqh>
#include <ALARA\Trading\Magic\BrokerLogin.mqh>
#include <ALARA\Trading\Magic\FillingType.mqh>
#include <ALARA\Trading\Magic\FrameTiming.mqh>
#include <ALARA\Trading\Magic\TradingType.mqh>


//+------------------------------------------------------------------+
//| Structure SMagicCode.                                            |
//|                                                                  |
//| Usage: Mecanismo para lidar com Magic-Numbers em Expert Advisors |
//|        de maneira inteligente, codificando atributos das ordens. |
//+------------------------------------------------------------------+
struct SMagicCode
   {
    EBrokerLogin     brokerLogin;
    EAssetSimbol     assetSimbol;
    EFrameTiming     frameTiming;
    ETradingType     tradingType;
    EFillingType     fillingType;
    bool             modoAssincro;
    uint             idExpertAd;
    uint             seqOperacao;

    //--- Construtor default:
                     SMagicCode();
    //--- Construtor copy:
                     SMagicCode(const SMagicCode& mCode);
    //--- Construtor parametrico:
                     SMagicCode(const ulong magicNumber);

    //--- Encode e decode do magic number:
    void             DecodeMagicNumber(const ulong magicNumber);
    ulong            EncodeMagicNumber() const;
   };


//+------------------------------------------------------------------+
//| Constructor default.                                             |
//+------------------------------------------------------------------+
SMagicCode::SMagicCode() :
    brokerLogin(BROKER_DEMO_METAQUOTES),
    assetSimbol(EncodeSymbol(Symbol())),
    frameTiming(EncodePeriod(Period())),
    tradingType(TRADING_DAY),
    fillingType(FILLING_FOK),
    modoAssincro(false),
    idExpertAd(NULL),
    seqOperacao(0)
   {
    Print("Construtor default SMagicCode() executado");
   }


//+------------------------------------------------------------------+
//| Constructor copy.                                             |
//+------------------------------------------------------------------+
SMagicCode::SMagicCode(const SMagicCode& mCode) :
    brokerLogin(mCode.brokerLogin),
    assetSimbol(mCode.assetSimbol),
    frameTiming(mCode.frameTiming),
    tradingType(mCode.tradingType),
    fillingType(mCode.fillingType),
    modoAssincro(mCode.modoAssincro),
    idExpertAd(mCode.idExpertAd),
    seqOperacao(mCode.seqOperacao)
   {
    Print("Construtor copy SMagicCode(const SMagicCode& mCode) executado");
   }


//+------------------------------------------------------------------+
//| Constructor parametrico.                                         |
//+------------------------------------------------------------------+
SMagicCode::SMagicCode(const ulong magicNumber)
   {
    Print("Inicio Construtor parametrico SMagicCode(", magicNumber, ")");
    DecodeMagicNumber(magicNumber);
    Print("Final Construtor parametrico SMagicCode(", magicNumber, ")");
   }


//+------------------------------------------------------------------+
//| Decodifica o magic-number separando os atributos da operacao.    |
//+------------------------------------------------------------------+
void SMagicCode::DecodeMagicNumber(const ulong magicNumber)
   {
    ulong value = magicNumber;

    Print("Inicio metodo DecodeMagicNumber(", magicNumber, ")");
//---
    this.seqOperacao = uint(value % 100000);
    value /= 100000;

    idExpertAd = uint(value % 1000);
    value /= 1000;

    modoAssincro = bool(value % 10);
    value /= 10;

    fillingType = EFillingType(value % 10);
    value /= 10;

    tradingType = ETradingType(value % 10);
    value /= 10;

    frameTiming = EFrameTiming(value % 10);
    value /= 10;

    assetSimbol = EAssetSimbol(value % 10);
    value /= 10;

    brokerLogin = EBrokerLogin(value % 10);

    Print("Final metodo DecodeMagicNumber(", magicNumber, ")");
   }


//+------------------------------------------------------------------+
//| Codifica os atributos da operacao em um magic-number.            |
//+------------------------------------------------------------------+
ulong SMagicCode::EncodeMagicNumber() const
   {
    Print("Inicio metodo EncodeMagicNumber()");
//---
    ulong magicNumber = brokerLogin;

    magicNumber *= 1000;
    magicNumber += assetSimbol;

    magicNumber *= 100;
    magicNumber += frameTiming;


    magicNumber *= 10;
    magicNumber += tradingType;

    magicNumber *= 10;
    magicNumber += fillingType;

    magicNumber *= 10;
    magicNumber += modoAssincro ? 1 : 0;

    magicNumber *= 1000;
    magicNumber += idExpertAd;

    magicNumber *= 100000;
    magicNumber += seqOperacao;

//---
    Print("Final metodo EncodeMagicNumber()");
    return magicNumber;
   }


//+------------------------------------------------------------------+
