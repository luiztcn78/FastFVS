import 'package:flutter/material.dart';

class PaginaLerQrcode extends StatelessWidget {
  const PaginaLerQrcode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Center(
        child: Container(
          width: 400,
          height: 550,
          color: const Color.fromARGB(255, 0, 0, 0),
          child: const Center(
            child: const Text(
              "Ler QR Code",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
