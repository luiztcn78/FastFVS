

import 'package:fastfvs_front/config/theme_light.dart';
import 'package:fastfvs_front/view/pages/pagina_configuracao.dart';
import 'package:fastfvs_front/view/pages/pagina_ler_qrcode.dart';
import 'package:fastfvs_front/view/pages/pagina_minhas_obras.dart';
import 'package:flutter/material.dart';

class PaginaBase extends StatefulWidget{
  const PaginaBase({super.key});

 @override
  State<PaginaBase> createState() => PaginaBaseState();
}

class PaginaBaseState extends State<PaginaBase> {
  
  int _index = 0;
  Widget? _paginaExtra;

  void abrirPagina(Widget pagina) {
    setState(() {
      _paginaExtra = pagina;
    });
  }

  void fecharPagina() {
    setState(() {
      _paginaExtra = null;
    });
  }


  @override
  Widget build(BuildContext context){
    final iconTamanho = MediaQuery.of(context).size.width * 0.12;

    final List<Widget> _paginas = [
    PaginaMinhasObras(abrirPagina: abrirPagina,),
    PaginaLerQrcode(),
    PaginaConfiguracao(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("FastFVS",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.account_circle, size: iconTamanho, color: Theme.of(context).colorScheme.onPrimary,))
        ],
      ),
      body: _paginaExtra ?? _paginas[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i){ 
          _paginaExtra = null;
          setState(() => _index = i);
          },
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