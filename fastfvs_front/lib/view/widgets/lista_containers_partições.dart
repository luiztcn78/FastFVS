import 'package:fastfvs_front/models/dados_particao.dart';
import 'package:fastfvs_front/view/widgets/container_particao.dart';
import 'package:flutter/material.dart';

class ListaContainersParticao extends StatefulWidget {
  final List<DadosParticao> particoes;
  final Function(DadosParticao)? onTapParticao;

  const ListaContainersParticao({required this.particoes, this.onTapParticao, super.key});

  @override
  State<ListaContainersParticao> createState() => _ListaContainersParticaoState();
}

class _ListaContainersParticaoState extends State<ListaContainersParticao> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 0,
        runSpacing: 0,
        children: widget.particoes.map((particao) =>
          ContainerParticao(
            dadosParticao: particao,
            onTapParticao: widget.onTapParticao,
          ),
        ).toList(),
      ),
    );
  }
}