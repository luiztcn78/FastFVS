import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

//precisa ser statefull
//precisa recarregar quando uma fvs for modificada

class InformacaoObra extends StatefulWidget {
  final double percetualObra;
  final String nomeObra;
  final int fvsConforme;
  final int fvsNaoConforme;
  final bool carregando;
  final int obraId;
  final Future<void> Function(String novoNome) onEditarNome; 
  final Future<void> Function(int obraId) onExcluirObra;

  const InformacaoObra({super.key, required this.onExcluirObra, required this.onEditarNome, required this.obraId, this.carregando = true, required this.percetualObra, required this.nomeObra, required this.fvsConforme, required this.fvsNaoConforme});

  @override
  State<InformacaoObra> createState() => _InformacaoObraState();
}

class _InformacaoObraState extends State<InformacaoObra> {
  final TextEditingController _nomeObraController = TextEditingController();

  double get percetualObraDecimal => widget.percetualObra / 100;

  //dialog de editar o nome da obra
  void _abrirDialogoNome({
    required void Function(String) onConfirmar,
  }) 
  {
    _nomeObraController.text = widget.nomeObra;
    final cor = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cor.primary, width: 2),
        ),
        title: Text(
          "Editar nome da Obra",
          style: TextStyle(color: cor.onSecondary, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _nomeObraController,
          autofocus: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cor.primary, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cor.primary, width: 2),
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton(
            onPressed: () {
              onConfirmar(_nomeObraController.text.trim());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff84E08F),
              foregroundColor: cor.onSecondary,
              fixedSize: const Size(120, 40),
              side: BorderSide(color: cor.primary, width: 2),
            ),
            child: const Text('Confirmar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFF6D6D),
              foregroundColor: cor.onSecondary,
              fixedSize: const Size(120, 40),
              side: BorderSide(color: cor.primary, width: 2),
            ),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _abrirDialogoExcluirObra({
    required void Function(int) onConfirmar,
  }) 
  {
    final cor = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cor.primary, width: 2),
        ),
        title: Text(
          "Deseja excluir a obra?",
          style: TextStyle(color: cor.onSecondary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Esta ação não poderá ser revertida!",
          style: TextStyle(color: cor.onSecondary, fontWeight: FontWeight.bold),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton(
            onPressed: () {
              onConfirmar(widget.obraId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff84E08F),
              foregroundColor: cor.onSecondary,
              fixedSize: const Size(120, 40),
              side: BorderSide(color: cor.primary, width: 2),
            ),
            child: const Text('Confirmar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFF6D6D),
              foregroundColor: cor.onSecondary,
              fixedSize: const Size(120, 40),
              side: BorderSide(color: cor.primary, width: 2),
            ),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: Theme.of(context).colorScheme.primary)
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: CircularPercentIndicator(
              circularStrokeCap: CircularStrokeCap.round,
              radius: 55.0,
              lineWidth: 10.0,
              percent: percetualObraDecimal,        // 0.0 até 1.0 (75%)
              center: Container(
                width: 70,
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary
                ),
                child: Text('${widget.percetualObra.toStringAsFixed(0)}%', 
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onPrimary
                  ),
                )
              ),
              progressColor: Colors.green,
              backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
          ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 7.0, right: 15.0, bottom: 4.0, top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 165),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(widget.nomeObra, 
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 22,
                                color: Theme.of(context).colorScheme.onSecondary
                              ),
                            ),
                          ),
                          if (widget.carregando)
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _abrirDialogoNome(
                        onConfirmar: (novoNome) async {
                          await widget.onEditarNome(novoNome);
                        }
                        ),
                      child: Icon(
                        Icons.edit_square,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _abrirDialogoExcluirObra(
                        onConfirmar: (obraId) async {
                          await widget.onExcluirObra(obraId);
                        }),
                      child: Icon(
                        Icons.delete_forever,
                        color: Theme.of(context).colorScheme.primary,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.0, bottom: 3.0),
                  child: Text("Resumo de Conformidade",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSecondary
                    ),)
                  ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width * 0.6, 
                  lineHeight: 14.0,
                  percent: percetualObraDecimal,
                  progressColor: Colors.green,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  barRadius: Radius.circular(8),
                  animation: true,
                  animationDuration: 800,
                ),
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7.0, top: 5.0),
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 1.0, top: 5),
                    child: Text("${widget.fvsConforme} Conformes",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSecondary
                      ),)
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7.0, top: 5.0),
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 1.0, top: 5),
                    child: Text("${widget.fvsNaoConforme} Não conformes",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSecondary
                      ),)
                  )
                ],
              )
            ],
          ),
        ),
        ] 
      ),
    );
  }
}