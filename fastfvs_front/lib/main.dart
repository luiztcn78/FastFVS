import 'package:fastfvs_front/config/theme_light.dart';
import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/pages/pagina_configuracao.dart';
import 'package:fastfvs_front/view/pages/pagina_ler_qrcode.dart';
import 'package:fastfvs_front/view/pages/pagina_minhas_obras.dart';
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
      initialRoute: '/minhasObras',
      onGenerateRoute: (settings) {
        Widget page = switch (settings.name) {
          '/minhasObras'  => const PaginaMinhasObras(),
          '/LerQRCode'    => const PaginaLerQrcode(),
          '/Configuracao' => const PaginaConfiguracao(),
          _               => const PaginaMinhasObras(),
        };

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, child) => child,
        );
      },
    );
  }
}

