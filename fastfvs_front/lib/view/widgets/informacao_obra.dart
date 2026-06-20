import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class InformacaoObra extends StatelessWidget {
  const InformacaoObra({super.key});

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
              percent: 0.31,        // 0.0 até 1.0 (75%)
              center: Container(
                width: 70,
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary
                ),
                child: Text('31%', 
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
                    Text("Residencial Flores", 
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onSecondary
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
                        size: 28,
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
                  percent: 0.31,
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
                    child: Text("21" + " Conformes",
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
                    child: Text("87" + " Não conformes",
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