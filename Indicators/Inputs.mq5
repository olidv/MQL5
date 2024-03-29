#property indicator_chart_window

enum Idioma {
    idioma_pt = 3, // Português
    idioma_en = 2, // Inglês
    idioma_es = 1, // Espanhol
    idioma_fr = 0  // Francês
};

enum Tamanho {
    tamanho_g = 3, // Grande
    tamanho_m = 2, // Médio
    tamanho_p = 1  // Pequeno
};

input group   "Parâmetros Input"  // Título
input bool    InputQuestao = true;     // Questão
input double  InputValor = 0;          // Valor  
input string  InputNome = "";          // Nome
input color   InputCorFundo = clrRed;  // Cor de Fundo
input Idioma  InputIdioma = idioma_pt; // Idioma
input Tamanho InputTamanho = tamanho_m; // Tamanho

string MeuNome = InputNome + "Developer";
string TamanhoSelecionado;

int OnInit() {
    ChartSetInteger(0, CHART_COLOR_BACKGROUND, InputCorFundo);

    if (InputQuestao) {
        Comment("Você selecionou verdadeiro e o valor é " + DoubleToString(InputValor, 2) + " e o nome é " + MeuNome);
    } else {
        Comment("Você selecionou falso e o valor é " + (string) InputValor + " e o nome é " + MeuNome);
    }
    
    if (InputTamanho == tamanho_g) {
        TamanhoSelecionado = "Grande";
    }
    
    switch (InputIdioma) {
      case idioma_pt:
        Alert("O idioma escolhido foi o Português." + TamanhoSelecionado);
        break;
      case idioma_en:
        Alert("O idioma escolhido foi o Inglês.");
        break;
      case idioma_es:
        Alert("O idioma escolhido foi o Espanhol.");
        break;
      case idioma_fr:
        Alert("O idioma escolhido foi o Francês.");
        break;
    }
    
    return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[]) {
    return(rates_total);
}
