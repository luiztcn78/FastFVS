import 'package:fastfvs_front/view/widgets/botao_particao_baixo.dart';
import 'package:fastfvs_front/view/widgets/container_particao.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PaginaParticao extends StatelessWidget {
  const PaginaParticao({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       ContainerParticao(largura: MediaQuery.of(context).size.width*0.9, serBotao: false,),
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        BotaoParticao(caminho: "teste", nome: "FVS"),
        BotaoParticao(caminho: "teste", nome: "Sub-Sessões")
        ],
       )
      ],
    );
  }
}