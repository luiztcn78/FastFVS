import 'package:flutter/material.dart';

class PopupFvsPadroes extends StatefulWidget {
  final VoidCallback onFechar;

  const PopupFvsPadroes({super.key, required this.onFechar});

  @override
  State<PopupFvsPadroes> createState() => _PopupFvsPadroesState();
}

class _PopupFvsPadroesState extends State<PopupFvsPadroes> {
  // Lista de FVS tirando as variáveis isoladas
  final Map<String, bool> _fvsLista = {
    "FVS - Hidráulica": false,
    "FVS - Azulejo": false,
    "FVS - Concretagem": false,
    "FVS - Aviamento": false,
    "FVS - Pintura": false,
    "FVS - Instalação Elétrica": false,
    "FVS - Piso": false,
    "FVS - Fiação Elétrica": false,
    "FVS - Encanamento": false,
    "FVS - Cerâmica": false,
    "FVS - Móveis": false,
  };

  bool _adicionarEmTodasSubsecoes = false;

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    
    // Capturando o ColorScheme e verificando se está no Dark Mode
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    // LÓGICA DAS CORES:
    // Fundo: Branco no Light / Marrom (primary) no Dark
    final corFundo = isDark ? colorScheme.primary : Colors.white;
    
    // Textos/Bordas: Marrom no Light / Branco no Dark (Essa é exatamente a onSecondary)
    final corElementos = colorScheme.onSecondary;
    
    // O "V" de dentro do checkbox para não sumir
    // (Branco no Light / Marrom no Dark)
    final corCheck = isDark ? colorScheme.primary : Colors.white;

    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onFechar,
          child: Container(color: Colors.black26),
        ),
        Positioned(
          top: 60,
          left: largura * 0.05,
          right: largura * 0.05,
          // Limitando a altura para que o Scroll funcione em telas menores
          bottom: MediaQuery.of(context).size.height * 0.1, 
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: corFundo, // <--- Aplicando cor correta ao fundo
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Definir FVS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: corElementos, // <--- Aplicando cor ao título
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Lista com Scroll
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _fvsLista.keys.map((String chave) {
                          return _linhaFvs(
                            corElementos, 
                            corCheck, 
                            chave,
                            _fvsLista[chave]!,
                            (v) => setState(() => _fvsLista[chave] = v!),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  
                  // Checkbox "Adicionar em todas as Subseções"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _adicionarEmTodasSubsecoes,
                        onChanged: (v) => setState(() => _adicionarEmTodasSubsecoes = v!),
                        activeColor: corElementos,
                        checkColor: corCheck, // <--- Mantendo o V visível
                      ),
                      Text(
                        "Adicionar em todas\nas Subseções",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: corElementos,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: widget.onFechar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Confirmar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: widget.onFechar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Ajustado para receber a cor do "V" (corCheck) também
  Widget _linhaFvs(
    Color corAtiva, 
    Color corCheck,
    String texto,
    bool valor,
    Function(bool?) onChange,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(texto, style: TextStyle(color: corAtiva)),
        Checkbox(
          value: valor, 
          onChanged: onChange, 
          activeColor: corAtiva,
          checkColor: corCheck,
        ),
      ],
    );
  }
}