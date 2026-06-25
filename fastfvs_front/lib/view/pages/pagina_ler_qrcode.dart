import 'package:fastfvs_front/models/obra.dart';
import 'package:fastfvs_front/services/obra_service.dart';
import 'package:fastfvs_front/services/sessao_usuario.dart';
import 'package:fastfvs_front/services/subsecao_service.dart';
import 'package:fastfvs_front/models/dados_particao.dart';
import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/pages/pagina_obra.dart';
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
  bool _processando = false;

  final ObraService _obraService = ObraService();

  // Extrai o tipo e o ID do link
  // Ex: http://192.168.1.7:8080/obra/18 → ('obra', 18)
  // Ex: http://192.168.1.7:8080/subsecao/5 → ('subsecao', 5)
  ({String tipo, int id})? _extrairDoLink(String url) {
    try {
      final uri = Uri.parse(url);
      final segmentos = uri.pathSegments;
      // segmentos = ['obra', '18'] ou ['subsecao', '5']
      if (segmentos.length >= 2) {
        final tipo = segmentos[segmentos.length - 2]; // 'obra' ou 'subsecao'
        final id = int.tryParse(segmentos.last);
        if (id != null && (tipo == 'obra' || tipo == 'subsecao')) {
          return (tipo: tipo, id: id);
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> _processarCodigo(String codigo) async {
    if (_processando) return;
    setState(() {
      _processando = true;
      codigoLido = codigo;
    });

    final extraido = _extrairDoLink(codigo);

    if (extraido == null) {
      // Não é um link do FastFVS, só mostra o código
      setState(() => _processando = false);
      return;
    }

    try {
      if (extraido.tipo == 'obra') {
        final obra = await _obraService.getObra(extraido.id);
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PaginaObra(obra: obra)),
        ).then((_) => setState(() {
          codigoLido = null;
          _processando = false;
        }));
      } else if (extraido.tipo == 'subsecao') {
        // Busca a subseção, a obra pai e os dados de conformidade
        // para abrir diretamente na página da subseção específica
        final subsecaoService = SubsecaoService();
        final subsecao = await subsecaoService.buscarSubsecao(extraido.id);
        final obra = await _obraService.getObra(subsecao.obraId);
        final conformidade = await subsecaoService.getConformidade(subsecao.id);
        final dadosParticao = await subsecaoService.statusPresentesNasubsecao(
          subsecao.id,
          subsecao.nome,
          conformidade,
        );
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaginaObra(obra: obra, subsecaoInicial: dadosParticao),
          ),
        ).then((_) => setState(() {
          codigoLido = null;
          _processando = false;
        }));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        codigoLido = null;
        _processando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar: ${e.toString().replaceAll('Exception: ', '')}')),
      );
    }
  }

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
                    Icon(Icons.smartphone, size: 80, color: cor.onSecondary),
                    const SizedBox(height: 24),
                    Text(
                      "Leitura de QR Code",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cor.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Esta funcionalidade está disponível apenas no aplicativo mobile.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: cor.onSecondary),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: _processando
                      ? const Center(child: CircularProgressIndicator())
                      : MobileScanner(
                          onDetect: (capture) {
                            final codigo = capture.barcodes.first.rawValue;
                            if (codigo != null && codigoLido == null) {
                              _processarCodigo(codigo);
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
                            : _processando
                                ? "Carregando..."
                                : "Código não reconhecido",
                        style: TextStyle(color: cor.onPrimary, fontSize: 16),
                      ),
                      if (codigoLido != null && !_processando) ...[
                        const SizedBox(height: 8),
                        Text(
                          codigoLido!,
                          style: TextStyle(
                            color: cor.onPrimary,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => setState(() {
                            codigoLido = null;
                            _processando = false;
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cor.onPrimary,
                          ),
                          child: Text(
                            "Ler outro",
                            style: TextStyle(color: cor.onSecondary),
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