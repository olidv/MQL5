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
    ulong            NextMagicNumber();
    string           ToString() const;
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
   {}


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
   {}


//+------------------------------------------------------------------+
//| Constructor parametrico.                                         |
//+------------------------------------------------------------------+
SMagicCode::SMagicCode(const ulong magicNumber)
   {
    DecodeMagicNumber(magicNumber);
   }


//+------------------------------------------------------------------+
//| Decodifica o magic-number separando os atributos da operacao.    |
//+------------------------------------------------------------------+
void SMagicCode::DecodeMagicNumber(const ulong magicNumber)
   {
    ulong value = magicNumber;

//--- 5 digitos para o sequencia da operacao:
    seqOperacao = uint(value % 100000);
    value /= 100000;

//--- 3 digitos para a identificacao do Expert Advisor:
    idExpertAd = uint(value % 1000);
    value /= 1000;

//--- 1 digito para o modo assincrono ou sincrono:
    modoAssincro = bool(value % 10);
    value /= 10;

//--- 1 digito para o tipo de preenchimento:
    fillingType = EFillingType(value % 10);
    value /= 10;

//--- 1 digito para o tipo de trading:
    tradingType = ETradingType(value % 10);
    value /= 10;

//--- 2 digitos para o tempo do grafico:
    frameTiming = EFrameTiming(value % 100);
    value /= 100;

//--- 3 digitos para o simbolo do ativo:
    assetSimbol = EAssetSimbol(value % 1000);
    value /= 1000;

//--- 2 digitos para o tipo de conta e a corretora:
    brokerLogin = EBrokerLogin(value % 100);
   }


//+------------------------------------------------------------------+
//| Codifica os atributos da operacao em um magic-number.            |
//+------------------------------------------------------------------+
ulong SMagicCode::EncodeMagicNumber() const
   {
//--- 2 digitos para o tipo de conta e a corretora:
    ulong magicNumber = (ulong) brokerLogin;

//--- 3 digitos para o simbolo do ativo:
    magicNumber *= 1000;
    magicNumber += assetSimbol;

//--- 2 digitos para o tempo do grafico:
    magicNumber *= 100;
    magicNumber += frameTiming;

//--- 1 digito para o tipo de trading:
    magicNumber *= 10;
    magicNumber += tradingType;

//--- 1 digito para o tipo de preenchimento:
    magicNumber *= 10;
    magicNumber += fillingType;

//--- 1 digito para o modo assincrono ou sincrono:
    magicNumber *= 10;
    if(modoAssincro)
        ++magicNumber;

//--- 3 digitos para a identificacao do Expert Advisor:
    magicNumber *= 1000;
    magicNumber += idExpertAd;

//--- 5 digitos para o sequencia da operacao:
    magicNumber *= 100000;
    magicNumber += seqOperacao;

//---
    return magicNumber;
   }


//+------------------------------------------------------------------+
//| Incrementa o sequencial da operacao e gera novo Magic-Number.    |
//+------------------------------------------------------------------+
ulong SMagicCode::NextMagicNumber()
   {
//--- posiciona no proximo sequencial da operacao:
    ++seqOperacao;

//--- gera o magic-number:
    return EncodeMagicNumber();
   }


//+------------------------------------------------------------------+
//| Gera string com representacao do estado da estrutura.            |
//+------------------------------------------------------------------+
string SMagicCode::ToString() const
   {
    string repr = "SMagicCode{\n" +
                  "    brokerLogin = " + EnumToString(brokerLogin) +
                  ",\n    assetSimbol = " + EnumToString(assetSimbol) +
                  ",\n    frameTiming = " + EnumToString(frameTiming) +
                  ",\n    tradingType = " + EnumToString(tradingType) +
                  ",\n    fillingType = " + EnumToString(fillingType) +
                  ",\n    modoAssincro = " + IntegerToString(modoAssincro) +
                  ",\n    idExpertAd = " + IntegerToString(idExpertAd) +
                  ",\n    seqOperacao = " + IntegerToString(seqOperacao) +
                  "\n}";
    return repr;
   }


//+------------------------------------------------------------------+
