import 'package:flutter/material.dart';
import 'package:fastfvs_front/view/pages/pagina_historico_fvs.dart';
import 'package:fastfvs_front/services/fvs_service.dart';
import 'package:fastfvs_front/services/sessao_usuario.dart';

class PopUpStatusFvs extends StatefulWidget {
  final String fvsId;
  final int obraId;
  final String nomeFvs;
  final DateTime dataUltimaEdicao;
  final String? nomeUltimoEditor;
  final Function(Color) statusSelecionado;
  final VoidCallback? onDeletado;

  const PopUpStatusFvs({
    required this.fvsId,
    required this.obraId,
    required this.statusSelecionado,
    required this.nomeFvs,
    required this.dataUltimaEdicao,
    this.nomeUltimoEditor,
    this.onDeletado,
    super.key,
  });

  @override
  State<PopUpStatusFvs> createState() => PopUpStatusFvsState();
}

class PopUpStatusFvsState extends State<PopUpStatusFvs> {
  String clicado = "";
  bool carregando = false;
  final FvsService fvsService = FvsService();

  Icon marcar(String opcao) {
    if (clicado == opcao) {
      return const Icon(Icons.check_box_outlined, size: 30);
    } else {
      return const Icon(Icons.check_box_outline_blank_outlined, size: 30);
    }
  }

  Future<void> _atualizarStatus(String novoStatus, String chaveClicado, Color cor) async {
    setState(() {
      carregando = true;
      clicado = chaveClicado;
    });

    try {
      final usuarioId = SessaoUsuario.usuario!.id;
      await fvsService.atualizarStatus(widget.fvsId, novoStatus, usuarioId);
      widget.statusSelecionado(cor);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => carregando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  String _doisDigitos(int n) => n.toString().padLeft(2, '0');

  String _formatarData(DateTime data) {
    return '${_doisDigitos(data.day)}/${_doisDigitos(data.month)}/${data.year}';
  }

  String _formatarHora(DateTime data) {
    return '${_doisDigitos(data.hour)}:${_doisDigitos(data.minute)}';
  }

  void _mostrarDialogoDeletar(BuildContext contextoPopup) {
    showDialog(
      context: contextoPopup,
      builder: (context) {
        bool deletarEmTodasSubsecoes = false;
        bool deletando = false;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Deletar FVS',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: deletarEmTodasSubsecoes,
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: deletando ? null : (v) {
                          setStateDialog(() {
                            deletarEmTodasSubsecoes = v ?? false;
                          });
                        },
                      ),
                      Text(
                        "Deletar FVS de todas\nas subseções",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                ElevatedButton(
                  onPressed: deletando ? null : () async {
                    setStateDialog(() => deletando = true);
                    try {
                      if (deletarEmTodasSubsecoes) {
                        await fvsService.deletarPorTituloNaObra(widget.obraId, widget.nomeFvs);
                      } else {
                        await fvsService.deletarFvs(widget.fvsId);
                      }
                      Navigator.pop(context);
                      widget.onDeletado?.call();
                      if (contextoPopup.mounted) Navigator.pop(contextoPopup);
                    } catch (e) {
                      setStateDialog(() => deletando = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff84E08F),
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    fixedSize: const Size(120, 40),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                  child: deletando
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Confirmar'),
                ),
                ElevatedButton(
                  onPressed: deletando ? null : () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(110, 40),
                    backgroundColor: const Color(0xffFF6D6D),
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.nomeFvs,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                      ),
                      IconButton(
                        onPressed: carregando ? null : () => _mostrarDialogoDeletar(context),
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 28),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        "Conforme",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: IconButton(
                        onPressed: carregando ? null : () => _atualizarStatus("CONFORME", "conforme", Colors.green),
                        icon: marcar("conforme"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        "Em análise",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: IconButton(
                        onPressed: carregando ? null : () => _atualizarStatus("EM_ANALISE", "em analise", Colors.yellow),
                        icon: marcar("em analise"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        "Não conforme",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: IconButton(
                        onPressed: carregando ? null : () => _atualizarStatus("NAO_CONFORME", "nao conforme", Colors.red),
                        icon: marcar("nao conforme"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 240,
                  height: 48,
                  child: Material(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaginaHistoricoFVS(
                              fvsId: widget.fvsId,
                              nomeFvs: widget.nomeFvs,
                            ),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          'Histórico de Alterações',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.account_box_rounded, size: 45),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      widget.nomeUltimoEditor ?? "Ainda não editada",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        _formatarData(widget.dataUltimaEdicao),
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                      Text(
                        _formatarHora(widget.dataUltimaEdicao),
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}