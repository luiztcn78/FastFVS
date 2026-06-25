import 'package:fastfvs_front/services/sessao_usuario.dart';
import 'package:flutter/material.dart';
import 'package:fastfvs_front/view/widgets/bolinhas_carregamento.dart';

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
    final results = await Future.wait([
      SessaoUsuario.recarregarSessaoSalva(),
      Future.delayed(const Duration(seconds: 30)),
    ]);
    final temSessao = results[0] as bool;

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        temSessao ? '/minhasObras' : '/login',
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