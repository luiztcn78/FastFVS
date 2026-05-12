import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/widgets/informacao_obra.dart';
import 'package:flutter/material.dart';

class PaginaObra extends StatelessWidget{
  const PaginaObra({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      paginaAberta: 0,
      body: Column(
        children: [
          Container(
            child: InformacaoObra(),
          ),
        ],
      ),
    );
  }
}