import 'package:flutter/material.dart';
import 'package:fastfvs_front/view/widgets/rodape_acesso.dart';
import 'package:fastfvs_front/view/widgets/bolinhas_carregamento.dart';
import 'package:fastfvs_front/view/pages/pagina_login.dart';

class PaginaCarregamento extends StatelessWidget {
  const PaginaCarregamento({super.key});

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                 const SizedBox(height: 140),
                Image.asset('assets/images/logo_fastfvs.png',
                width: 250,),

                const SizedBox(height: 30),
                BolinhasCarregamento(),
                const SizedBox(height: 30),
                
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaginaLogin()),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Entrar',
                    style: TextStyle(fontSize: 18, 
                    color:Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ],
            ),
          ),         
        ],
      )
      );
    }   
  }