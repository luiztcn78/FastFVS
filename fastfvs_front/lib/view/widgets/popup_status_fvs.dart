import 'package:flutter/material.dart';
import 'package:fastfvs_front/view/pages/pagina_historico_fvs.dart';

class PopUpStatusFvs extends StatefulWidget {
  final String nomeFvs;
  final Function(Color) statusSelecionado;

  const PopUpStatusFvs({required this.statusSelecionado, required this.nomeFvs, super.key});

  @override
  State<PopUpStatusFvs> createState() => PopUpStatusFvsState();
}

class PopUpStatusFvsState extends State<PopUpStatusFvs> {
  String clicado = "";

  Icon marcar(String opcao) {
    if (clicado == opcao) {
      return const Icon(Icons.check_box_outlined, size: 30);
    } else {
      return const Icon(Icons.check_box_outline_blank_outlined, size: 30);
    }
  }

  void _mostrarDialogoDeletar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        bool deletarEmTodasSubsecoes = false;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Deletar FVS',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: deletarEmTodasSubsecoes,
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (v) {
                          setStateDialog(() {
                            deletarEmTodasSubsecoes = v ?? false;
                          });
                        },
                      ),
                      Text(
                        "Deletar FVS de todas\nas subseções",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    // Lógica para deletar a FVS entra aqui (integração futura)
                    // Você pode acessar a variável `deletarEmTodasSubsecoes`
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff84E08F),
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    fixedSize: const Size(120, 40),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                  child: const Text('Confirmar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(110, 40),
                    backgroundColor: const Color(0xffFF6D6D),
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.nomeFvs,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                      ),
                      // Ícone de lixeira adicionado aqui
                      IconButton(
                        onPressed: () => _mostrarDialogoDeletar(context),
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 28),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        "Concluída",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: IconButton(
                        onPressed: () => setState(() {
                          clicado = "concluido";
                          widget.statusSelecionado(Colors.green);
                          Navigator.pop(context);
                        }),
                        icon: marcar("concluido"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        "Em processo",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: IconButton(
                        onPressed: () => setState(() {
                          clicado = "em processo";
                          widget.statusSelecionado(Colors.yellow);
                          Navigator.pop(context);
                        }),
                        icon: marcar("em processo"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        "Não iniciada",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: IconButton(
                        onPressed: () => setState(() {
                          clicado = "nao iniciada";
                          widget.statusSelecionado(Colors.red);
                          Navigator.pop(context);
                        }),
                        icon: marcar("nao iniciada"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
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
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.account_box_rounded, size: 45),
                Text(
                  "Pessoa Pessoa",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "13/04/2024",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                      Text(
                        "21:33",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}