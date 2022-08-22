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


//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010

//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import

//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| PROPRIEDADES GRÁFICO: Obtem a largura do grafico em pixels.      |
//+------------------------------------------------------------------+
long LarguraDoGrafico() {
    return ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
}

//+------------------------------------------------------------------+
//| TEMPO GRÁFICO: Converter valores ENUM para string.               |
//+------------------------------------------------------------------+
string PeriodToString(ENUM_TIMEFRAMES periodo) {
    switch (periodo) {
      case PERIOD_M1 : return  "1 minuto";   // M1
      case PERIOD_M2 : return  "2 minutos";  // M2
      case PERIOD_M3 : return  "3 minutos";  // M3
      case PERIOD_M4 : return  "4 minutos";  // M4
      case PERIOD_M5 : return  "5 minutos";  // M5
      case PERIOD_M6 : return  "6 minutos";  // M6
      case PERIOD_M10: return "10 minutos";  // M10
      case PERIOD_M12: return "12 minutos";  // M12
      case PERIOD_M15: return "15 minutos";  // M15
      case PERIOD_M20: return "20 minutos";  // M20
      case PERIOD_M30: return "30 minutos";  // M30
      case PERIOD_H1 : return  "1 hora";     // H1
      case PERIOD_H2 : return  "2 horas";    // H2
      case PERIOD_H3 : return  "3 horas";    // H3
      case PERIOD_H4 : return  "4 horas";    // H4
      case PERIOD_H6 : return  "6 horas";    // H6
      case PERIOD_H8 : return  "8 horas";    // H8
      case PERIOD_H12: return "12 horas";    // H12
      case PERIOD_D1 : return  "1 dia";      // D1
      case PERIOD_W1 : return  "1 semana";   // W1
      case PERIOD_MN1: return  "1 mês";      // MN
       
      default: return "Tempo corrente";
    }
}

//+------------------------------------------------------------------+
//| ESCREVER TEXTO: Funcao para criacao de objetos.                  |
//+------------------------------------------------------------------+
void CriarTexto(int idChart, string objNome, int x, int y, string texto, int tamanho,
                color cor, string fonte, ENUM_ANCHOR_POINT ancora, ENUM_BASE_CORNER canto,
                bool select, bool fundo, bool oculto) {
    // Cria o objeto
    ObjectCreate(idChart, objNome, OBJ_LABEL, 0, 0, 0);
   
    // Definir posicionamento X e Y (são sempre inteiros):
    ObjectSetInteger(idChart, objNome, OBJPROP_CORNER, canto);
    ObjectSetInteger(idChart, objNome, OBJPROP_ANCHOR, ancora);
    ObjectSetInteger(idChart, objNome, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(idChart, objNome, OBJPROP_YDISTANCE, y);
    
    // Definir o texto e estilo
    ObjectSetString(idChart, objNome, OBJPROP_TEXT, texto);
    ObjectSetInteger(idChart, objNome, OBJPROP_COLOR, cor);
    ObjectSetString(idChart, objNome, OBJPROP_FONT, fonte);
    ObjectSetInteger(idChart, objNome, OBJPROP_FONTSIZE, tamanho);
    
    // Outras / diversas
    ObjectSetInteger(idChart, objNome, OBJPROP_SELECTABLE, select);
    ObjectSetInteger(idChart, objNome, OBJPROP_BACK, fundo);
    ObjectSetInteger(idChart, objNome, OBJPROP_HIDDEN, oculto);
}

//+------------------------------------------------------------------+
//| CRIAR BOTÃO: Funcao para criacao de botões com eventos.          |
//+------------------------------------------------------------------+
void CriarBotao(int idChart, string objNome, int xx, int yy, int largura, int altura, ENUM_BASE_CORNER canto,
                int tamanho, string fonte, string texto, color corTexto, color corFundo, 
                color corBorda, bool fundo, bool oculto, bool selecionavel, string dica=NULL) {
    // Cria o objeto
    ObjectCreate(idChart, objNome, OBJ_BUTTON, 0, 0, 0);

    // Definir posicionamento X e Y e dimensionamento:
    ObjectSetInteger(idChart, objNome, OBJPROP_XDISTANCE, xx);
    ObjectSetInteger(idChart, objNome, OBJPROP_YDISTANCE, yy);
    ObjectSetInteger(idChart, objNome, OBJPROP_XSIZE, largura);
    ObjectSetInteger(idChart, objNome, OBJPROP_YSIZE, altura);
    ObjectSetInteger(idChart, objNome, OBJPROP_CORNER, canto);

    // Definir o texto e estilo
    ObjectSetString(idChart, objNome, OBJPROP_TEXT, texto);
    ObjectSetString(idChart, objNome, OBJPROP_FONT, fonte);
    ObjectSetInteger(idChart, objNome, OBJPROP_FONTSIZE, tamanho);

    ObjectSetInteger(idChart, objNome, OBJPROP_COLOR, corTexto);
    ObjectSetInteger(idChart, objNome, OBJPROP_BGCOLOR, corFundo);
    ObjectSetInteger(idChart, objNome, OBJPROP_BORDER_COLOR, corBorda);
    
    // Outras / diversas
    ObjectSetInteger(idChart, objNome, OBJPROP_BACK, fundo);
    ObjectSetInteger(idChart, objNome, OBJPROP_HIDDEN, oculto);
    ObjectSetInteger(idChart, objNome, OBJPROP_SELECTABLE, selecionavel);

    ObjectSetString(idChart, objNome, OBJPROP_TOOLTIP, dica);
}

//+------------------------------------------------------------------+

bool ChecarSeMaiorQueDez(int valor) {
    bool resultado = (valor > 10);
    
    return resultado;
}

//+------------------------------------------------------------------+
