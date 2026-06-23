import 'package:fastfvs_front/models/obra.dart';
import 'package:fastfvs_front/view/widgets/botao_obra.dart';
import 'package:flutter/material.dart';

class BarraPesquisar extends StatefulWidget{
  final List<Obra> listaObras;
  final VoidCallback? onVoltarObra;

  const BarraPesquisar({this.onVoltarObra, required this.listaObras, super.key});

  @override
  State<BarraPesquisar> createState() => BarraPesquisarState();
}

class BarraPesquisarState extends State<BarraPesquisar> {
  List<Obra> listaObras = [];
  List<Obra> listaObrasFiltrada = [];

  @override
  void initState() {
    super.initState();
    listaObras = widget.listaObras;
    listaObrasFiltrada = listaObras;
  }

  void filtrar(String texto) {
    setState(() {
      listaObrasFiltrada = listaObras.where((item) => item.nome.toLowerCase().contains(texto.toLowerCase())).toList();
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
                  child: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                ),
                Expanded(
                  child: TextField(
                    onChanged: filtrar,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Buscar Obras", hintStyle: TextStyle(
                        color: Colors.grey
                      )
                    ),
                  )
                ),
              ]
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listaObrasFiltrada.length,
            itemBuilder: (context, index) {
              return BotaoObra(obra: listaObrasFiltrada[index], onVoltarObra: widget.onVoltarObra,);
            },
          ),
        ),
      ],
    );
  }
}


  