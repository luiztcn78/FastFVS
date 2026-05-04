

import 'package:fastfvs_front/config/theme_light.dart';
import 'package:fastfvs_front/view/pages/pagina_configuracao.dart';
import 'package:fastfvs_front/view/pages/pagina_ler_qrcode.dart';
import 'package:fastfvs_front/view/pages/pagina_minhas_obras.dart';
import 'package:flutter/material.dart';

class PaginaBase extends StatefulWidget{
  const PaginaBase({super.key});

 @override
  State<PaginaBase> createState() => _PaginaBaseState();
}

class _PaginaBaseState extends State<PaginaBase> {
  
  int _index = 0;

  final List<Widget> _paginas = [
    PaginaConfiguracao(),
    PaginaLerQrcode(),
    PaginaMinhasObras()
  ];


  @override
  Widget build(BuildContext context){
    final iconTamanho = MediaQuery.of(context).size.width * 0.12;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3C1E01),
        title: Text("FastFVS",style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.account_circle, size: iconTamanho, color: Colors.white,))
        ],
      ),
      body: _paginas[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: Color(0xFF3C1E01),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined, size: iconTamanho, color: Colors.white,), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined, size: iconTamanho, color: Colors.white), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: iconTamanho, color: Colors.white), label: '')
        ]
      ),
    );
  }
}