  import 'package:fastfvs_front/view/widgets/container_particao.dart';
  import 'package:flutter/material.dart';


  class ListaContainersParticao extends StatelessWidget {
    final List<String> particoes;

    const ListaContainersParticao({required this.particoes, super.key});
    

    @override
    Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 0,
          runSpacing: 0,
          children: particoes.map((particao) =>
            ContainerParticao(nome: particao)
          ).toList(),
        ),
      );
    }
  }