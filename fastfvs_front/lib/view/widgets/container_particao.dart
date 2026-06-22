import 'package:fastfvs_front/models/dados_particao.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ContainerParticao extends StatefulWidget {
  final double largura;
  final double altura;
  final bool serBotao;
  final DadosParticao dadosParticao;
  final Function(DadosParticao)? onTapParticao;

  const ContainerParticao({
    required this.dadosParticao,
    this.serBotao = true,
    this.largura = 160,
    this.altura = 100,
    this.onTapParticao,
    super.key,
  });

  @override
  State<ContainerParticao> createState() => _ContainerParticaoState();
}

class _ContainerParticaoState extends State<ContainerParticao> {

  double get percentualConformidade => widget.dadosParticao.percentualConformidade / 100;

  Widget _bolinha(Color cor) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: cor,
        ),
      ),
    );
  }

  //==============verifica se é botão ou não (por conta do reuso em momento em que não é pra redirecionar)============
  @override
  Widget build(BuildContext context) {
    verificarBotao() {
      if (widget.serBotao) {
        return widget.onTapParticao != null
          ? () => widget.onTapParticao!(widget.dadosParticao)
          : () => Navigator.of(context, rootNavigator: false).pushNamed('/particao', arguments: widget.dadosParticao);
      } else {
        return null;
      }
    }

    double larguraBarra = widget.largura - 45;

    return InkWell(
      //rota (isso dá problema no voltar, para tratar tem que definir no paginaobrastate state o comportamento do pop)

      onTap: verificarBotao(),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, bottom: 15, right: 10),
        child: Container(
          width: widget.largura,
          height: widget.altura,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 7),
                child: Text(
                  widget.dadosParticao.nome,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    if (widget.dadosParticao.mostrarVerde)    _bolinha(Colors.green),
                    if (widget.dadosParticao.mostrarAmarelo)  _bolinha(Colors.yellow),
                    if (widget.dadosParticao.mostrarVermelho) _bolinha(Colors.red),
                    if (widget.dadosParticao.mostrarCinza)    _bolinha(Colors.grey),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: LinearPercentIndicator(
                  width: larguraBarra,
                  lineHeight: 14.0,
                  percent: percentualConformidade,
                  progressColor: Colors.green,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  barRadius: const Radius.circular(8),
                  animation: true,
                  animationDuration: 800,
                  trailing: Text("${widget.dadosParticao.percentualConformidade.toStringAsFixed(0)}%"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}