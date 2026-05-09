import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/pages/pagina_info_obra.dart';
import 'package:flutter/material.dart';

class botao_obra extends StatelessWidget{
  final String nome;

  const botao_obra({required this.nome, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.6,
      height: MediaQuery.of(context).size.height*0.1,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))
          )
        ),
        onPressed:() => PaginaInfoObra(), 
        child: Text(
                nome, 
                textAlign: TextAlign.center, 
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20, 
                fontWeight: FontWeight.bold),
                ),
        ),
    );
  }
}



  