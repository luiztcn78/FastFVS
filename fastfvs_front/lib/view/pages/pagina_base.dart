

import 'package:fastfvs_front/config/theme_light.dart';
import 'package:fastfvs_front/view/pages/pagina_configuracao.dart';
import 'package:fastfvs_front/view/pages/pagina_ler_qrcode.dart';
import 'package:fastfvs_front/view/pages/pagina_minhas_obras.dart';
import 'package:flutter/material.dart';

class PaginaBase extends StatefulWidget{
  final Widget body;
  final int paginaAberta;

  const PaginaBase({required this.body, required this.paginaAberta});

 @override
  State<PaginaBase> createState() => PaginaBaseState();
}

class PaginaBaseState extends State<PaginaBase> {
  

  void trocarTela(int index) {
    switch(index){
      case 0:
        Navigator.pushReplacementNamed(context, '/minhasObras');
      case 1:
        Navigator.pushReplacementNamed(context, '/LerQRCode');
      case 2:
        Navigator.pushReplacementNamed(context, '/Configuracao');
    }
  }

  @override
  Widget build(BuildContext context){
    final iconTamanho = MediaQuery.of(context).size.width * 0.12;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("FastFVS",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.account_circle, size: iconTamanho, color: Theme.of(context).colorScheme.onPrimary,))
        ],
      ),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.paginaAberta,
        onTap: trocarTela,
        backgroundColor: Theme.of(context).colorScheme.primary,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: iconTamanho, color: Theme.of(context).colorScheme.onPrimary), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined, size: iconTamanho, color: Theme.of(context).colorScheme.onPrimary), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined, size: iconTamanho, color: Theme.of(context).colorScheme.onPrimary,), label: ''),
        ]
      ),
    );
  }
}