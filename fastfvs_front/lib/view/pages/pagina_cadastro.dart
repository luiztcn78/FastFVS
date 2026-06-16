import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fastfvs_front/view/widgets/rodape_acesso.dart';
import 'package:fastfvs_front/view/widgets/botao_input_acesso.dart';

import 'package:fastfvs_front/services/auth_service.dart';
import 'package:fastfvs_front/services/sessao_usuario.dart';

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});

  @override
  State<PaginaCadastro> createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _authService = AuthService();

  bool _ocultarSenha = true;
  bool _ocultarConfirmarSenha = true;
  bool _carregando = false;
  bool _erroCadastro = false;
  String _mensagemErro = '';

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
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
                      color: Theme.of(context).colorScheme.primary,
                      shadows: [
                        Shadow(
                          offset: const Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                        ),
                      ],
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
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
                            'Cadastro',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          BotaoInputAcesso(
                            label: 'Nome',
                            controller: _nomeController,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Informe seu nome';
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          BotaoInputAcesso(
                            label: 'E-mail',
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Informe seu e-mail';
                              if (!value.contains('@'))
                                return 'E-mail inválido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          BotaoInputAcesso(
                            label: 'Senha',
                            controller: _senhaController,
                            obscureText: _ocultarSenha,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Informe uma senha';
                              if (value.length < 8)
                                return 'Mínimo de 8 caracteres';
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _ocultarSenha = !_ocultarSenha,
                              ),
                              icon: Icon(
                                _ocultarSenha
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          BotaoInputAcesso(
                            label: 'Confirmar Senha',
                            controller: _confirmarSenhaController,
                            obscureText: _ocultarConfirmarSenha,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Confirme sua senha';
                              if (value != _senhaController.text)
                                return 'As senhas não coincidem';
                              if (value.length < 8)
                                return 'Mínimo de 8 caracteres';
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _ocultarConfirmarSenha =
                                    !_ocultarConfirmarSenha,
                              ),
                              icon: Icon(
                                _ocultarConfirmarSenha
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),

                          if (_erroCadastro) ...[
                            const SizedBox(height: 8),
                            Text(
                              _mensagemErro,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: _carregando
                                  ? null
                                  : () async {
                                      setState(() {
                                        _erroCadastro = false;
                                        _mensagemErro = '';
                                      });

                                      if (!_formKey.currentState!.validate())
                                        return;

                                      setState(() => _carregando = true);

                                      try {
                                        final usuario = await _authService
                                            .register(
                                              nome: _nomeController.text.trim(),
                                              email: _emailController.text
                                                  .trim(),
                                              senha: _senhaController.text,
                                            );
                                        SessaoUsuario.iniciar(usuario);
                                        if (mounted) {
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/minhasObras',
                                            (route) => false,
                                          );
                                        }
                                      } catch (e) {
                                        setState(() {
                                          _erroCadastro = true;
                                          _mensagemErro = e
                                              .toString()
                                              .replaceAll('Exception: ', '');
                                        });
                                      } finally {
                                        if (mounted)
                                          setState(() => _carregando = false);
                                      }
                                    },
                              style: buttonStyleFilled,
                              child: _carregando
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Cadastrar',
                                      style: TextStyle(fontSize: 14),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const FaIcon(
                                FontAwesomeIcons.google,
                                size: 20,
                              ),
                              label: const Text('Entrar com Google'),
                              style: buttonStyleFilled,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const RodapeAcesso(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
