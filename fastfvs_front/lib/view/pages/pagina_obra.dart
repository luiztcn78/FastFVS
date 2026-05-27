import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/pages/pagina_particao.dart';
import 'package:fastfvs_front/view/widgets/botao_criar_fvs.dart';
import 'package:fastfvs_front/view/widgets/informacao_obra.dart';
import 'package:fastfvs_front/view/widgets/lista_containers_parti%C3%A7%C3%B5es.dart';
import 'package:fastfvs_front/view/widgets/opcoes_menu_suspenso.dart';
import 'package:fastfvs_front/view/widgets/popup_fvs_padroes.dart';
import 'package:flutter/material.dart';

class PaginaObra extends StatefulWidget{
  const PaginaObra({super.key});

@override
  State<PaginaObra> createState() => PaginaObraState();
}

class PaginaObraState extends State<PaginaObra> {
final controladorNavegacao = GlobalKey<NavigatorState>();
final controladorNome = TextEditingController();

final List<String> particoes = ['Container A', 'Container B', 'Container C',];

final ValueNotifier<List<OpcoesMenuSuspenso>> opcoes = ValueNotifier([]);

String fvsCriada = '';

@override
void initState() {
  super.initState();
  _definirOpcoesInicio();
}

void _definirOpcoesInicio() {
    opcoes.value = [
      OpcoesMenuSuspenso(nome: 'Qr Code', onTap: () {}),
    ];
  }

  void _definirOpcoesParticao() {
    opcoes.value = [
      OpcoesMenuSuspenso(nome: 'criar fvs', onTap: () {showDialog(
          context: context,
          builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 16),
            title: Text('Criar FVS', style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.onSecondary
                    ),),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
              ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10,),
                TextField(
                  controller: controladorNome,
                  decoration: InputDecoration(
                    labelText: 'Nome da FVS',
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                    ),
                    ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Confirmar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff84E08F),
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  fixedSize: Size(120, 40),
                  side: BorderSide( 
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                ),
              ),
              ElevatedButton(
                onPressed: () {
                fvsCriada = controladorNome.text;
                Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(110, 40),
                  backgroundColor: Color(0xffFF6D6D),
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  side: BorderSide( 
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                ),
                child: Text('Cancelar'),
              ),
            ],
          ),
        );
      },
    ),
      OpcoesMenuSuspenso(nome: 'Adicionar fvs', onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: '',
          barrierColor: Colors.transparent, // ✅ o popup já tem Colors.black26
          pageBuilder: (_, __, ___) => PopupFvsPadroes(
            onFechar: () => Navigator.pop(context),
          ),
        );
      },),
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