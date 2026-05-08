import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/widgets/barra_pesquisar.dart';
import 'package:fastfvs_front/view/widgets/botao_obra.dart';
import 'package:flutter/material.dart';

class PaginaMinhasObras extends StatelessWidget{
  final Function(Widget) abrirPagina;
  const PaginaMinhasObras({required this.abrirPagina, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          BarraPesquisar(abrirPagina: abrirPagina,),
        ],
      ),
    );
  }
}