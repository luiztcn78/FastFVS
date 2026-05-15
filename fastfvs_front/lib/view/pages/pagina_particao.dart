import 'package:fastfvs_front/view/pages/sessao_fvs.dart';
import 'package:fastfvs_front/view/widgets/botao_particao_baixo.dart';
import 'package:fastfvs_front/view/widgets/container_particao.dart';
import 'package:fastfvs_front/view/widgets/lista_containers_parti%C3%A7%C3%B5es.dart';
import 'package:flutter/material.dart';

class PaginaParticao extends StatefulWidget {
  const PaginaParticao({super.key});

  @override
  State<PaginaParticao> createState() => PaginaParticaoState();
}

class PaginaParticaoState extends State<PaginaParticao> {
  final controladorNavegacao = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {

    final List<String> particoes = ['Pavimento A', 'Pavimento B', 'Pavimento C',];

    return Column(
      children: [
       ContainerParticao(nome:'Bloco A', largura: MediaQuery.of(context).size.width*0.9, serBotao: false,),
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        BotaoParticao(caminho: "/Fvs", nome: "FVS", navegador: controladorNavegacao),
        BotaoParticao(caminho: "/Subsessao", nome: "Sub-Sessões", navegador: controladorNavegacao),
        ],
       ),
       Expanded(
        child: Navigator(
          key: controladorNavegacao,
          onGenerateRoute: (settings) {
            switch (settings.name) {
            case '/Subsessao':
              return PageRouteBuilder(
                pageBuilder: (context, _, __) => ListaContainersParticao(particoes: particoes),
                transitionDuration: Duration.zero, // sem animação
              );
            default:
              return PageRouteBuilder(
                pageBuilder: (context, _, __) => SessaoFvs(),
                transitionDuration: Duration.zero,
              );
            }
          },
        )
       )
      ],
    );
  }
}
