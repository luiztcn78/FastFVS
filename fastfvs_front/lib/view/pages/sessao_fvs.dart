import 'package:fastfvs_front/view/widgets/fvs.dart';
import 'package:fastfvs_front/view/widgets/popup_status_fvs.dart';
import 'package:flutter/material.dart';

class SessaoFvs extends StatelessWidget {
  const SessaoFvs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Expanded(
        child: Column(
          children: [
            Fvs(nome: "Teste"),
            Fvs(nome: "nome")
          ],
        ),
      ),
    );
  }
}