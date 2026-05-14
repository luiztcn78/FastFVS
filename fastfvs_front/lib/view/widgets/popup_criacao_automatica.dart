import 'package:fastfvs_front/view/widgets/contador_numero.dart';
import 'package:flutter/material.dart';

class PopupCriacaoAutomatica extends StatefulWidget {
  final VoidCallback onFechar;

  const PopupCriacaoAutomatica({super.key, required this.onFechar});

  @override
  State<PopupCriacaoAutomatica> createState() => _PopupCriacaoAutomaticaState();
}

class _PopupCriacaoAutomaticaState extends State<PopupCriacaoAutomatica> {
  int _numBlocos = 1;
  int _numPavimentos = 1;
  int _numApts = 1;
  int _numeracaoInicio = 1;
  int _numeracaoFim = 1;

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
          top: 100,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Definir padrão de:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cor.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _linhaContador(
                    cor,
                    "N° de Blocos:",
                    _numBlocos,
                    () => setState(() => _numBlocos++),
                    () => setState(() {
                      if (_numBlocos > 1) _numBlocos--;
                    }),
                  ),
                  const SizedBox(height: 12),

                  _linhaContador(
                    cor,
                    "Pavimentos por Bloco:",
                    _numPavimentos,
                    () => setState(() => _numPavimentos++),
                    () => setState(() {
                      if (_numPavimentos > 1) _numPavimentos--;
                    }),
                  ),
                  const SizedBox(height: 12),

                  _linhaContador(
                    cor,
                    "Apts por Pavimento:",
                    _numApts,
                    () => setState(() => _numApts++),
                    () => setState(() {
                      if (_numApts > 1) _numApts--;
                    }),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "Padrão de Numeração:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cor.primary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ContadorNumero(
                        valor: _numeracaoInicio,
                        onAumentar: () => setState(() => _numeracaoInicio++),
                        onDiminuir: () => setState(() {
                          if (_numeracaoInicio > 1) _numeracaoInicio--;
                        }),
                      ),
                      Text(
                        "a",
                        style: TextStyle(color: cor.primary, fontSize: 16),
                      ),
                      ContadorNumero(
                        valor: _numeracaoFim,
                        onAumentar: () => setState(() => _numeracaoFim++),
                        onDiminuir: () => setState(() {
                          if (_numeracaoFim > 1) _numeracaoFim--;
                        }),
                      ),
                      GestureDetector(
                        onTap: widget.onFechar,
                        child: Icon(Icons.check, color: cor.primary, size: 28),
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

  Widget _linhaContador(
    ColorScheme cor,
    String label,
    int valor,
    VoidCallback onAumentar,
    VoidCallback onDiminuir,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: cor.primary)),
        ContadorNumero(
          valor: valor,
          onAumentar: onAumentar,
          onDiminuir: onDiminuir,
        ),
      ],
    );
  }
}
