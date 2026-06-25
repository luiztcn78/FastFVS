import 'dart:convert';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show AnchorElement, Url, Blob;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fastfvs_front/models/compartilhamento_dto.dart';
import 'package:fastfvs_front/view/pages/pagina_base.dart';

class PaginaQrCode extends StatefulWidget {
  // null = QR Code da obra, não-null = QR Code da subseção
  final Future<CompartilhamentoDTO> Function() carregarQrCode;
  final String titulo;

  const PaginaQrCode({
    required this.carregarQrCode,
    required this.titulo,
    super.key,
  });

  @override
  State<PaginaQrCode> createState() => _PaginaQrCodeState();
}

class _PaginaQrCodeState extends State<PaginaQrCode> {
  CompartilhamentoDTO? _dados;
  bool _carregando = true;
  String _erro = '';

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      final dados = await widget.carregarQrCode();
      if (!mounted) return;
      setState(() {
        _dados = dados;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.toString().replaceAll('Exception: ', '');
        _carregando = false;
      });
    }
  }

  // Converte o base64 em bytes para exibir e baixar
  Uint8List _decodarBase64(String base64String) {
    // Remove prefixo "data:image/png;base64," se vier com ele
    final limpo = base64String.contains(',')
        ? base64String.split(',').last
        : base64String;
    return base64Decode(limpo);
  }

  void _baixar(Uint8List bytes) {
  if (kIsWeb) {
    // No web usa dart:html para forçar download
    final blob = html.Blob([bytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);
      
    html.AnchorElement(href: url)
      ..setAttribute('download', 'qrcode_${widget.titulo}.png')
      ..click();
        
    html.Url.revokeObjectUrl(url);
  } else {
    // No mobile mostra snackbar orientando salvar pela imagem longa
    // Para salvar de verdade no mobile adicione o pacote image_gallery_saver
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pressione e segure a imagem para salvá-la.')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme;

    return PaginaBase(
      paginaAberta: 0,
      body: Column(
        children: [
          // Cabeçalho com o nome
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2, color: cor.primary),
              ),
            ),
            child: Text(
              widget.titulo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 26,
                    color: cor.onSecondary,
                  ),
            ),
          ),

          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _erro.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Erro ao carregar QR Code:\n$_erro',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Link clicável
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            child: Text(
                              _dados!.link,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: cor.primary,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Imagem do QR Code em base64
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Image.memory(
                              _decodarBase64(_dados!.qrcode),
                              width: 280,
                              height: 280,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Botão de download
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 50),
                              backgroundColor: cor.primary,
                            ),
                            onPressed: () => _baixar(_decodarBase64(_dados!.qrcode)),
                            icon: Icon(Icons.download, color: cor.onPrimary),
                            label: Text(
                              'Baixar',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontSize: 20,
                                    color: cor.onPrimary,
                                  ),
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