import 'package:flutter/material.dart';

class BotaoParticao extends StatelessWidget {
  final String nome;
  final String caminho;

  const BotaoParticao({required this.caminho, required this.nome, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7, left: 7),
      child: SizedBox(
        width: 115,
        height: 32,
        
        child: TextButton(
          onPressed: (){}, 
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
            )
          ),
          child: Text(
            nome, 
            textAlign: TextAlign.center, 
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 14,
            )
          )
        )
      ),
    );
  }
}