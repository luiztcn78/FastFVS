import 'package:flutter/material.dart';
import 'package:fastfvs_front/view/pages/pagina_historico_fvs.dart';

class PopUpStatusFvs extends StatefulWidget {
  final String nomeFvs;
  final Function (Color) statusSelecionado;

  const PopUpStatusFvs({required this.statusSelecionado, required this.nomeFvs, super.key});

  @override
  State<PopUpStatusFvs> createState() => PopUpStatusFvsState();
}

class PopUpStatusFvsState extends State<PopUpStatusFvs>{

    String clicado = "";

    Icon marcar(String opcao){
      if(clicado == opcao){
        return Icon(Icons.check_box_outlined, size: 30);
      }
      else{
        return Icon(Icons.check_box_outline_blank_outlined, size: 30);
      }
    }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width*0.9,
      height: MediaQuery.of(context).size.height*0.6,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).colorScheme.secondary
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(widget.nomeFvs, style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    color: Theme.of(context).colorScheme.onSecondary)),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text("Concluída", style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: IconButton(
                        onPressed: () => setState(() {
                          clicado = "concluido";
                          widget.statusSelecionado(Colors.green);
                          Navigator.pop(context);
                        }), icon: marcar("concluido")
                      ),
                    )
                  ],
                ),
                
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text("Em processo",style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30,),
                      child: IconButton(
                        onPressed: () => setState(() {
                          clicado = "em processo";
                          widget.statusSelecionado(Colors.yellow);
                          Navigator.pop(context);
                        }), icon: marcar("em processo")
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text("Não iniciada", style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: IconButton(
                        onPressed: () => setState(() {
                          clicado = "nao iniciada";
                          widget.statusSelecionado(Colors.red);
                          Navigator.pop(context);
                        }), icon: marcar("nao iniciada")
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30,),
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
                          builder: (context) => const PaginaHistoricoFVS(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Histórico de Alterações',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              ],
              
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.account_box_rounded, size: 45,),
                Text("Pessoa Pessoa", style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      color: Theme.of(context).colorScheme.onSecondary),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("13/04/2024",style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      Text("21:33", style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSecondary),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}