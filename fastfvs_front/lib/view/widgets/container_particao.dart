import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ContainerParticao extends StatelessWidget {
  final double largura;
  final double altura;
  final bool serBotao;
  final String nome;
  final bool mostrarVerde;
  final bool mostrarAmarelo;
  final bool mostrarVermelho;
  final bool mostrarCinza;

  const ContainerParticao({
    required this.nome,
    this.serBotao = true,
    this.largura = 160,
    this.altura = 100,
    this.mostrarVerde = true,
    this.mostrarAmarelo = true,
    this.mostrarVermelho = true,
    this.mostrarCinza = true,
    super.key,
  });

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
      if (serBotao) {
        return () => Navigator.of(context, rootNavigator: false).pushNamed('/particao');
      } else {
        return null;
      }
    }

    double larguraBarra = largura - 45;

    return InkWell(
      //rota (isso dá problema no voltar, para tratar tem que definir no paginaobrastate state o comportamento do pop)

      onTap: verificarBotao(),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, bottom: 15, right: 10),
        child: Container(
          width: largura,
          height: altura,
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
                  nome,
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
                    if (mostrarVerde)    _bolinha(Colors.green),
                    if (mostrarAmarelo)  _bolinha(Colors.yellow),
                    if (mostrarVermelho) _bolinha(Colors.red),
                    if (mostrarCinza)    _bolinha(Colors.grey),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: LinearPercentIndicator(
                  width: larguraBarra,
                  lineHeight: 14.0,
                  percent: 0.31,
                  progressColor: Colors.green,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  barRadius: const Radius.circular(8),
                  animation: true,
                  animationDuration: 800,
                  trailing: const Text("100%"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}