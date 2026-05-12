import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/widgets/botao_obra.dart';
import 'package:flutter/material.dart';

class BarraPesquisar extends StatefulWidget{
  const BarraPesquisar({super.key});

  @override
  State<BarraPesquisar> createState() => BarraPesquisarState();
}

class BarraPesquisarState extends State<BarraPesquisar> {
  List<String> lista_teste = ["x", 'y', 'z', "a", 'b', 'c'];
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
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.width*0.07, 
            top: 10.0, 
            left: MediaQuery.of(context).size.width*0.07, 
            right: MediaQuery.of(context).size.width*0.07),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Theme.of(context).colorScheme.primary)
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.search),
                ),
                Expanded(
                  child: TextField(
                    onChanged: filtrar,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Buscar Obras"
                    ),
                  )
                ),
              ]
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: lista_teste_filtrada.length,
            itemBuilder: (context, index) {
              return botao_obra(nome: lista_teste_filtrada[index]);
            },
          ),
        ),
      ],
    );
  }
}


  