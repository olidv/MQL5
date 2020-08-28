//+------------------------------------------------------------------+
//|                                               Coaching_EA_66.mq5 |
//|                              Copyright 2020, ALARA Investimentos |
//|                                          http://www.alara.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ALARA Investimentos"
#property link      "http://www.alara.com.br"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Includes: Bibliotecas Padrão do MQL5                             |
//+------------------------------------------------------------------+
#include <Controls\Dialog.mqh>
#include <Controls\Label.mqh>
#include <Controls\Panel.mqh>
#include <ChartObjects\ChartObjectsLines.mqh>
#include <ChartObjects\ChartObjectsFibo.mqh>
#include <ChartObjects\ChartObjectSubChart.mqh>

//--- Variaveis Globais
CEdit                 edit;
CDialog               dialog;
CLabel                label;
CLabel                label2;
CPanel                panel;
CAppDialog            appDialog;
CChartObjectTrend     trendline;
CChartObjectFibo      fibo;
CChartObjectSubChart  subchart;

//+------------------------------------------------------------------+
//| STRUCTS MQL                                                      |
//+------------------------------------------------------------------+
MqlTick tick;
MqlRates candle[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
    ArraySetAsSeries(candle, true);
    SymbolInfoTick(_Symbol, tick);
    CopyRates(_Symbol, _Period, 0, 100, candle);

//--- utilizando a funcao SetPanel()
//SetPanel("Painel", 0, 40, 40, 100, 100, clrRed, clrBlue, 4);
//panel.Create(0, "Painel_B", 0, 20, 20, 250, 250);
//panel.ColorBackground(clrRed);
//panel.Activate();

//--- utilizando a biblioteca padrao GUI do MQL5
//    appDialog.Create(0, "painel", 0, 100, 30, 300, 300);
//    appDialog.Run();
//
//    label.Create(0, "Preço", 0, 10,10,40,40);
//    label.Text("Preço");
//    label.Color(clrRed);
//    appDialog.Add(label);
//
//    label2.Create(0, "Valor", 0, 10,25,40,40);
//    label2.Text(DoubleToString(tick.last, _Digits));
//    label2.Color(clrBlue);
//    appDialog.Add(label2);

//--- funcoes utilitarias
    //ButtonCreate(0, "Button_1",0, 40, 40, 100, 48, CORNER_LEFT_UPPER, "Confirmar?", "Georgia", 12, clrBlue);
    //SetText("Label", "Meu Texto", 0, 0, 200, clrRed, 14, "Tahoma");

//--- Trend Lines
    //trendline.Create(0, "Line_1", 0, candle[49].time, candle[49].close, candle[5].time, candle[5].close);
    //trendline.Color(clrOlive);
    //trendline.Width(4);
    //trendline.Style(STYLE_DASH);
    
//--- Linhas de Fibonacci
    //fibo.Create(0, "Fibonacci", 0, candle[91].time, candle[91].close, candle[6].time, candle[6].close);    
    //fibo.Color(clrBlue);
    //fibo.LevelColor(0, clrOlive);
    //fibo.LevelColor(1, clrOlive);
    //fibo.LevelColor(2, clrOlive);
    //fibo.LevelColor(3, clrOlive);
    //fibo.LevelColor(4, clrOlive);
    //fibo.LevelColor(5, clrBlue);
    //fibo.LevelColor(6, clrRed);
    //fibo.LevelColor(7, clrGreen);
    //fibo.LevelDescription(7, "Nivel 7");

//---
    //subchart.Create(0, "SubChart", 0, 10, 10, 400, 300);    
    //subchart.Symbol("USDJPY");

//--- caixa de input (editor)
    edit.Create(0, "Edit", 0, 40, 40, 200, 80);
    edit.ColorBackground(clrLightGray);
    edit.ColorBorder(clrRed);
    edit.Text("Meu Edit");
    edit.TextAlign(ALIGN_RIGHT);
    edit.Color(clrBlue);
    edit.Font("Gorgia");
    edit.FontSize(14);
    edit.ReadOnly(false);



    return(INIT_SUCCEEDED);
   }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
