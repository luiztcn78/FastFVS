import 'package:fastfvs_front/view/widgets/popup_status_fvs.dart';
import 'package:flutter/material.dart';

class Fvs extends StatefulWidget {
  final String nome;
  const Fvs({required this.nome, super.key});

  @override
  State<Fvs> createState() => FvsState();
}


class FvsState extends State<Fvs>{

  Color status = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              insetPadding: EdgeInsets.zero,
              child: PopUpStatusFvs(statusSelecionado: (cor) {
                setState(() => status = cor);
              },
                nomeFvs: widget.nome),
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.height*0.055,
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
                  color: Theme.of(context).colorScheme.onSecondary)
                  ),),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}