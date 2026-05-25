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
      children: opcoes.map((opcao) => GestureDetector(
        onTap: opcao.onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(opcao.nome),
        ),
      )).toList(),
    )
    );
  }
}