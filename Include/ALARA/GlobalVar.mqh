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

//program file         GlobalVar.mqh
//program package      MQL5/Include/ALARA/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include <Object.mqh>
#include <ALARA\BR_EvE.mqh>  // Funcoes utilitarias de uso geral (Enumerators e Evaluators).


//+------------------------------------------------------------------+
//| Class CGlobalVar.                                                |
//|                                                                  |
//| Usage: Classe helper para manutencao de variaveis globais.       |
//+------------------------------------------------------------------+
class CGlobalVar : public CObject
   {
private:
    //--- Declaracao das variaveis de instancia (propriedades):
    string           m_name;
    bool             m_isTemp;

    //--- Metodos privados.

public:
    //--- Construtor default:
    void             CGlobalVar(void) : m_name(NULL), m_isTemp(false)
       {};

    //--- Construtor parametrico:
    void             CGlobalVar(const string name, const bool is_temp = false):
                     m_name(name),
                     m_isTemp(is_temp)
       {
        //--- para o caso da variavel ja existir, exclui para evitar conflitos:
        GlobalVariableDel(name);

        // cria a variavel global, ainda que com valor NULL:
        if(is_temp)
            GlobalVariableTemp(name);
        else
            GlobalVariableSet(name, NULL);
       };

    //--- Destrutor default:
    void             ~CGlobalVar(void)
       {
        //--- elimina a variavel global do terminal:
        if(isNotEmpty(m_name))
            GlobalVariableDel(m_name);
       };

    //--- :
    int              Total() const
       {
        return GlobalVariablesTotal();
       };

    //--- :
    string           Name(void) const
       {
        return m_name;
       };

    //--- :
    string           Name(const int index) const
       {
        return GlobalVariableName(index);
       };

    //--- :
    bool             Names(string& array[]) const
       {
        ResetLastError();
        const int size = GlobalVariablesTotal();
        if(_LastError != 0)
            return false;

        ArrayResize(array, size);
        for(int i = 0; i < size; i++)
           {
            array[i] = GlobalVariableName(i);
            if(_LastError != 0)
                return false;
           }

        return true;
       };


    //--- :
    bool             Names(string& array[], const string prefix_name) const
       {
        ResetLastError();
        const int total = GlobalVariablesTotal();
        if(_LastError != 0)
            return false;

        int lenPrefix = StringLen(prefix_name);
        int size = 0;
        for(int i = 0; i < size; i++)
           {
            string varName = GlobalVariableName(i);
            if(_LastError != 0)
                return false;

            if(StringLen(varName) >= lenPrefix && prefix_name == StringSubstr(varName, 0, lenPrefix))
               {
                ArrayResize(array, size + 1);
                array[size++] = GlobalVariableName(i);
               }
           }

        return true;
       };

    //--- :
    datetime         LastTime(void) const
       {
        return GlobalVariableTime(m_name);
       };

    //--- :
    datetime         LastTime(const string name) const
       {
        return GlobalVariableTime(name);
       };

    //--- :
    bool             Exists(void) const
       {
        return GlobalVariableCheck(m_name);
       };

    //--- :
    bool             Exists(const string name) const
       {
        return GlobalVariableCheck(name);
       };

    //--- :
    bool             IsTemp(void) const
       {
        return m_isTemp;
       };

    //--- :
    double           Get(void) const
       {
        return GlobalVariableGet(m_name);
       };

    //--- :
    double           Get(const string name, const double defValue = NULL) const
       {
        if(Exists(name))
            return GlobalVariableGet(name);
        else
            return defValue;
       };

    //--- :
    void             Put(const double value) const
       {
        GlobalVariableSet(m_name, value);
       };

    //--- :
    void             Put(const string name, const double value) const
       {
        GlobalVariableSet(name, value);
       };

    //--- :
    bool             PutOnCondition(const double value, const double check_value) const
       {
        return GlobalVariableSetOnCondition(m_name, value, check_value);
       };

    //--- :
    bool             PutOnCondition(const string name, const double value, const double check_value) const
       {
        return GlobalVariableSetOnCondition(name, value, check_value);
       };

    //--- :
    bool             Delete(void) const
       {
        return GlobalVariableDel(m_name);
       };

    //--- :
    bool             Delete(const string name) const
       {
        return GlobalVariableDel(name);
       };

    //--- :
    int              DeleteAll(const string prefix_name = NULL, datetime limit_data = 0) const
       {
        return GlobalVariablesDeleteAll(prefix_name, limit_data);
       };

    //--- :
    void             Save()
       {
        GlobalVariablesFlush();
       }
   };


//+------------------------------------------------------------------+
