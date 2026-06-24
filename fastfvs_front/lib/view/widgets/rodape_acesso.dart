import 'package:flutter/material.dart';

class RodapeAcesso extends StatelessWidget {
  const RodapeAcesso({super.key});

  @override
  Widget build(BuildContext context){
    
    return Container(
      height: 70, padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          Expanded(child: Text(
            'Aplicativo Desenvolvido pela Turma de 2026.1', textAlign: TextAlign.right,
            style: TextStyle(color:Theme.of(context).colorScheme.onSecondary
            ,shadows: [
              Shadow(
                offset: const Offset(1.0, 1.0),
                blurRadius: 3.0,           
                color: Colors.black.withOpacity(0.3),
              ),
            ]
            ,fontSize: 8.0),
          ),
          ),

          Container(
            height: 30,
            width: 2, color: Theme.of(context).colorScheme.onSecondary, margin: const EdgeInsets.symmetric(horizontal: 15.0),

          ),

          Expanded(child: 
          Text(
            'Universidade de Pernambuco Campus Garanhuns', textAlign: TextAlign.left,
            style: TextStyle(color:Theme.of(context).colorScheme.onSecondary, 
            shadows: [
              Shadow(
                offset: const Offset(1.0, 1.0),
                blurRadius: 3.0,           
                color: Colors.black.withOpacity(0.3),
              ),
              ]
            ,fontSize: 8.0),
          ),
          
          ),
          
        ],
      )
    );


  }
}