import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/widgets/barra_pesquisar.dart';
import 'package:fastfvs_front/view/widgets/botao_obra.dart';
import 'package:flutter/material.dart';

class PaginaMinhasObras extends StatelessWidget{
  const PaginaMinhasObras({ super.key});

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      paginaAberta: 0,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Minhas Obras", 
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: MediaQuery.of(context).size.width*0.06,
                ),
              )
            ),
            ),
            Expanded(child: BarraPesquisar()),
          ],
        ),
      ),
    );
  }
}