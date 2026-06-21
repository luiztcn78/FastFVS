import 'package:flutter/material.dart';
import 'package:fastfvs_front/services/fvs_service.dart';
import 'package:fastfvs_front/services/sessao_usuario.dart';

class PopupFvsPadroes extends StatefulWidget {
  final int subsecaoId;
  final int obraId;
  final VoidCallback onFechar;
  final VoidCallback? onSucesso;

  const PopupFvsPadroes({
    super.key,
    required this.subsecaoId,
    required this.obraId,
    required this.onFechar,
    this.onSucesso,
  });

  @override
  State<PopupFvsPadroes> createState() => _PopupFvsPadroesState();
}

class _PopupFvsPadroesState extends State<PopupFvsPadroes> {
  final FvsService fvsService = FvsService();

  Map<String, bool> _fvsLista = {};
  bool _carregandoLista = true;
  bool _salvando = false;
  bool _adicionarEmTodasSubsecoes = false;

  @override
  void initState() {
    super.initState();
    _carregarPadroes();
  }

  Future<void> _carregarPadroes() async {
    try {
      final nomes = await fvsService.listarFvsPadroes();
      if (!mounted) return;
      setState(() {
        _fvsLista = {for (var nome in nomes) nome: false};
        _carregandoLista = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _carregandoLista = false);
    }
  }

  Future<void> _confirmar() async {
    final selecionadas = _fvsLista.entries.where((e) => e.value).map((e) => e.key).toList();
    if (selecionadas.isEmpty) {
      widget.onFechar();
      return;
    }

    setState(() => _salvando = true);

    try {
      final usuarioId = SessaoUsuario.usuario!.id;

      for (final titulo in selecionadas) {
        await fvsService.criarFVS(
          titulo: titulo,
          usuarioId: usuarioId,
          subsecaoId: _adicionarEmTodasSubsecoes ? null : widget.subsecaoId,
          obraId: _adicionarEmTodasSubsecoes ? widget.obraId : null,
          aplicarEmTodas: _adicionarEmTodasSubsecoes,
        );
      }

      widget.onSucesso?.call();
      widget.onFechar();
    } catch (e) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final corFundo = isDark ? colorScheme.primary : Colors.white;
    final corElementos = colorScheme.onSecondary;
    final corCheck = isDark ? colorScheme.primary : Colors.white;

    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onFechar,
          child: Container(color: Colors.black26),
        ),
        Positioned(
          top: 60,
          left: largura * 0.05,
          right: largura * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.1,
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: corFundo, borderRadius: BorderRadius.circular(16)),
              child: _carregandoLista
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Definir FVS",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: corElementos)),
                        const SizedBox(height: 12),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              children: _fvsLista.keys.map((String chave) {
                                return _linhaFvs(corElementos, corCheck, chave, _fvsLista[chave]!,
                                  (v) => setState(() => _fvsLista[chave] = v!));
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _adicionarEmTodasSubsecoes,
                              onChanged: (v) => setState(() => _adicionarEmTodasSubsecoes = v!),
                              activeColor: corElementos,
                              checkColor: corCheck,
                            ),
                            Text("Adicionar em todas\nas Subseções",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: corElementos, decoration: TextDecoration.underline)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _salvando ? null : _confirmar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: _salvando
                                  ? const SizedBox(width: 16, height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Text("Confirmar", style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              onPressed: _salvando ? null : widget.onFechar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text("Cancelar", style: TextStyle(color: Colors.white)),
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

  Widget _linhaFvs(Color corAtiva, Color corCheck, String texto, bool valor, Function(bool?) onChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(texto, style: TextStyle(color: corAtiva)),
        Checkbox(value: valor, onChanged: onChange, activeColor: corAtiva, checkColor: corCheck),
      ],
    );
  }
}