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

//program file         TechIndicator.mqh
//program package      MQL5/Include/ALARA/
#property version      "1.000"
#property description  "..."

//**********************************************************************************************

#property library


//+------------------------------------------------------------------+
//| Injecao das dependencias.                                        |
//+------------------------------------------------------------------+
#include <Object.mqh>


//+------------------------------------------------------------------+
//| Class CTechIndicator.                                            |
//|                                                                  |
//| Usage: Classe helper para manutencao de indicadores tecnicos.    |
//+------------------------------------------------------------------+
class CTechIndicator : public CObject
   {
private:
    //--- Declaracao das variaveis de instancia (propriedades):
    int              m_handle;
    int              m_index;

public:
    //--- Variaveis publicas para acesso direto aos buffers do indicador:
    double           Buffer1[];
    double           Buffer2[];
    double           Buffer3[];
    double           Buffer4[];
    double           Buffer5[];
    //--- Variaveis publicas para acesso direto aos dados historicos do ativo:
    MqlRates         Rates[];

    //--- Construtor parametrico:
    void             CTechIndicator(const int handle, const int index = 0) : m_handle(handle), m_index(index)
       {
        //--- ja prepara os arrays internos para serem indexados como timeseries:
        ArraySetAsSeries(Buffer1, true);
        ArraySetAsSeries(Buffer2, true);
        ArraySetAsSeries(Buffer3, true);
        ArraySetAsSeries(Buffer4, true);
        ArraySetAsSeries(Buffer5, true);
        ArraySetAsSeries(Rates, true);
       };

    //--- Destrutor default:
    void            ~CTechIndicator(void)
       {
        //--- elimina os recursos utilizados:
        ArrayFree(Buffer1);
        ArrayFree(Buffer2);
        ArrayFree(Buffer3);
        ArrayFree(Buffer4);
        ArrayFree(Buffer5);
        ArrayFree(Rates);

        if(m_handle != INVALID_HANDLE)
           {
            IndicatorRelease(m_handle);
            m_handle = INVALID_HANDLE;
           }
       };

    //--- Informa se o indicador eh valido e foi criado com sucesso:
    bool             IsValid(void) const
       {
        return (m_handle != INVALID_HANDLE);
       };

    //--- Adiciona o indicador corrente ao grafico e subjanela especificados:
    bool             ChartAdd(const long chart_id = 0, const int sub_window = 0) const
       {
        // adiciona o indicador no grafico especificado usando o handle interno:
        ResetLastError();
        return ChartIndicatorAdd(chart_id, sub_window, m_handle);
       };

    //--- Remove o indicador corrente do grafico e subjanela especificados:
    bool             ChartDel(const long chart_id = 0, const int sub_window = 0) const
       {
        // precisa pegar o nome do indicador antes:
        const string name = ChartIndicatorName(chart_id, sub_window, m_index);

        ResetLastError();
        return ChartIndicatorDelete(chart_id, sub_window, name);
       };

    //--- BUFFER #1, SEQUENCIAL 0

    //--- Copia os dados do indicador para o buffer #1, conforme parametros especificados:
    int              getBuffer1(const int start_pos, const int count)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer1);

        ResetLastError();
        return CopyBuffer(m_handle, 0, start_pos, count, Buffer1);
       }

    //--- Copia os dados do indicador para o buffer #1, conforme parametros especificados:
    int              getBuffer1(const datetime start_time, const int count)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer1);

        ResetLastError();
        return CopyBuffer(m_handle, 0, start_time, count, Buffer1);
       }

    //--- Copia os dados do indicador para o buffer #1, conforme parametros especificados:
    int              getBuffer1(const datetime start_time, const datetime stop_time)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer1);

        ResetLastError();
        return CopyBuffer(m_handle, 0, start_time, stop_time, Buffer1);
       }

    //--- BUFFER #2, SEQUENCIAL 1

    //--- Copia os dados do indicador para o buffer #2, conforme parametros especificados:
    int              getBuffer2(const int start_pos, const int count)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer2);

        ResetLastError();
        return CopyBuffer(m_handle, 1, start_pos, count, Buffer2);
       }

    //--- Copia os dados do indicador para o buffer #2, conforme parametros especificados:
    int              getBuffer2(const datetime start_time, const int count)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer2);

        ResetLastError();
        return CopyBuffer(m_handle, 1, start_time, count, Buffer2);
       }

    //--- Copia os dados do indicador para o buffer #2, conforme parametros especificados:
    int              getBuffer2(const datetime start_time, const datetime stop_time)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer2);

        ResetLastError();
        return CopyBuffer(m_handle, 1, start_time, stop_time, Buffer2);
       }

    //--- BUFFER #3, SEQUENCIAL 2

    //--- Copia os dados do indicador para o buffer #3, conforme parametros especificados:
    int              getBuffer3(const int start_pos, const int count)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer3);

        ResetLastError();
        return CopyBuffer(m_handle, 2, start_pos, count, Buffer3);
       }

    //--- Copia os dados do indicador para o buffer #3, conforme parametros especificados:
    int              getBuffer3(const datetime start_time, const int count)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer3);

        ResetLastError();
        return CopyBuffer(m_handle, 2, start_time, count, Buffer3);
       }

    //--- Copia os dados do indicador para o buffer #3, conforme parametros especificados:
    int              getBuffer3(const datetime start_time, const datetime stop_time)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer3);

        ResetLastError();
        return CopyBuffer(m_handle, 2, start_time, stop_time, Buffer3);
       }

    //--- BUFFER #4, SEQUENCIAL 3

    //--- Copia os dados do indicador para o buffer #4, conforme parametros especificados:
    int              getBuffer4(const int start_pos, const int count)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer4);

        ResetLastError();
        return CopyBuffer(m_handle, 3, start_pos, count, Buffer4);
       }

    //--- Copia os dados do indicador para o buffer #4, conforme parametros especificados:
    int              getBuffer4(const datetime start_time, const int count)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer4);

        ResetLastError();
        return CopyBuffer(m_handle, 3, start_time, count, Buffer4);
       }

    //--- Copia os dados do indicador para o buffer #4, conforme parametros especificados:
    int              getBuffer4(const datetime start_time, const datetime stop_time)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer4);

        ResetLastError();
        return CopyBuffer(m_handle, 3, start_time, stop_time, Buffer4);
       }

    //--- BUFFER #5, SEQUENCIAL 4

    //--- Copia os dados do indicador para o buffer #5, conforme parametros especificados:
    int              getBuffer5(const int start_pos, const int count)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer5);

        ResetLastError();
        return CopyBuffer(m_handle, 4, start_pos, count, Buffer5);
       }

    //--- Copia os dados do indicador para o buffer #5, conforme parametros especificados:
    int              getBuffer5(const datetime start_time, const int count)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer5);

        ResetLastError();
        return CopyBuffer(m_handle, 4, start_time, count, Buffer5);
       }

    //--- Copia os dados do indicador para o buffer #5, conforme parametros especificados:
    int              getBuffer5(const datetime start_time, const datetime stop_time)
       {
        // limpa o buffer antes de preenche-lo novamente:
        ArrayFree(Buffer5);

        ResetLastError();
        return CopyBuffer(m_handle, 4, start_time, stop_time, Buffer5);
       }

    //--- CANDLE-RATES

    //--- Copia os dados historicos do ativo para o array Rates, conforme parametros especificados:
    int              getRates(const int start_pos, const int count)
       {
        // limpa o array antes de preenche-lo novamente:
        ArrayFree(Rates);

        ResetLastError();
        return CopyRates(_Symbol, _Period, start_pos, count, Rates);
       }

    //--- Copia os dados historicos do ativo para o array Rates, conforme parametros especificados:
    int              getRates(const datetime start_time, const int count)
       {
        // limpa o array antes de preenche-lo novamente:
        ArrayFree(Rates);

        ResetLastError();
        return CopyRates(_Symbol, _Period, start_time, count, Rates);
       }

    //--- Copia os dados historicos do ativo para o array Rates, conforme parametros especificados:
    int              getRates(const datetime start_time, const datetime stop_time)
       {
        // limpa o array antes de preenche-lo novamente:
        ArrayFree(Rates);

        ResetLastError();
        return CopyRates(_Symbol, _Period, start_time, stop_time, Rates);
       }
   };


//+------------------------------------------------------------------+
