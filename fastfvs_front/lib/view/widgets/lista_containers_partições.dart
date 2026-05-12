import 'package:fastfvs_front/view/widgets/container_particao.dart';
import 'package:flutter/material.dart';

class ListaContainersParticao extends StatelessWidget {
  const ListaContainersParticao({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 0,
        runSpacing: 0,
        children: [
          ContainerParticao(),
          ContainerParticao(),
          ContainerParticao(),
          ContainerParticao(),
          ContainerParticao(),
          ContainerParticao(),
          ContainerParticao(),
          ContainerParticao(),
          ContainerParticao(),
          ContainerParticao(),                
        ],
      ),
    );
  }
}