//---
    //appDialog.Destroy(reason);
   }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
   {
//---
//    SymbolInfoTick(_Symbol, tick);
//    Print("Tick = ", tick.ask);
//
//    label2.Text(DoubleToString(tick.last, _Digits));
//    appDialog.Run();

    //--- a cada tick, exibe o conteudo da caixa de texto
    string texto = ObjectGetString(0, "Edit", OBJPROP_TEXT);
    if (StringToInteger(texto) > 5) {
        Alert("Parametro Errado!");
        ObjectSetString(0, "Edit", OBJPROP_TEXT, "5");
    }
    
    Print("Texto atual = ", texto);
   }

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
   {
    //appDialog.ChartEvent(id, lparam, dparam, sparam);

//---
//Print("OnChartEvent Id = ", EnumToString((ENUM_CHART_EVENT) id));
//Print("Estamos dentro de OnChartEvent");

//--- mapeamento de eventos para botao
    OnButtonClick(id, sparam);
   }

//+------------------------------------------------------------------+

void OnButtonClick(int _id, string _sparam) {
    //---
    if (_id == CHARTEVENT_OBJECT_CLICK) {
        //--- obtem o estado do objeto
        bool pressed = ObjectGetInteger(0, "Button_1", OBJPROP_STATE);
        string objClicked = _sparam;

        //Print("Pressed = ", pressed, " / objClicked = ", objClicked);

        if (objClicked == "Button_1") {
            if (pressed) {
                Print("O objeto Button_1 foi clicado");
            } else {  // ! pressed
                Print("O objeto Button_1 foi (des)clicado");
            }
        }
    }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetPanel(string name, int sub_window, int x, int y, int width, int height,
              color bg_color, color border_clr, int border_width)
   {
//---
    if(ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
       {
        ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
        ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
        ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
        ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
        ObjectSetInteger(0,name,OBJPROP_COLOR,border_clr);
        ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bg_color);
        ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
        ObjectSetInteger(0,name,OBJPROP_WIDTH,border_width);
        ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
        ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);
        ObjectSetInteger(0,name,OBJPROP_BACK,false);
        ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
        ObjectSetInteger(0,name,OBJPROP_SELECTED,0);
        ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
        ObjectSetInteger(0,name,OBJPROP_ZORDER,0);
       }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetText(string name, string text, int sub_window, int x, int y, color colour, int fontsize=12, string font="Arial")
   {
//---
    if(ObjectCreate(0,name,OBJ_LABEL,sub_window,0,0))
       {
        ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
        ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
        ObjectSetString(0,name,OBJPROP_TEXT,text);
        ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
        ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontsize);
        ObjectSetString(0,name,OBJPROP_FONT,font);
        ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
        ObjectSetInteger(0,name,OBJPROP_ZORDER,1);  // Para o caso de objetos sobrepostos
       }
   }

//+------------------------------------------------------------------+
//| Criar o botão                                                    |
//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID=0,               // ID do gráfico
                  const string            name="Button",            // nome do botão
                  const int               sub_window=0,             // índice da sub-janela
                  const int               x=0,                      // coordenada X
                  const int               y=0,                      // coordenada Y
                  const int               width=50,                 // largura do botão 
                  const int               height=18,                // altura do botão
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // canto do gráfico para ancoragem
                  const string            text="Button",            // texto
                  const string            font="Arial",             // fonte
                  const int               font_size=10,             // tamanho da fonte
                  const color             clr=clrBlack,             // cor do texto
                  const color             back_clr=C'236,233,216',  // cor do fundo
                  const color             border_clr=clrNONE,       // cor da borda
                  const bool              state=false,              // pressionada/liberada
                  const bool              back=false,               // no fundo
                  const bool              selection=false,          // destaque para mover
                  const bool              hidden=true,              // ocultar na lista de objeto
                  const long              z_order=0)                // prioridade para clicar no mouse
  {
//--- redefine o valor de erro
   ResetLastError();
//--- criar o botão
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": falha ao criar o botão! Código de erro = ",GetLastError());
      return(false);
     }
//--- definir coordenadas do botão
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- definir tamanho do botão
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- determinar o canto do gráfico onde as coordenadas do ponto são definidas
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- definir o texto
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- definir o texto fonte
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- definir tamanho da fonte
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- definir a cor do texto
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- definir a cor de fundo
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- definir a cor da borda
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- exibir em primeiro plano (false) ou fundo (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- set button state
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
//--- habilitar (true) ou desabilitar (false) o modo do movimento do botão com o mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- ocultar (true) ou exibir (false) o nome do objeto gráfico na lista de objeto 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- definir a prioridade para receber o evento com um clique do mouse no gráfico
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- sucesso na execução
   return(true);
  }

//+------------------------------------------------------------------+
