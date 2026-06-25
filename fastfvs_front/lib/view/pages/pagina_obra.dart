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
import 'package:fastfvs_front/services/fvs_service.dart';
import 'package:fastfvs_front/services/sessao_usuario.dart';
import 'package:fastfvs_front/view/pages/sessao_fvs.dart';
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
  final FvsService fvsService = FvsService();
  GlobalKey<SessaoFvsState> chaveSessaoFvs = GlobalKey<SessaoFvsState>();
  DadosParticao? subsecaoAtual;
  final List<(DadosParticao, GlobalKey<SessaoFvsState>, GlobalKey<PaginaParticaoState>)> _pilhaParticoesControlerPop = [];

  final ObraService obraService = ObraService();
  double percentualObra = 0.0;
  int fvsConforme = 0;
  int fvsNaoConforme = 0;
  bool carregando = true;
  bool carregandoInfoObra = false;

  final SubsecaoService subsecaoService = SubsecaoService();
  List<DadosParticao> dadosSubsecoesRaizes = [];

  late String nomeObra;

  @override
  void initState() {
    super.initState();
    nomeObra = widget.obra.nome;
    _carregarDados();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _definirOpcoesInicio();
    });
  }

  Future<void> _carregarDados() async {
    setState(() {
      carregando = true;
      carregandoInfoObra = true;
    });
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
      carregandoInfoObra = false;
      dadosSubsecoesRaizes = dadosSubsecoes;
    });
  }

  Future<void> _carregarDadosBackStage() async {
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
      dadosSubsecoesRaizes = dadosSubsecoes;
    });
  }

  final ValueNotifier<List<OpcoesMenuSuspenso>> opcoes = ValueNotifier([]);

  String fvsCriada = '';

  void _definirOpcoesInicio() {
    opcoes.value = [
      OpcoesMenuSuspenso(nome: 'Qr Code', onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaQrCode(
          titulo: nomeObra,
          carregarQrCode: () => obraService.obterQrCodeObra(widget.obra.id),
        )));
      }, indice: 2,),
      OpcoesMenuSuspenso(nome: "Compatilhar acesso", onTap: () => {
        showDialog(
          context: context,
          builder: (_) => PopupCompartilhar(onFechar: () => Navigator.pop(context)),
        )
      }, indice: 1,),
      OpcoesMenuSuspenso(nome: "Adicionar Subseção", onTap: _mostrarDialogAdicionarSubsecao, indice: 0,)
    ];
  }

  void _definirOpcoesParticao(DadosParticao dadosParticao) {
  subsecaoAtual = dadosParticao;

  opcoes.value = [
    OpcoesMenuSuspenso(nome: 'Criar fvs', onTap: () {
      showDialog(
        context: context,
        builder: (context) {
          bool adicionarEmTodasSubsecoes = false;
          bool salvando = false;

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: adicionarEmTodasSubsecoes,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (v) {
                            setStateDialog(() => adicionarEmTodasSubsecoes = v ?? false);
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
                    onPressed: salvando ? null : () async {
                      final titulo = controladorNome.text.trim();
                      if (titulo.isEmpty) return;

                      setStateDialog(() => salvando = true);

                      try {
                        final usuarioId = SessaoUsuario.usuario!.id;
                        await fvsService.criarFVS(
                          titulo: titulo,
                          usuarioId: usuarioId,
                          subsecaoId: adicionarEmTodasSubsecoes ? null : subsecaoAtual!.id,
                          obraId: adicionarEmTodasSubsecoes ? widget.obra.id : null,
                          aplicarEmTodas: adicionarEmTodasSubsecoes,
                        );

                        controladorNome.clear();
                        if (context.mounted) Navigator.pop(context);
                        chaveSessaoFvs.currentState?.carregarFvs();
                      } catch (e) {
                        setStateDialog(() => salvando = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff84E08F),
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                      fixedSize: const Size(120, 40),
                      side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    child: salvando
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Confirmar'),
                  ),
                  ElevatedButton(
                    onPressed: salvando ? null : () => Navigator.pop(context),
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
    }, indice: 3,),
    OpcoesMenuSuspenso(nome: 'Adicionar fvs', onTap: () {
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (_) => PopupFvsPadroes(
          subsecaoId: subsecaoAtual!.id,
          obraId: widget.obra.id,
          onFechar: () => Navigator.pop(context),
          onSucesso: () => chaveSessaoFvs.currentState?.carregarFvs(),
        ),
      );
    }, indice: 2,),
    OpcoesMenuSuspenso(nome: 'Qr Code', onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaQrCode(
        titulo: subsecaoAtual!.nome,
        carregarQrCode: () => subsecaoService.obterQrCode(subsecaoAtual!.id),
      )));
    }, indice: 1),
    OpcoesMenuSuspenso(nome: "Adicionar Subseção", onTap: () => _mostrarDialogAdicionarSubsecao(subsecaoParentId: subsecaoAtual!.id), indice: 0,),
  ];
}

//pop up adicionar subsecao

  void _mostrarDialogAdicionarSubsecao({int? subsecaoParentId}) {
    final controladorNomeSubsecao = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        bool salvando = false;
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              'Adicionar Subseção',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 22,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            content: TextField(
              controller: controladorNomeSubsecao,
              decoration: InputDecoration(
                labelText: 'Nome da Subseção',
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
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              ElevatedButton(
                onPressed: salvando
                    ? null
                    : () async {
                        final nome = controladorNomeSubsecao.text.trim();
                        if (nome.isEmpty) return;
                        setStateDialog(() => salvando = true);
                        try {
                          await subsecaoService.criarSubsecao(
                            nome,
                            widget.obra.id,
                            SessaoUsuario.usuario!.id,
                            paiId: subsecaoParentId, // null = raiz
                          );
                          if (context.mounted) Navigator.pop(context);

                          if(subsecaoParentId == null){
                            _carregarDados(); 
                          }
                          else{
                            if (_pilhaParticoesControlerPop.isNotEmpty) {
                              final (_, __, chaveParticao) = _pilhaParticoesControlerPop.last;
                              chaveParticao.currentState?.carregarDados();
                            }
                          }
                        } catch (e) {
                          setStateDialog(() => salvando = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff84E08F),
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  fixedSize: const Size(120, 40),
                  side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                child: salvando
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Confirmar'),
              ),
              ElevatedButton(
                onPressed: salvando ? null : () => Navigator.pop(context),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (controladorNavegacao.currentState?.canPop() == true) {
          controladorNavegacao.currentState?.pop();
          _pilhaParticoesControlerPop.removeLast();
          if (_pilhaParticoesControlerPop.isEmpty) {
            _definirOpcoesInicio();
          } else {
            final (particao, chave, chaveParticao) = _pilhaParticoesControlerPop.last;
            chaveSessaoFvs = chave; // restaura a key correta
            chaveParticao.currentState?.carregarDados();
            _definirOpcoesParticao(particao);
          }
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
            InformacaoObra(
              carregando: carregandoInfoObra || carregando, 
              nomeObra: nomeObra, 
              percetualObra: percentualObra, 
              fvsConforme: fvsConforme, 
              fvsNaoConforme: fvsNaoConforme, 
              obraId: widget.obra.id,
              onEditarNome: (novoNome) async {
                setState(() {
                  carregandoInfoObra = true;
                });
                try{
                  await obraService.atualizarNome(widget.obra.id, novoNome);
                  setState(() {
                    nomeObra = novoNome;
                    carregandoInfoObra = false;
                  },);
                }
                catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao atualizar nome.')),
                  );
                }
              },
              onExcluirObra: (obraId) async {
                try{
                  setState(() {
                    carregando = true;
                  });
                  await obraService.deletarObra(obraId);
                  if(context.mounted){
                    Navigator.of(context).pop();
                  }
                }
                catch(e){
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao excluir obra.')),
                    );
                  }
                }
              },
              ),
            Expanded(
              child: Navigator(
                key: controladorNavegacao,
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case '/particao':
                      final dadosParticao = settings.arguments as DadosParticao;
                      chaveSessaoFvs = GlobalKey<SessaoFvsState>();
                      final chaveParticao = GlobalKey<PaginaParticaoState>();
                      _pilhaParticoesControlerPop.add((dadosParticao, chaveSessaoFvs, chaveParticao));
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _definirOpcoesParticao(dadosParticao);
                        });
                        return MaterialPageRoute(
                          builder: (context) => PaginaParticao(
                            key: chaveParticao,
                            onFvsModificada: _carregarDados,
                            onNomeModificado: _carregarDadosBackStage,
                            onSubsecaoExcluida: () {
                              _pilhaParticoesControlerPop.removeLast();
                              if (_pilhaParticoesControlerPop.isEmpty) {
                                _definirOpcoesInicio();
                              } else {
                                final (particao, chave, chaveParticao) = _pilhaParticoesControlerPop.last;
                                chaveSessaoFvs = chave;
                                chaveParticao.currentState?.carregarDados();
                                _definirOpcoesParticao(particao);
                              }
                              _carregarDados();
                            },
                            dadosParticao: dadosParticao,
                            obraId: widget.obra.id,
                            chaveSessaoFvs: chaveSessaoFvs,
                            onTapParticao: (dadosFilha) {
                              controladorNavegacao.currentState?.pushNamed(
                                '/particao',
                                arguments: dadosFilha,
                              );
                            },
                          ),
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