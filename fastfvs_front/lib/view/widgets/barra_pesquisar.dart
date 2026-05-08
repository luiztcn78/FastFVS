import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/widgets/botao_obra.dart';
import 'package:flutter/material.dart';

class BarraPesquisar extends StatefulWidget{
  final Function(Widget) abrirPagina;
  const BarraPesquisar({required this.abrirPagina, super.key});

  @override
  State<BarraPesquisar> createState() => BarraPesquisarState();
}

class BarraPesquisarState extends State<BarraPesquisar> {
  List<String> lista_teste = ["x", 'y', 'z'];
  List<String> lista_teste_filtrada = [];

  @override
  void initState() {
    super.initState();
    lista_teste_filtrada = lista_teste;
  }

  void filtrar(String texto) {
    setState(() {
      lista_teste_filtrada = lista_teste.where((item) => item.toLowerCase().contains(texto.toLowerCase())).toList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.search),
            Expanded(
              child: TextField(
                onChanged: filtrar,
              )
            ),
          ]
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: lista_teste_filtrada.length,
          itemBuilder: (context, index) {
            return botao_obra(abrirPagina: widget.abrirPagina, nome: lista_teste_filtrada[index]);
          },
        ),
      ],
    );
  }
}


  