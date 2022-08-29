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


//--- Rotulo para maior legibilidade na criacao de variaveis globais temporarias...
#define GLOBAL_VAR_TEMP    true


//+------------------------------------------------------------------+
//| Class CGlobalVar.                                                |
//|                                                                  |
//| Usage: Classe helper para manutencao de variaveis globais.       |
//+------------------------------------------------------------------+
class CGlobalVar : public CObject
   {
private:
    //--- Declaracao das variaveis de instancia (propriedades):
    string           m_varName;
    bool             m_isTemp;

public:
    //--- Construtor default:
    void             CGlobalVar(void) : m_varName(NULL), m_isTemp(false) {};

    //--- Construtor parametrico:
    void             CGlobalVar(const string var_name, const bool is_temp = false):
                     m_varName(var_name),
                     m_isTemp(is_temp)
       {
        //--- para o caso da variavel ja existir, exclui para evitar conflitos se for temporaria:
        if(Exists(var_name))
           {
            if(is_temp)    // se for temporaria, melhor excluir e criar novamente...
               {
                // apenas para ter certeza de que sera temporaria de agora em diante.
                GlobalVariableDel(var_name);
                GlobalVariableTemp(var_name);
               }
           }
        else    // se ainda nao existe, cria a variavel global, ainda que com valor NULL:
            if(is_temp)
                GlobalVariableTemp(var_name);
            else
                GlobalVariableSet(var_name, NULL);
       };

    //--- Destrutor default:
    void                ~CGlobalVar(void)
       {
        //--- elimina a variavel global do terminal se for temporaria:
        if(m_isTemp && isNotEmpty(m_varName))
            GlobalVariableDel(m_varName);
       };

    //--- Retorna o total de variaveis globais no terminal:
    int              Total() const
       {
        return GlobalVariablesTotal();
       };

    //--- Retorna o nome corrente da variavel global:
    string           Name(void) const
       {
        return m_varName;
       };

    //--- Retorna o nome da variavel global indexada:
    string           Name(const int index) const
       {
        return GlobalVariableName(index);
       };

    //--- Retorna array com os nomes de todas as variaveis globais no terminal:
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


    //--- Retorna array com os nomes de todas as variaveis globais
    //--- no terminal que iniciam com o prefixo fornecido:
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
            string vName = GlobalVariableName(i);
            if(_LastError != 0)
                return false;

            if(StringLen(vName) >= lenPrefix && StringSubstr(vName, 0, lenPrefix) == prefix_name)
               {
                ArrayResize(array, size + 1);
                array[size++] = vName;
               }
           }

        return true;
       };

    //--- Informa se a variavel global corrente ja existe no terminal:
    bool             Exists(void) const
       {
        return GlobalVariableCheck(m_varName);
       };

    //--- Informa se a variavel global indicada existe no terminal:
    bool             Exists(const string var_name) const
       {
        return GlobalVariableCheck(var_name);
       };

    //--- Informa se a variavel global corrente eh temporaria ou nao:
    bool             IsTemp(void) const
       {
        return m_isTemp;
       };

    //--- Informa a data/hora da ultima atualizacao da variavel global corrente:
    datetime         LastTime(void) const
       {
        return GlobalVariableTime(m_varName);
       };

    //--- Informa a data/hora da ultima atualizacao da variavel global indicada:
    datetime         LastTime(const string var_name) const
       {
        return GlobalVariableTime(var_name);
       };

    //--- Obtem o valor corrente no terminal da variavel global corrente:
    double           Get(void) const
       {
        return GlobalVariableGet(m_varName);
       };

    //--- Obtem o valor corrente no terminal da variavel global indicada:
    double           Get(const string var_name, const double defValue = NULL) const
       {
        if(Exists(var_name))
            return GlobalVariableGet(var_name);
        else
            return defValue;
       };

    //--- Insere ou altera o valor no terminal da variavel global corrente:
    void             Put(const double value) const
       {
        GlobalVariableSet(m_varName, value);
       };

    //--- Insere ou altera o valor no terminal da variavel global indicada:
    void             Put(const string var_name, const double value) const
       {
        GlobalVariableSet(var_name, value);
       };

    //--- Insere ou altera o valor no terminal da variavel global corrente
    //--- dependendo da condicao do valor a ser verificado:
    bool             PutOnCondition(const double value, const double check_value) const
       {
        return GlobalVariableSetOnCondition(m_varName, value, check_value);
       };

    //--- Insere ou altera o valor no terminal da variavel global indicada
    //--- dependendo da condicao do valor a ser verificado:
    bool             PutOnCondition(const string var_name, const double value, const double check_value) const
       {
        return GlobalVariableSetOnCondition(var_name, value, check_value);
       };

    //--- Remove a variavel global corrente do terminal:
    bool             Delete(void) const
       {
        return GlobalVariableDel(m_varName);
       };

    //--- Remove a variavel global indicada do terminal:
    bool             Delete(const string var_name) const
       {
        return GlobalVariableDel(var_name);
       };

    //--- Remove todas as variaveis globais do terminal:
    int              DeleteAll(const string prefix_name = NULL, datetime limit_data = 0) const
       {
        return GlobalVariablesDeleteAll(prefix_name, limit_data);
       };

    //--- Efetua o flush em disco das variaveis globais e seus valores no terminal:
    void             Save()
       {
        GlobalVariablesFlush();
       }
   };


//+------------------------------------------------------------------+
