import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PaginaLerQrcode extends StatefulWidget {
  const PaginaLerQrcode({super.key});

  @override
  State<PaginaLerQrcode> createState() => _PaginaLerQrcodeState();
}

class _PaginaLerQrcodeState extends State<PaginaLerQrcode> {
  String? codigoLido;

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme;

    return PaginaBase(
      paginaAberta: 1,
      body: kIsWeb
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.smartphone, size: 80, color: cor.primary),
                    const SizedBox(height: 24),
                    Text(
                      "Leitura de QR Code",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cor.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Esta funcionalidade está disponível apenas no aplicativo mobile.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: cor.primary),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: MobileScanner(
                    onDetect: (capture) {
                      final codigo = capture.barcodes.first.rawValue;
                      if (codigo != null && codigoLido == null) {
                        setState(() {
                          codigoLido = codigo;
                        });
                      }
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: cor.primary,
                  child: Column(
                    children: [
                      Text(
                        codigoLido == null
                            ? "Aponte a câmera para um QR Code"
                            : "Código lido:",
                        style: TextStyle(color: cor.onPrimary, fontSize: 16),
                      ),
                      if (codigoLido != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          codigoLido!,
                          style: TextStyle(
                            color: cor.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              codigoLido = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cor.onPrimary,
                          ),
                          child: Text(
                            "Ler outro",
                            style: TextStyle(color: cor.primary),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
