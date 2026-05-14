import 'package:flutter/material.dart';

class PopupFvsPadroes extends StatefulWidget {
  final VoidCallback onFechar;

  const PopupFvsPadroes({super.key, required this.onFechar});

  @override
  State<PopupFvsPadroes> createState() => _PopupFvsPadroesState();
}

class _PopupFvsPadroesState extends State<PopupFvsPadroes> {
  bool _fvsHidraulica = false;
  bool _fvsAzulejo = false;
  bool _fvsConcretagem = false;
  bool _fvsAviamento = false;
  bool _fvsPintura = false;
  bool _fvsEletrica = false;
  bool _fvsPiso = false;

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final cor = Theme.of(context).colorScheme;

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
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
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
                      color: cor.primary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _linhaFvs(
                    cor,
                    "FVS - Hidráulica",
                    _fvsHidraulica,
                    (v) => setState(() => _fvsHidraulica = v!),
                  ),
                  _linhaFvs(
                    cor,
                    "FVS - Azulejo",
                    _fvsAzulejo,
                    (v) => setState(() => _fvsAzulejo = v!),
                  ),
                  _linhaFvs(
                    cor,
                    "FVS - Concretagem",
                    _fvsConcretagem,
                    (v) => setState(() => _fvsConcretagem = v!),
                  ),
                  _linhaFvs(
                    cor,
                    "FVS - Aviamento",
                    _fvsAviamento,
                    (v) => setState(() => _fvsAviamento = v!),
                  ),
                  _linhaFvs(
                    cor,
                    "FVS - Pintura",
                    _fvsPintura,
                    (v) => setState(() => _fvsPintura = v!),
                  ),
                  _linhaFvs(
                    cor,
                    "FVS - Instalação Elétrica",
                    _fvsEletrica,
                    (v) => setState(() => _fvsEletrica = v!),
                  ),
                  _linhaFvs(
                    cor,
                    "FVS - Piso",
                    _fvsPiso,
                    (v) => setState(() => _fvsPiso = v!),
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

  Widget _linhaFvs(
    ColorScheme cor,
    String texto,
    bool valor,
    Function(bool?) onChange,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(texto, style: TextStyle(color: cor.primary)),
        Checkbox(value: valor, onChanged: onChange, activeColor: cor.primary),
      ],
    );
  }
}
