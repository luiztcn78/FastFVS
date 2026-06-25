import 'package:flutter/material.dart';
import 'package:fastfvs_front/view/widgets/bolinhas_carregamento.dart';
import 'package:fastfvs_front/view/pages/pagina_login.dart';

class PaginaCarregamento extends StatefulWidget {
  const PaginaCarregamento({super.key});

  @override
  State<PaginaCarregamento> createState() => _PaginaCarregamentoState();
}

class _PaginaCarregamentoState extends State<PaginaCarregamento> {
  @override
  void initState() {
    super.initState();
    _iniciarCarregamento();
  }

  Future<void> _iniciarCarregamento() async {

    await Future.delayed(const Duration(seconds: 10));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PaginaLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 140),
                Image.asset(
                  'assets/images/logo_fastfvs.png',
                  width: 250,
                ),
                const SizedBox(height: 30),
                BolinhasCarregamento(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}