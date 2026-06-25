import 'package:flutter/material.dart';
import 'package:fastfvs_front/view/pages/pagina_redefinir_senha.dart';
import 'package:fastfvs_front/view/widgets/rodape_acesso.dart';
import 'package:fastfvs_front/view/widgets/botao_input_acesso.dart';
import 'package:fastfvs_front/services/auth_service.dart';

class PaginaCodigoVerificacao extends StatefulWidget {
  final String email; // recebe o e-mail da tela anterior

  const PaginaCodigoVerificacao({required this.email, super.key});

  @override
  State<PaginaCodigoVerificacao> createState() => _PaginaCodigoVerificacaoState();
}

class _PaginaCodigoVerificacaoState extends State<PaginaCodigoVerificacao> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;
  String _mensagemErro = '';

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyleFilled = ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Image.asset('assets/images/logo_fastfvs.png', width: 120),
                  const SizedBox(height: 10),
                  Text(
                    'Sistema de Gestão de FVS',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Código de Verificação',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Digite o código enviado para ${widget.email}.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 25),
                          BotaoInputAcesso(
                            label: 'Código',
                            hintText: 'XXXXXX',
                            controller: _codigoController,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Informe o código';
                              if (value.length < 6) return 'O código deve ter 6 dígitos';
                              return null;
                            },
                          ),
                          if (_mensagemErro.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              _mensagemErro,
                              style: const TextStyle(color: Colors.red, fontSize: 13),
                            ),
                          ],
                          const SizedBox(height: 25),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: _carregando
                                  ? null
                                  : () async {
                                      setState(() => _mensagemErro = '');
                                      if (!_formKey.currentState!.validate()) return;
                                      setState(() => _carregando = true);
                                      try {
                                        final valido = await _authService.validarToken(
                                          widget.email,
                                          _codigoController.text.trim(),
                                        );
                                        if (!mounted) return;
                                        if (valido) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PaginaRedefinirSenha(
                                                email: widget.email,
                                                token: _codigoController.text.trim(),
                                              ),
                                            ),
                                          );
                                        } else {
                                          setState(() => _mensagemErro = 'Código inválido ou expirado.');
                                        }
                                      } catch (e) {
                                        setState(() {
                                          _mensagemErro = e.toString().replaceAll('Exception: ', '');
                                        });
                                      } finally {
                                        if (mounted) setState(() => _carregando = false);
                                      }
                                    },
                              style: buttonStyleFilled,
                              child: _carregando
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Confirmar', style: TextStyle(fontSize: 14, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: RodapeAcesso(),
          ),
        ],
      ),
    );
  }
}