import 'package:fastfvs_front/models/obra.dart';
import 'package:fastfvs_front/models/usuario.dart';
import 'package:fastfvs_front/services/obra_service.dart';
import 'package:fastfvs_front/services/sessao_usuario.dart';
import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/pages/pagina_criar_obra.dart';
import 'package:fastfvs_front/view/widgets/barra_pesquisar.dart';
import 'package:flutter/material.dart';

class PaginaMinhasObras extends StatefulWidget {
  const PaginaMinhasObras({super.key});

  @override
  State<PaginaMinhasObras> createState() => _PaginaMinhasObrasState();
}

class _PaginaMinhasObrasState extends State<PaginaMinhasObras> {
  List<Obra> listaObras = [];
  bool carregando = true;
  final obraService = ObraService();


  @override
  void initState() {
    super.initState();
    carregarObras();
  }

 Future<void> carregarObras() async {
  setState(() => carregando = true);

  final usuario = SessaoUsuario.usuario;
  if (usuario == null) {
    // sessão perdida, manda pro login
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
    return;
  }

  final obras = await obraService.listarObraPorUsuario(usuario.id);
  setState(() {
    listaObras = obras;
    carregando = false;
  });
}

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final cor = Theme.of(context).colorScheme;


    return PaginaBase(
      paginaAberta: 0,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: largura * 0.1),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Minhas Obras",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: largura * 0.06,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: carregando
                  ? const Center(child: CircularProgressIndicator())
                  : BarraPesquisar(listaObras: listaObras, onVoltarObra: carregarObras,),
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: ElevatedButton.icon(
              onPressed: () async {
                final criou = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const PaginaCriarObra()),
                );
                if (criou == true) {
                  carregarObras();
                }
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add Obra",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: cor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
