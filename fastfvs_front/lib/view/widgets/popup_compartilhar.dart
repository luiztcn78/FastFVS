import 'package:flutter/material.dart';
import 'package:fastfvs_front/services/membro_service.dart';

class PopupCompartilhar extends StatefulWidget {
  final int obraId;
  final VoidCallback onFechar;

  const PopupCompartilhar({
    super.key,
    required this.obraId,
    required this.onFechar,
  });

  @override
  State<PopupCompartilhar> createState() => _PopupCompartilharState();
}

class _PopupCompartilharState extends State<PopupCompartilhar> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final MembroService _membroService = MembroService();

  bool _salvando = false;
  String _erro = '';
  bool _sucesso = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _salvando = true;
      _erro = '';
      _sucesso = false;
    });

    try {
      await _membroService.adicionarMembroPorEmail(
        obraId: widget.obraId,
        email: _emailController.text.trim(),
        role: 'PADRAO',
      );
      if (!mounted) return;
      setState(() {
        _sucesso = true;
        _salvando = false;
        _emailController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.toString().replaceAll('Exception: ', '');
        _salvando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final cor = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cor.primary, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: largura * 0.08, vertical: 28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adicionar Membro',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: cor.onSecondary,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'E-mail do usuário:',
                style: TextStyle(color: cor.onSecondary, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'exemplo@email.com',
                  hintStyle: TextStyle(color: cor.onSecondary.withOpacity(0.4)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: cor.primary.withOpacity(0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: cor.primary, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o e-mail';
                  if (!value.contains('@')) return 'E-mail inválido';
                  return null;
                },
              ),

              if (_erro.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  _erro,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ],

              if (_sucesso) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Membro adicionado com sucesso!',
                      style: TextStyle(color: Colors.green.shade700, fontSize: 13),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _salvando ? null : widget.onFechar,
                    child: Text(
                      'Fechar',
                      style: TextStyle(color: cor.onSecondary.withOpacity(0.6)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _salvando ? null : _confirmar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: _salvando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            'Confirmar',
                            style: TextStyle(color: cor.onPrimary),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}