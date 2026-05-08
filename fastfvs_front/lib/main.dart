import 'package:fastfvs_front/config/theme_light.dart';
import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastFVS',
      theme: ThemeLight.theme,
      home: PaginaBase(),
    );
  }
}

