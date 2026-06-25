import 'package:flutter/material.dart';
import 'package:fastfvs_front/view/widgets/rodape_acesso.dart';
import 'package:fastfvs_front/view/widgets/botao_input_acesso.dart';
import 'package:fastfvs_front/view/pages/pagina_codigo_verificacao.dart';
import 'package:fastfvs_front/services/auth_service.dart';

class PaginaRecuperarSenha extends StatefulWidget {
  const PaginaRecuperarSenha({super.key});

  @override
  State<PaginaRecuperarSenha> createState() => _PaginaRecuperarSenhaState();
}

class _PaginaRecuperarSenhaState extends State<PaginaRecuperarSenha> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;
  String _mensagemErro = '';

  @override
  void dispose() {
    _emailController.dispose();
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
                            'Recuperar Senha',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Informe o email cadastrado na sua conta e lhe enviaremos um código de verificação.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 25),
                          BotaoInputAcesso(
                            label: 'E-mail',
                            hintText: 'exemplo@email.com',
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Informe o e-mail cadastrado';
                              if (!value.contains('@')) return 'E-mail inválido';
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
                                        await _authService.solicitarReset(
                                          _emailController.text.trim(),
                                        );
                                        if (!mounted) return;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaginaCodigoVerificacao(
                                              email: _emailController.text.trim(),
                                            ),
                                          ),
                                        );
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
                                  : const Text('Enviar', style: TextStyle(fontSize: 14, color: Colors.white)),
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