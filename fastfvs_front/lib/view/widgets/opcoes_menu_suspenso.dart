import 'package:flutter/material.dart';

class OpcoesMenuSuspenso extends StatefulWidget {
  final String nome;
  final VoidCallback onTap;
  final int indice; // para o delay cascata

  const OpcoesMenuSuspenso({
    required this.nome,
    required this.onTap,
    this.indice = 0,
  });

  @override
  State<OpcoesMenuSuspenso> createState() => _OpcoesMenuSuspensoState();
}

class _OpcoesMenuSuspensoState extends State<OpcoesMenuSuspenso>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacidade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacidade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // delay cascata por índice
    Future.delayed(Duration(milliseconds: widget.indice * 60), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacidade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 160,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.nome,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}