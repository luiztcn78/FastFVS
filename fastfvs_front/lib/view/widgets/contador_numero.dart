import 'package:flutter/material.dart';

class ContadorNumero extends StatelessWidget {
  final int valor;
  final VoidCallback onAumentar;
  final VoidCallback onDiminuir;

  const ContadorNumero({
    super.key,
    required this.valor,
    required this.onAumentar,
    required this.onDiminuir,
  });

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme;

    return Row(
      children: [
        _botao("-", onDiminuir, cor),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "$valor",
            style: TextStyle(color: cor.primary, fontSize: 16),
          ),
        ),
        _botao("+", onAumentar, cor),
      ],
    );
  }

  Widget _botao(String label, VoidCallback onTap, ColorScheme cor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: cor.primary),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label, style: TextStyle(color: cor.primary, fontSize: 18)),
      ),
    );
  }
}
