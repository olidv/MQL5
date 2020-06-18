//+------------------------------------------------------------------+
//| Panel_Buttons.mq5 |
//| Copyright 2017, MetaQuotes Software Corp. |
//| https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
#property description "Painel com vários botões CButton"
#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
//+------------------------------------------------------------------+
//| defines |
//+------------------------------------------------------------------+
//--- indents and gaps
#define INDENT_LEFT (11) // indent from left (with allowance for borde
#define INDENT_TOP (11) // indent from top (with allowance for border
#define CONTROLS_GAP_X (5) // gap by X coordinate
#define CONTROLS_GAP_Y (5) // gap by Y coordinate

//--- for buttons
#define BUTTON_WIDTH (100) // size by X coordinate
#define BUTTON_HEIGHT (20) // size by Y coordinate
//--- for the indication area
#define EDIT_HEIGHT (20) // size by Y coordinate
//--- criamos o tipo personalizado de função
typedef int(*TAction)(string,int);
//+------------------------------------------------------------------+
//| Abre o arquivo |
//+------------------------------------------------------------------+
int Open(string name,int id)
{
PrintFormat("Função chamada %s (name=%s id=%d)",__FUNCTION__,name,id);
return(1);
}
//+------------------------------------------------------------------+
//| Salva o arquivo |
//+------------------------------------------------------------------+
int Save(string name,int id)
{
PrintFormat("Função chamada %s (name=%s id=%d)",__FUNCTION__,name,id);
return(2);
}
//+------------------------------------------------------------------+
//| Fecha o arquivo |
//+------------------------------------------------------------------+
int Close(string name,int id)
{
PrintFormat("Função chamada %s (name=%s id=%d)",__FUNCTION__,name,id);
return(3);
}
//+------------------------------------------------------------------+
//| Criamos nossa classe de botão com a função de manipulador de eventos |
//+------------------------------------------------------------------+
class MyButton: public CButton
{
private:
TAction m_action; // manipulador de eventos para o gráfico
public:
MyButton(void){}
~MyButton(void){}
//--- construtor com indicação do texto do botão e ponteiro para a função a fim de manipular eve
MyButton(string text,TAction act)
{
Text(text);
m_action=act;
}
//--- definição de função que será chamada a partir do manipulador de eventos OnEvent()

void SetAction(TAction act){m_action=act;}
//--- manipulador padrão de eventos de gráfico
virtual bool OnEvent(const int id,const long &lparam,const double &dparam,const string &spa
{
if(m_action!=NULL & lparam==Id())
{
//--- chamamos o manipulador próprio
m_action(sparam,(int)lparam);
return(true);
}
else
//--- retornamos o resultado da chamada do manipulador a partir da classe mão CButton
return(CButton::OnEvent(id,lparam,dparam,sparam));
}
};
//+------------------------------------------------------------------+
//| Classe CControlsDialog |
//| Designação: painel gráfico para controle do aplicativo |
//+------------------------------------------------------------------+
class CControlsDialog : public CAppDialog
{
private:
CArrayObj m_buttons; // matriz de botões
public:
CControlsDialog(void){};
~CControlsDialog(void){};
//--- create
virtual bool Create(const long chart,const string name,const int subwin,const int x1,const
//--- adição de botão
bool AddButton(MyButton &button){return(m_buttons.Add(GetPointer(button)));m_button
protected:
//--- criação de botões
bool CreateButtons(void);
};
//+------------------------------------------------------------------+
//| Criação do objeto CControlsDialog no gráfico |
//+------------------------------------------------------------------+
bool CControlsDialog::Create(const long chart,const string name,const int subwin,const int x1,const
{
if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
return(false);
return(CreateButtons());
//---
}
//+------------------------------------------------------------------+
//| Criação e adição de botões para o painel CControlsDialog |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateButtons(void)
{
//--- cálculo de coordenadas de botões
int x1=INDENT_LEFT;
int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y);
int x2;
int y2=y1+BUTTON_HEIGHT;
//--- adicionamos os objetos dos botões juntamente com os ponteiros para as funções
AddButton(new MyButton("Open",Open));
AddButton(new MyButton("Save",Save));
AddButton(new MyButton("Close",Close));
//--- criamos os botões graficamente
for(int i=0;i<m_buttons.Total();i++)
{
MyButton *b=(MyButton*)m_buttons.At(i);
x1=INDENT_LEFT+i*(BUTTON_WIDTH+CONTROLS_GAP_X);
x2=x1+BUTTON_WIDTH;
if(!b.Create(m_chart_id,m_name+"bt"+b.Text(),m_subwin,x1,y1,x2,y2))
{
PrintFormat("Failed to create button %s %d",b.Text(),i);
return(false);
}
//--- adicionamos cada botão no recipiente CControlsDialog
if(!Add(b))
return(false);
}
//--- succeed
return(true);
}
//--- declaramos o objeto no nível global para criá-lo automaticamente ao inciar o programa
CControlsDialog MyDialog;
//+------------------------------------------------------------------+
//| Expert initialization function |
//+------------------------------------------------------------------+
int OnInit()
{
//--- agora criamos o objeto no gráfico
if(!MyDialog.Create(0,"Controls",0,40,40,380,344))
return(INIT_FAILED);
//--- executamos o aplicativo
MyDialog.Run();
//--- inicialização bem-sucedida do aplicativo
return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//--- destroy dialog
MyDialog.Destroy(reason);
}
//+------------------------------------------------------------------+
//| Expert chart event function |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, // event ID
const long& lparam, // event parameter of the long type
const double& dparam, // event parameter of the double type
const string& sparam) // event parameter of the string type
{
//--- para os eventos do gráfico, chamamos o manipulador a partir da classe mãe (neste caso, CAppDi
MyDialog.ChartEvent(id,lparam,dparam,sparam);
}
