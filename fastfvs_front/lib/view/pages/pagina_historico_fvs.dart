import 'package:fastfvs_front/models/historico_fvs.dart';
import 'package:fastfvs_front/services/historico_service.dart';
import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/widgets/historico_cartao.dart';
import 'package:flutter/material.dart';

class PaginaHistoricoFVS extends StatefulWidget {
  final String fvsId;
  final String nomeFvs;

  const PaginaHistoricoFVS({required this.fvsId, required this.nomeFvs, super.key});

  @override
  State<PaginaHistoricoFVS> createState() => _PaginaHistoricoFVSState();
}

class _PaginaHistoricoFVSState extends State<PaginaHistoricoFVS> {
  final HistoricoService historicoService = HistoricoService();
  List<HistoricoFvs> historico = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    try {
      final lista = await historicoService.listarHistoricoFvs(widget.fvsId);
      if (!mounted) return;
      setState(() {
        historico = lista;
        carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => carregando = false);
    }
  }

  String _traduzirAcao(String acao) {
    switch (acao) {
      case 'CRIACAO':
        return 'Criação';
      case 'EDICAO_STATUS':
        return 'Edição';
      default:
        return acao;
    }
  }

  String _formatarData(DateTime data) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(data.day)}/${dois(data.month)}/${data.year} - ${dois(data.hour)}:${dois(data.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      paginaAberta: 0,
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.nomeFvs,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3C1E01),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (historico.isEmpty)
                    const Text('Nenhuma alteração registrada ainda.')
                  else
                    ...historico.expand((item) => [
                          HistoricoCartao(
                            tipoAlteracao: _traduzirAcao(item.acao),
                            dataAlteracao: _formatarData(item.momentoAcao),
                            usuario: item.nomeUsuario,
                          ),
                          const SizedBox(height: 16),
                        ]),
                ],
              ),
            ),
    );
  }
}