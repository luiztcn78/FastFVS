import 'package:flutter/material.dart';

class PopupEditarObra extends StatelessWidget {
  final TextEditingController nomeController;
  final VoidCallback onFechar;

  const PopupEditarObra({
    super.key,
    required this.nomeController,
    required this.onFechar,
  });

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final cor = Theme.of(context).colorScheme;

    return Stack(
      children: [
        GestureDetector(
          onTap: onFechar,
          child: Container(color: Colors.black26),
        ),
        Positioned(
          top: 150,
          left: largura * 0.05,
          right: largura * 0.05,
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Editar Obra",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cor.primary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text("Nome:", style: TextStyle(color: cor.primary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: cor.primary),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: onFechar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Confirmar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: onFechar,
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text(
                          "Deletar obra",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
