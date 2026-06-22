import 'package:fastfvs_front/models/fvs.dart' as model;
import 'package:fastfvs_front/services/fvs_service.dart';
import 'package:fastfvs_front/view/widgets/fvs.dart';
import 'package:flutter/material.dart';

class SessaoFvs extends StatefulWidget {
  final int subsecaoId;
  final int obraId;
  final VoidCallback? onFvsModificada;

  const SessaoFvs({required this.subsecaoId, required this.obraId, this.onFvsModificada, super.key});

  @override
  State<SessaoFvs> createState() => SessaoFvsState();
}

class SessaoFvsState extends State<SessaoFvs> {
  final FvsService fvsService = FvsService();
  List<model.Fvs> listaFvs = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarFvs();
  }

  Future<void> carregarFvs() async {
    final lista = await fvsService.listarFvsPorSubsecao(widget.subsecaoId);
    if (!mounted) return;
    setState(() {
      listaFvs = lista;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (listaFvs.isEmpty) {
      return Center(
        child: Text(
          "Nenhuma FVS cadastrada nesta subseção.",
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: listaFvs.length,
      itemBuilder: (context, index) {
        final fvs = listaFvs[index];
        return Fvs(
          key: ValueKey(fvs.id),
          onFvsModificada: widget.onFvsModificada,
          id: fvs.id,
          nome: fvs.titulo,
          status: fvs.status,
          obraId: widget.obraId,
          dataUltimaEdicao: fvs.dataUltimaEdicao,
          nomeUltimoEditor: fvs.ultimaEdicaoPorNome,
          onDeletado: carregarFvs,
          onAtualizado: carregarFvs,
        );
      },
    );
  }
}