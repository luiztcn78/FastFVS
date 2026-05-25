import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/pages/pagina_particao.dart';
import 'package:fastfvs_front/view/widgets/botao_criar_fvs.dart';
import 'package:fastfvs_front/view/widgets/informacao_obra.dart';
import 'package:fastfvs_front/view/widgets/lista_containers_parti%C3%A7%C3%B5es.dart';
import 'package:fastfvs_front/view/widgets/opcoes_menu_suspenso.dart';
import 'package:flutter/material.dart';

class PaginaObra extends StatefulWidget{
  const PaginaObra({super.key});

@override
  State<PaginaObra> createState() => PaginaObraState();
}

class PaginaObraState extends State<PaginaObra> {
final controladorNavegacao = GlobalKey<NavigatorState>();

final List<String> particoes = ['Container A', 'Container B', 'Container C',];

final ValueNotifier<List<OpcoesMenuSuspenso>> opcoes = ValueNotifier([]);

@override
void initState() {
  super.initState();
  _definirOpcoesInicio();
}

void _definirOpcoesInicio() {
    opcoes.value = [
      OpcoesMenuSuspenso(nome: 'Criar Partição', onTap: () {}),
    ];
  }

  void _definirOpcoesParticao() {
    opcoes.value = [
      OpcoesMenuSuspenso(nome: 'criar fvs', onTap: () {}),
      OpcoesMenuSuspenso(nome: 'teste', onTap: () {}),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    //pop scope configura o botao voltar e desfarça o navegador local
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (controladorNavegacao.currentState?.canPop() == true) {
          controladorNavegacao.currentState?.pop();
          _definirOpcoesInicio();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: PaginaBase(
        paginaAberta: 0,
        botaoFlutuante: ValueListenableBuilder(
          valueListenable: opcoes,
          builder: (context, value, _) => BotaoCriarFvs(opcoes: value),
        ),
        body: Column(
            children: [
              InformacaoObra(),
              Expanded(
                child: Navigator(
                  key: controladorNavegacao,
                  onGenerateRoute: (settings) {
                    switch (settings.name) {
                    case '/particao':
                      _definirOpcoesParticao();
                      return MaterialPageRoute(
                        builder: (context) => PaginaParticao(),
                      );
                    default:
                    _definirOpcoesInicio();
                      return MaterialPageRoute(
                        builder: (context) => ListaContainersParticao(particoes: particoes)
                      );
                    }
                  },
                )
              )
            ],
          ),
      ),
    );
  }
}