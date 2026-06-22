import 'package:flutter/material.dart';
import 'package:fastfvs_front/view/widgets/popup_status_fvs.dart';

class Fvs extends StatefulWidget {
  final String id;
  final String nome;
  final String status;
  final int obraId;
  final DateTime dataUltimaEdicao;
  final String? nomeUltimoEditor;
  final VoidCallback? onDeletado;
  final VoidCallback? onAtualizado;
  final VoidCallback? onFvsModificada;

  const Fvs({
    required this.id,
    required this.nome,
    required this.status,
    required this.obraId,
    required this.dataUltimaEdicao,
    this.nomeUltimoEditor,
    this.onDeletado,
    this.onAtualizado,
    this.onFvsModificada,
    super.key,
  });

  @override
  State<Fvs> createState() => FvsState();
}

class FvsState extends State<Fvs> {
  late Color status;

  @override
  void initState() {
    super.initState();
    status = _corPorStatus(widget.status);
  }

  Color _corPorStatus(String s) {
    switch (s) {
      case 'CONFORME':
        return Colors.green;
      case 'EM_ANALISE':
        return Colors.yellow;
      case 'NAO_CONFORME':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                insetPadding: EdgeInsets.zero,
                child: PopUpStatusFvs(
                  fvsId: widget.id,
                  obraId: widget.obraId,
                  nomeFvs: widget.nome,
                  dataUltimaEdicao: widget.dataUltimaEdicao,
                  nomeUltimoEditor: widget.nomeUltimoEditor,
                  onDeletado: widget.onDeletado,
                  statusSelecionado: (cor) {
                    setState(() => status = cor);
                    widget.onFvsModificada?.call();
                  },
                ),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.055,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(widget.nome,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSecondary)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: status),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}