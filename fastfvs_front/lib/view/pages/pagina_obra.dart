import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/pages/pagina_particao.dart';
import 'package:fastfvs_front/view/widgets/container_particao.dart';
import 'package:fastfvs_front/view/widgets/informacao_obra.dart';
import 'package:fastfvs_front/view/widgets/lista_containers_parti%C3%A7%C3%B5es.dart';
import 'package:flutter/material.dart';

class PaginaObra extends StatefulWidget{
  const PaginaObra({super.key});

@override
  State<PaginaObra> createState() => PaginaObraState();
}

class PaginaObraState extends State<PaginaObra> {
final controladorNavegacao = GlobalKey<NavigatorState>();
  
  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      paginaAberta: 0,
      body: Column(
          children: [
            InformacaoObra(),
            Expanded(
              child: Navigator(
                key: controladorNavegacao,
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                  case '/particao':
                    return MaterialPageRoute(
                      builder: (context) => PaginaParticao(),
                    );
                  default:
                    return MaterialPageRoute(
                      builder: (context) => ListaContainersParticao(),
                    );
                  }
                },
              )
            )
          ],
        ),
    );
  }
}