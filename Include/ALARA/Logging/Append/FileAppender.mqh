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
#include "AbstractAppender.mqh"


//--- Mantem 100 linhas no buffer, antes de executar o flush,
//--- para nao sobrecarregar a execucao do programa principal.
#define LINES_BUFFER_SIZE 100


//+------------------------------------------------------------------+
//| Class CFileAppender.                                             |
//|                                                                  |
//| Usage: Registro das mensagens de logging em arquivo.             |
//+------------------------------------------------------------------+
class CFileAppender: public CAbstractAppender
   {
private:
    //--- Declaracao das variaveis de instancia (propriedades):
    string              m_nameFile;
    int                 m_hndLogFile;   // handle para arquivo de logging gerado.

protected:
    //--- Grava o registro de logging.
    virtual bool        doAppend(const SLogRecord &record);

    //--- Salva os registros de logging ainda em cache.
    virtual bool        flush(const bool closing) override;

public:
    //--- Construtores: Inicializa o layout utilizado internamente na formatacao.
    void                CFileAppender(const string name,
                                      const ELogLevel level,
                                      IFormatter *formatter) : CAbstractAppender(name, level, formatter) {};

    //--- Informa o tipo de processamento e destinatario do appender:
    virtual EAppendType getAppendType();

    //--- Executa procedimentos de inicializacao para o appender.
    virtual bool        start() override;

    //--- Encerra os recursos alocados e fecha arquivos, se necessario.
    virtual bool        close() override;
   };


//+------------------------------------------------------------------+
//| Informa o tipo deste appender.                                   |
//+------------------------------------------------------------------+
EAppendType CFileAppender::getAppendType()
   {
    return APPEND_FILE;
   }


//+------------------------------------------------------------------+
//| Executa procedimentos de inicializacao para o appender.          |
//+------------------------------------------------------------------+
bool CFileAppender::start() override
   {
//--- ao inicializar o appender, tambem inicializa o formatter incluso.
    this.getFormatter().start();

//--- inicializa o arquivo de logging para escrita:
    string dtLogFile = TimeToString(TimeLocal(), TIME_DATE);
    this.m_hndLogFile = INVALID_HANDLE;
    this.m_nameFile = this.getName() + "_" + dtLogFile + ".log";
    bool fileExist = FileIsExist(this.m_nameFile);

    ResetLastError();
    this.m_hndLogFile = fileExist ? FileOpen(this.m_nameFile, FILE_TXT|FILE_ANSI|FILE_WRITE|FILE_READ)
                        : FileOpen(this.m_nameFile, FILE_TXT|FILE_ANSI|FILE_WRITE);
    if(this.m_hndLogFile == INVALID_HANDLE)
       {
        Print("ERRO [", this.getName(), "] EM ", dtLogFile, " : Operação 'FileOpen(", this.m_nameFile, ")' falhou! Erro = ", GetLastError());
       }
    else
        if(fileExist)
           {
            FileSeek(this.m_hndLogFile, 0, SEEK_END);
           }

    return true;
   }


//+------------------------------------------------------------------+
//| Grava o registro de logging em arquivo.                          |
//+------------------------------------------------------------------+
bool CFileAppender::doAppend(const SLogRecord &record)
   {
// formata a mensagem utilizando o formatter interno:
    string msg = getFormatter().formatMessage(record);

// eh preciso adicionar a quebra de linha ao final da mensagem:
    msg += "\n";  // se ja tiver quebra (\n) na mensagem, vai ficar com 2 quebras...

// este appender apenas salva a mensagem formatada na arquivo de logging:
    FileWriteString(this.m_hndLogFile, msg);

    return true;
   }


//+------------------------------------------------------------------+
//| Salva os registros de logging ainda em cache.                    |
//+------------------------------------------------------------------+
bool CFileAppender::flush(const bool closing) override
   {
//--- Se nem criou o arquivo de logging ainda, nada a fazer aqui...
    if(this.m_hndLogFile == INVALID_HANDLE)
        return false;

//--- mantem buffer de linhas para nao sobrecarregar o EA com operacoes de escrita no logging:
    static int linesBuffer = 0;

//--- se estiver encerrando o appender, o flush eh obrigatorio
    if(closing || (++linesBuffer % LINES_BUFFER_SIZE == 0))  // mantem 100 linhas no buffer
       {
        //--- grava os dados restantes do arquivo.
        FileFlush(this.m_hndLogFile);
        return true;
       }

//--- informa que o flush nao foi executado...
    return false;
   }


//+------------------------------------------------------------------+
//| Encerra os recursos alocados e fecha arquivos, se necessario.    |
//+------------------------------------------------------------------+
bool CFileAppender::close() override
   {
// Se ainda houver registros de logging no cache, grava uma ultima vez:
    this.flush(true);  // agora sim, esta encerrando o appender.

//--- ao encerrar o appender, tambem notifica o formatter incluso para encerrar.
    this.getFormatter().close();

//--- Se nem criou o arquivo de logging ainda, nada a fazer aqui...
    if(this.m_hndLogFile != INVALID_HANDLE)
       {
        //--- fecha o arquivo e inutiliza handle:
        FileClose(this.m_hndLogFile);
        this.m_hndLogFile = INVALID_HANDLE;  // invalida o handle do arquivo;
       }

    return true;
   }


//+------------------------------------------------------------------+
