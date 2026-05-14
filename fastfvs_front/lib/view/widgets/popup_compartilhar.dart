import 'package:flutter/material.dart';

class PopupCompartilhar extends StatefulWidget {
  final VoidCallback onFechar;

  const PopupCompartilhar({super.key, required this.onFechar});

  @override
  State<PopupCompartilhar> createState() => _PopupCompartilharState();
}

class _PopupCompartilharState extends State<PopupCompartilhar> {
  bool _permVisualizar = false;
  bool _permEditar = false;

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final cor = Theme.of(context).colorScheme;

    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onFechar,
          child: Container(color: Colors.black26),
        ),
        Positioned(
          top: 100,
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
                    "Compartilhar Projeto:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cor.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.link, color: Colors.white),
                      label: const Text(
                        "Copia Link do Projeto",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text("Permissões:", style: TextStyle(color: cor.primary)),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Visualizar", style: TextStyle(color: cor.primary)),
                      Switch(
                        value: _permVisualizar,
                        onChanged: (v) => setState(() => _permVisualizar = v),
                        activeColor: cor.primary,
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Editar", style: TextStyle(color: cor.primary)),
                      Switch(
                        value: _permEditar,
                        onChanged: (v) => setState(() => _permEditar = v),
                        activeColor: cor.primary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: widget.onFechar,
                      child: Icon(Icons.check, color: cor.primary, size: 28),
                    ),
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
