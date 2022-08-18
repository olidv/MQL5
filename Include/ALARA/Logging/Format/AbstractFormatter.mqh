/*
 * MIT License
 *
 * Log4Mql5  .:.  https://github.com/olidv/Log4Mql5
 * Copyright (c) 2021 by Oliveira Developer at Brazil
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
*/
#property library

//--- Injecao das dependencias.
#include "Formatter.mqh"


//+------------------------------------------------------------------+
//| Class CAbstractFormatter.                                        |
//|                                                                  |
//| Usage: Definicao de metodos para as classes concretas que        |
//|        efetuam a formatacao das mensagens de logging.            |
//+------------------------------------------------------------------+
class CAbstractFormatter: public IFormatter
   {
private:
    //--- Declaracao das variaveis de instancia (propriedades):
    string              m_layout;

protected:
    //--- Obtem o layout para formatacao de registros de logging.
    string              getLayout();

    //--- Processamento da formatacao utilizando layout e registro log.
    string              compilePattern(const SLogRecord &record);  //
    string              compilePattern(const string layout, const SLogRecord &record);  //

public:
    //--- Construtor: Inicializa parametros internos e configura o formatter.
    void                CAbstractFormatter(const string layout);

    //--- Destrutores: Encerra e libera quaisquer recursos em uso pelo formatter.
    void               ~CAbstractFormatter(void);

    //--- Informa o tipo de formato do layout utilizado:
    virtual EFormatType getFormatType() = NULL;

    //--- Executa procedimentos de inicializacao para o formatter.
    virtual bool        start();

    //--- Formata um registro de logging de acordo com o layout interno.
    virtual string      formatMessage(const SLogRecord &record) = NULL;

    //--- Encerra os recursos alocados e fecha arquivos, se necessario.
    virtual bool        close();
   };


//+------------------------------------------------------------------+
//| Construtor: Inicializa parametros internos e configura o         |
//|             formatter.                                           |
//+------------------------------------------------------------------+
void CAbstractFormatter::CAbstractFormatter(const string layout)
   {
// inicializa os parametros internos:
    this.m_layout = layout;
   }


//+------------------------------------------------------------------+
//| Destrutor: Encerra e libera quaisquer recursos em uso pelo       |
//|            formatter.                                            |
//+------------------------------------------------------------------+
void CAbstractFormatter::~CAbstractFormatter()
   {
// apenas limpa as variaveis internas:
    this.m_layout = NULL;
   }


//+------------------------------------------------------------------+
//| Obtem o layout para formatacao de registros de logging.          |
//+------------------------------------------------------------------+
string CAbstractFormatter::getLayout()
   {
    return this.m_layout;
   }


//+------------------------------------------------------------------+
//| Processamento da formatacao utilizando o layout interno/membro.  |
//+------------------------------------------------------------------+
string CAbstractFormatter::compilePattern(const SLogRecord &record)
   {
    return this.compilePattern(this.m_layout, record);
   }


//+------------------------------------------------------------------+
//| Processamento da formatacao utilizando outro layout fornecido.   |
//+------------------------------------------------------------------+
string CAbstractFormatter::compilePattern(const string layout, const SLogRecord &record)
   {
// Verifica se o registro de logging eh valido:
    if(record.name == NULL || record.name == "" ||
       record.level == NULL || record.level == 0 ||
       record.message == NULL || record.message == "")
       {
        // se nao tem registro de logging valido, a mensagem sera vazia:
        return "";
       }

// Verifica se o layout inicializado na classe eh valido:
    if(layout == NULL || layout == "" || StringFind(layout, "%") == -1)
       {
        // se nao tem layout de formatacao valido, a mensagem eh vazia:
        return record.message;
       }

// Efetua cada substituicao dos campos do registro de logging:
    string msg = layout;
    StringReplace(msg, "%time", TimeToString(record.timestamp,TIME_DATE|TIME_SECONDS));
    StringReplace(msg, "%level", LevelToString(record.level));
    StringReplace(msg, "%logger", record.name);
    StringReplace(msg, "%pack", record.package);
    StringReplace(msg, "%file", record.program);
    StringReplace(msg, "%func", record.function);
    StringReplace(msg, "%line", IntegerToString(record.line));
    StringReplace(msg, "%msg", record.message);

    return msg;
   }


//+------------------------------------------------------------------+
//| Executa procedimentos de inicializacao para o formatter.         |
//+------------------------------------------------------------------+
bool CAbstractFormatter::start()
   {
// nao ha o que processar aqui...
    return true;
   }


//+------------------------------------------------------------------+
//| Encerra os recursos alocados e fecha arquivos, se necessario.    |
//+------------------------------------------------------------------+
bool CAbstractFormatter::close()
   {
// nao ha o que processar aqui...
    return true;
   }


//+------------------------------------------------------------------+
