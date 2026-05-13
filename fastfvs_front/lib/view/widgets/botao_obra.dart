import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/pages/pagina_obra.dart';
import 'package:flutter/material.dart';

class botao_obra extends StatelessWidget{
  final String nome;

  const botao_obra({required this.nome, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.0, top: 7.0, left: MediaQuery.of(context).size.width*0.09, right: MediaQuery.of(context).size.width*0.09),
      child: SizedBox(
        width: MediaQuery.of(context).size.width*0.6,
        height: MediaQuery.of(context).size.height*0.1,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
            )
          ),

          onPressed:() => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaginaObra()),
            ), 

          child: Text(
                  nome, 
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 20, 
                  fontWeight: FontWeight.bold),
                  ),
          ),
      ),
    );
  }
}



  