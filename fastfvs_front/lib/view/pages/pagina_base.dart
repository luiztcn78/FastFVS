import 'package:flutter/material.dart';

class PaginaBase extends StatefulWidget{
  final Widget body;
  final int paginaAberta;
  final Widget? botaoFlutuante;

  const PaginaBase({this.botaoFlutuante, required this.body, required this.paginaAberta});

 @override
  State<PaginaBase> createState() => PaginaBaseState();
}

class PaginaBaseState extends State<PaginaBase> {
  

  void trocarTela(int index) {
    switch(index){
      case 0:
        Navigator.pushReplacementNamed(context, '/minhasObras');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/LerQRCode');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/Configuracao');
        break;
    }
  }

  @override
  Widget build(BuildContext context){
    final iconTamanho = MediaQuery.of(context).size.width * 0.08;

    return Scaffold(
      floatingActionButton: widget.botaoFlutuante,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("FastFVS",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.account_circle, size: iconTamanho, color: Theme.of(context).colorScheme.onPrimary,))
        ],
      ),
      body: widget.body,
      bottomNavigationBar: Container(
        height: 56,
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home_outlined, size: 30, color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () => trocarTela(0),
            ),
            IconButton(
              icon: Icon(Icons.camera_alt_outlined, size: 30, color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () => trocarTela(1),
            ),
            IconButton(
              icon: Icon(Icons.settings_outlined, size: 30, color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () => trocarTela(2),
            ),
          ],
        ),
      ),
    );
  }
}