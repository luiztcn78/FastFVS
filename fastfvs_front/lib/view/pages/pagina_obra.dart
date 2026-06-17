import 'package:fastfvs_front/models/dados_particao.dart';
import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/pages/pagina_particao.dart';
import 'package:fastfvs_front/view/pages/pagina_qr_code_obra.dart';
import 'package:fastfvs_front/view/widgets/botao_criar_fvs.dart';
import 'package:fastfvs_front/view/widgets/informacao_obra.dart';
import 'package:fastfvs_front/view/widgets/lista_containers_parti%C3%A7%C3%B5es.dart';
import 'package:fastfvs_front/view/widgets/opcoes_menu_suspenso.dart';
import 'package:fastfvs_front/view/widgets/popup_compartilhar.dart';
import 'package:fastfvs_front/view/widgets/popup_fvs_padroes.dart';
import 'package:flutter/material.dart';

class PaginaObra extends StatefulWidget {
  const PaginaObra({super.key});

  @override
  State<PaginaObra> createState() => PaginaObraState();
}

class PaginaObraState extends State<PaginaObra> {
  final controladorNavegacao = GlobalKey<NavigatorState>();
  final controladorNome = TextEditingController();

  // substituir pelos dados do back
  final List<DadosParticao> particoes = [
    DadosParticao(nome: 'Bloco A'),
    DadosParticao(nome: 'Bloco B', mostrarVermelho: false),
    DadosParticao(nome: 'Bloco C', mostrarCinza: false, mostrarAmarelo: false),
  ];

  final ValueNotifier<List<OpcoesMenuSuspenso>> opcoes = ValueNotifier([]);

  String fvsCriada = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _definirOpcoesInicio();
    });
  }

  void _definirOpcoesInicio() {
    opcoes.value = [
      OpcoesMenuSuspenso(nome: 'Qr Code', onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PaginaQrCode()));
      }),
      OpcoesMenuSuspenso(nome: "Compatilhar acesso", onTap: () => {
        showDialog(
          context: context,
          builder: (_) => PopupCompartilhar(onFechar: () => Navigator.pop(context)),
        )
      }),
    ];
  }

  void _definirOpcoesParticao() {
    opcoes.value = [
      OpcoesMenuSuspenso(nome: 'Criar fvs', onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text('Criar FVS', style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onSecondary,
            )),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                TextField(
                  controller: controladorNome,
                  decoration: InputDecoration(
                    labelText: 'Nome da FVS',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff84E08F),
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  fixedSize: const Size(120, 40),
                  side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                child: const Text('Confirmar'),
              ),
              ElevatedButton(
                onPressed: () {
                  fvsCriada = controladorNome.text;
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(110, 40),
                  backgroundColor: const Color(0xffFF6D6D),
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        );
      }),
      OpcoesMenuSuspenso(nome: 'Adicionar fvs', onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          builder: (_) => PopupFvsPadroes(onFechar: () => Navigator.pop(context)),
        );
      }),
      OpcoesMenuSuspenso(nome: 'Qr Code', onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PaginaQrCode()));
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _definirOpcoesParticao();
                      });
                      return MaterialPageRoute(
                        builder: (context) => PaginaParticao(),
                      );
                    default:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _definirOpcoesInicio();
                      });
                      return MaterialPageRoute(
                        builder: (context) => ListaContainersParticao(particoes: particoes),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}