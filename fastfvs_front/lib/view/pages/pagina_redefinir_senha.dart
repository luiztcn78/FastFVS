import 'package:flutter/material.dart';
import 'package:fastfvs_front/view/pages/pagina_login.dart';
import 'package:fastfvs_front/view/widgets/rodape_acesso.dart';
import 'package:fastfvs_front/view/widgets/botao_input_acesso.dart';
import 'package:fastfvs_front/services/auth_service.dart';

class PaginaRedefinirSenha extends StatefulWidget {
  final String email;
  final String token;

  const PaginaRedefinirSenha({required this.email, required this.token, super.key});

  @override
  State<PaginaRedefinirSenha> createState() => _PaginaRedefinirSenhaState();
}

class _PaginaRedefinirSenhaState extends State<PaginaRedefinirSenha> {
  final _formKey = GlobalKey<FormState>();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _authService = AuthService();
  bool _ocultarSenha = true;
  bool _ocultarConfirmarSenha = true;
  bool _carregando = false;
  String _mensagemErro = '';

  @override
  void dispose() {
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
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
                            'Redefinir Senha',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          BotaoInputAcesso(
                            label: 'Nova Senha',
                            controller: _novaSenhaController,
                            obscureText: _ocultarSenha,
                            hintText: '********',
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Informe a nova senha';
                              if (value.length < 6) return 'Mínimo de 6 caracteres';
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _ocultarSenha = !_ocultarSenha),
                              icon: Icon(
                                _ocultarSenha ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          BotaoInputAcesso(
                            label: 'Confirmar Nova Senha',
                            controller: _confirmarSenhaController,
                            obscureText: _ocultarConfirmarSenha,
                            hintText: '********',
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Confirme a nova senha';
                              if (value != _novaSenhaController.text) return 'As senhas não coincidem';
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _ocultarConfirmarSenha = !_ocultarConfirmarSenha),
                              icon: Icon(
                                _ocultarConfirmarSenha ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
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
                                        await _authService.redefinirSenha(
                                          email: widget.email,
                                          token: widget.token,
                                          novaSenha: _novaSenhaController.text,
                                        );
                                        if (!mounted) return;
                                        // Volta pro login limpando toda a pilha de navegação
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/login',
                                          (route) => false,
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