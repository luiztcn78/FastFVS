import 'package:fastfvs_front/view/widgets/opcoes_menu_suspenso.dart';
import 'package:flutter/material.dart';

class MenuSuspenso extends StatelessWidget {
  final List<OpcoesMenuSuspenso> opcoes;

  const MenuSuspenso({super.key, required this.opcoes});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: opcoes.map((opcao) => GestureDetector(
        onTap: opcao.onTap,
        child: opcao,
      )).toList(),
    )
    );
  }
}