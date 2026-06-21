import 'package:fastfvs_front/config/theme_light.dart';
import 'package:fastfvs_front/config/theme_dark.dart';
import 'package:fastfvs_front/services/sessao_usuario.dart';
import 'package:fastfvs_front/view/pages/pagina_configuracao.dart';
import 'package:fastfvs_front/view/pages/pagina_ler_qrcode.dart';
import 'package:fastfvs_front/view/pages/pagina_minhas_obras.dart';
import 'package:fastfvs_front/view/pages/pagina_carregamento.dart';
import 'package:fastfvs_front/view/pages/pagina_login.dart';
import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final temSessao = await SessaoUsuario.recarregarSessaoSalva();
  runApp(MyApp(rotaInicial: temSessao ? '/minhasObras' : '/login'));
}

class MyApp extends StatelessWidget {
  final String rotaInicial;

  const MyApp({super.key, required this.rotaInicial});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FastFVS',
          theme: ThemeLight.theme,
          darkTheme: ThemeDark.theme,
          themeMode: currentMode,
          initialRoute: rotaInicial,
          onGenerateRoute: (settings) {
            Widget page = switch (settings.name) {
              '/login' => const PaginaLogin(),
              '/minhasObras' => const PaginaMinhasObras(),
              '/LerQRCode' => const PaginaLerQrcode(),
              '/Configuracao' => const PaginaConfiguracao(),
              '/Carregamento' => const PaginaCarregamento(),
              _ => const PaginaMinhasObras(),
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
      },
    );
  }
}
