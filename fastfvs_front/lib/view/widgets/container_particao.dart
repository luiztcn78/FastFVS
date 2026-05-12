import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ContainerParticao extends StatelessWidget {
  const ContainerParticao({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10, bottom: 15, right: 10),
      child: Container(
        width: 160,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 7),
                child: Text("Bloco A", style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.onSecondary)
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: Row(
                  children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: LinearPercentIndicator(
                  width: 115, 
                  lineHeight: 14.0,
                  percent: 0.31,
                  progressColor: Colors.green,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  barRadius: Radius.circular(8),
                  animation: true,
                  animationDuration: 800,
                  trailing: Text("100%"),
                ),
              ),
            ],
          ),
      ),
    );
  }
}