import 'package:fastfvs_front/models/dados_particao.dart';
import 'package:fastfvs_front/services/subsecao_service.dart';
import 'package:fastfvs_front/view/pages/sessao_fvs.dart';
import 'package:fastfvs_front/view/widgets/botao_particao_baixo.dart';
import 'package:fastfvs_front/view/widgets/container_particao.dart';
import 'package:fastfvs_front/view/widgets/lista_containers_parti%C3%A7%C3%B5es.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PaginaParticao extends StatefulWidget {
  final DadosParticao dadosParticao;
  final int obraId;
  final Function(DadosParticao)? onTapParticao;
  final GlobalKey<SessaoFvsState>? chaveSessaoFvs;

  const PaginaParticao({
    super.key,
    required this.dadosParticao,
    required this.obraId,
    this.onTapParticao,
    this.chaveSessaoFvs,
  });

  @override
  State<PaginaParticao> createState() => PaginaParticaoState();
}

class PaginaParticaoState extends State<PaginaParticao> {
  final controladorNavegacao = GlobalKey<NavigatorState>();

  final SubsecaoService subsecaoService = SubsecaoService();
  List<DadosParticao> dadosParticoesSubsecao = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final subsecoes = await subsecaoService.listarFilhas(widget.dadosParticao.id);
    final dadosSubsecoes = await Future.wait(
      subsecoes.map((subsecao) async {
        final conformidade = await subsecaoService.getConformidade(subsecao.id);
        return subsecaoService.statusPresentesNasubsecao(subsecao.id, subsecao.nome, conformidade);
      })
    );
    setState(() {
      carregando = false;
      dadosParticoesSubsecao = dadosSubsecoes;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContainerParticao(
          dadosParticao: widget.dadosParticao,
          largura: MediaQuery.of(context).size.width * 0.9,
          serBotao: false,
        ),
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
                    pageBuilder: (context, _, __) => carregando
                      ? SingleChildScrollView(
                          child: Wrap(
                            children: List.generate(6, (_) => Shimmer.fromColors(
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
                      : ListaContainersParticao(particoes: dadosParticoesSubsecao, onTapParticao: widget.onTapParticao,),
                        transitionDuration: Duration.zero,
                  );
                default:
                  return PageRouteBuilder(
                    pageBuilder: (context, _, __) => SessaoFvs(
                      key: widget.chaveSessaoFvs,
                      subsecaoId: widget.dadosParticao.id,
                      obraId: widget.obraId,
                    ),
                    transitionDuration: Duration.zero,
                  );
              }
            },
          ),
        ),
      ],
    );
  }
}