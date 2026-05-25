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
        decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
        ),
        width: MediaQuery.of(context).size.width*0.4,
        height: 45,
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(nome, 
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onPrimary
            ),
          ),
        ),
      ),
    );
  }
}