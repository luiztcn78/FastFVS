import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:flutter/material.dart';

class PaginaQrCode extends StatelessWidget {
  const PaginaQrCode({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      paginaAberta: 0,
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2, color: Theme.of(context).colorScheme.primary)
              )
            ),
            child: Text("Residencial Flores", style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 32,
              color: Theme.of(context).colorScheme.onSecondary
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.5,
            child: Image.network('https://media.istockphoto.com/id/1195424494/pt/vetorial/vector-qr-code-sample-for-smartphone-scanning-isolated-on-white-background.jpg?s=1024x1024&w=is&k=20&c=21li7zdG1T7DmNxn_E7W03UNHKZnFvUYTEle8asNlng='),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
              backgroundColor: Theme.of(context).colorScheme.primary
            ),
            onPressed: (){}, 
            child: Text("Baixar", style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onPrimary)
            )
          )
        ],
      )
    );
  }
}
