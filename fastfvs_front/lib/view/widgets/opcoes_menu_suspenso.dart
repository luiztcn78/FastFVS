import 'package:flutter/material.dart';

class OpcoesMenuSuspenso extends StatelessWidget {
  final String nome;
  final VoidCallback onTap;

  OpcoesMenuSuspenso({required this.nome, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(nome, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary
            ),
          ),
        ),
    );
  }
}