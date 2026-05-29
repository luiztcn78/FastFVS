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

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding:  EdgeInsetsGeometry.only(
            top: 50,
            left: largura * 0.1,
            right: largura * 0.1,
            bottom: 25,
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

                const SizedBox(height: 25),
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
      ],
      )
    );
  }
}
