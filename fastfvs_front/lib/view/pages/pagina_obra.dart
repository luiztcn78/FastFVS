import 'package:fastfvs_front/models/dados_particao.dart';
import 'package:fastfvs_front/models/obra.dart';
import 'package:fastfvs_front/models/subsecao.dart';
import 'package:fastfvs_front/services/obra_service.dart';
import 'package:fastfvs_front/services/subsecao_service.dart';
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
import 'package:shimmer/shimmer.dart';

class PaginaObra extends StatefulWidget {
  final Obra obra;


  const PaginaObra({required this.obra, super.key});

  @override
  State<PaginaObra> createState() => PaginaObraState();
}

class PaginaObraState extends State<PaginaObra> {
  final controladorNavegacao = GlobalKey<NavigatorState>();
  final controladorNome = TextEditingController();

  final ObraService obraService = ObraService();
  double percentualObra = 0.0;
  int fvsConforme = 0;
  int fvsNaoConforme = 0;
  bool carregando = true;

  final SubsecaoService subsecaoService = SubsecaoService();
  List<DadosParticao> dadosSubsecoesRaizes = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _definirOpcoesInicio();
    });
  }

  Future<void> _carregarDados() async {
    final percentual = await obraService.getConformidadeObra(widget.obra.id);
    final resumo = await obraService.contarStatusObra(widget.obra.id);
    final subsecoes = await subsecaoService.listarRaizesPorObra(widget.obra.id);
    final dadosSubsecoes = await Future.wait(
      subsecoes.map((subsecao) async {
        final conformidade = await subsecaoService.getConformidade(subsecao.id);
        return subsecaoService.statusPresentesNasubsecao(subsecao.id, subsecao.nome, conformidade);
      })
    );
    setState(() {
      percentualObra = percentual;
      fvsConforme = resumo['CONFORME'] ?? 0;
      fvsNaoConforme = resumo['NAO_CONFORME'] ?? 0;
      carregando = false;
      dadosSubsecoesRaizes = dadosSubsecoes;
    });
  }

  final ValueNotifier<List<OpcoesMenuSuspenso>> opcoes = ValueNotifier([]);

  String fvsCriada = '';

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
          builder: (context) {
            // Variável de estado local do dialog
            bool adicionarEmTodasSubsecoes = false; 

            return StatefulBuilder(
              builder: (context, setStateDialog) {
                return AlertDialog(
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
                      const SizedBox(height: 16),
                      // Novo Checkbox
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: adicionarEmTodasSubsecoes,
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: (v) {
                              setStateDialog(() {
                                adicionarEmTodasSubsecoes = v ?? false;
                              });
                            },
                          ),
                          Text(
                            "Adicionar em todas\nas Subseções",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        // Você pode acessar a variável adicionarEmTodasSubsecoes aqui,, integração
                        fvsCriada = controladorNome.text;
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff84E08F),
                        foregroundColor: Theme.of(context).colorScheme.onSecondary,
                        fixedSize: const Size(120, 40),
                        side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                      ),
                      child: const Text('Confirmar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(110, 40),
                        backgroundColor: const Color(0xffFF6D6D),
                        foregroundColor: Theme.of(context).colorScheme.onSecondary,
                        side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ],
                );
              }
            );
          }
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
            carregando
              ? Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 2, color: Theme.of(context).colorScheme.primary)
                    ),
                  ),
                child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity, 
                  height: 120, 
                  color: Colors.white
                ),
                )
              )
              : InformacaoObra(nomeObra: widget.obra.nome, percetualObra: percentualObra, fvsConforme: fvsConforme, fvsNaoConforme: fvsNaoConforme,),
            Expanded(
              child: Navigator(
                key: controladorNavegacao,
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case '/particao':
                    final dadosParticao = settings.arguments as DadosParticao;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _definirOpcoesParticao();
                      });
                      return MaterialPageRoute(
                        builder: (context) => PaginaParticao(dadosParticao: dadosParticao,
                        onTapParticao: (dadosFilha) {
                          controladorNavegacao.currentState?.pushNamed(
                            '/particao',
                            arguments: dadosFilha,
                          );
                        },),
                      );
                    default:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _definirOpcoesInicio();
                      });
                      return MaterialPageRoute(
                        builder: (context) => carregando
                          ? SingleChildScrollView(
                              child: Wrap(
                                children: List.generate(8, (_) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15, left: 10, bottom: 15, right: 10),
                                    child: Container(
                                      width: 160,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                )),
                              ),
                            )
                          : ListaContainersParticao(particoes: dadosSubsecoesRaizes),
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