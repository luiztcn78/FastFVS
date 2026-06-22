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

  const InformacaoObra({super.key, this.carregando = true, required this.percetualObra, required this.nomeObra, required this.fvsConforme, required this.fvsNaoConforme});

  @override
  State<InformacaoObra> createState() => _InformacaoObraState();
}

class _InformacaoObraState extends State<InformacaoObra> {

  double get percetualObraDecimal => widget.percetualObra / 100;

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
                      constraints: BoxConstraints(maxWidth: 175),
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
                      onTap: () {
                        // puxar pra pagin de editar oubra ou aquelade adicionar sla
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const PaginaEditarObra()));
                      },
                      child: Icon(
                        Icons.edit_square, // Ícone que remete ao da imagem
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
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