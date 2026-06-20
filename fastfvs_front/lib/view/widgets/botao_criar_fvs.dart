import 'package:fastfvs_front/view/widgets/menu_suspenso.dart';
import 'package:fastfvs_front/view/widgets/opcoes_menu_suspenso.dart';
import 'package:flutter/material.dart';

class BotaoCriarFvs extends StatefulWidget {
  final List<OpcoesMenuSuspenso> opcoes;
  const BotaoCriarFvs({super.key, required this.opcoes});

  @override
  State<BotaoCriarFvs> createState() => _BotaoCriarFvsState();
}

class _BotaoCriarFvsState extends State<BotaoCriarFvs> {
  bool aberto = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (aberto) MenuSuspenso(opcoes: widget.opcoes,),
        FloatingActionButton(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          onPressed: () {setState(() => aberto = !aberto);},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onSecondary
                ),
              ),
              SizedBox(height: 5,),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onSecondary
                ),
              ),
              SizedBox(height: 5,),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onSecondary
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}