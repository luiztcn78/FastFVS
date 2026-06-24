import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fastfvs_front/view/widgets/rodape_acesso.dart';
import 'package:fastfvs_front/view/pages/pagina_cadastro.dart';
import 'package:fastfvs_front/view/widgets/botao_input_acesso.dart';
import 'package:fastfvs_front/view/pages/pagina_recuperar_senha.dart';

// Adicionados conforme instrução
import 'package:fastfvs_front/services/auth_service.dart';
import 'package:fastfvs_front/services/sessao_usuario.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final _formKey = GlobalKey<FormState>();

  // Adicionados conforme instrução
  final _authService = AuthService();
  bool _carregando = false;

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _ocultarSenha = true;
  bool _erroLogin = false;
  String _mensagemErro = '';

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyleFilled = ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.symmetric(vertical: 14),
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
                      shadows: [
                        Shadow(
                          offset: const Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondary.withOpacity(0.3),
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
                            'Login',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 25),

                          BotaoInputAcesso(
                            label: 'E-mail',
                            hintText: 'exemplo@email.com',
                            controller: _emailController,
                            validator: (value) {
                              if (_erroLogin) return '';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          BotaoInputAcesso(
                            label: 'Senha',
                            obscureText: _ocultarSenha,
                            hintText: 'Digite sua senha',
                            controller: _senhaController,
                            validator: (value) {
                              if (_erroLogin) return '';
                              return null;
                            },
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: IconButton(
                                onPressed: () {
                                  setState(
                                    () => _ocultarSenha = !_ocultarSenha,
                                  );
                                },
                                icon: Icon(
                                  _ocultarSenha
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          if (_erroLogin) ...[
                            const SizedBox(height: 5),
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PaginaRecuperarSenha(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Esqueci minha senha',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                // Atualizado conforme instrução
                                onPressed: _carregando
                                    ? null
                                    : () async {
                                        setState(() {
                                          _erroLogin = false;
                                          _mensagemErro = '';
                                        });

                                        if (_emailController.text.isEmpty ||
                                            _senhaController.text.isEmpty) {
                                          setState(() {
                                            _erroLogin = true;
                                            _mensagemErro =
                                                'Um ou mais campos estão nulos/vazios.';
                                          });
                                          _formKey.currentState!.validate();
                                          return;
                                        }

                                        if (!_emailController.text.contains(
                                          '@',
                                        )) {
                                          setState(() {
                                            _erroLogin = true;
                                            _mensagemErro = 'E-mail inválido.';
                                          });
                                          _formKey.currentState!.validate();
                                          return;
                                        }

                                        setState(() => _carregando = true);

                                        try {
                                          final usuario = await _authService
                                              .login(
                                                _emailController.text.trim(),
                                                _senhaController.text,
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
                                            _erroLogin = true;
                                            _mensagemErro = e
                                                .toString()
                                                .replaceAll('Exception: ', '');
                                          });
                                          _formKey.currentState!.validate();
                                        } finally {
                                          if (mounted)
                                            setState(() => _carregando = false);
                                        }
                                      },
                                style: buttonStyleFilled,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  // Atualizado conforme instrução
                                  child: _carregando
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Entrar',
                                          style: TextStyle(fontSize: 13, color: Colors.white),
                                        ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 2),
                          Center(
                            child: Text(
                              "ou",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          //const SizedBox(height: 20),

                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "Não tem conta?",
                                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary),
                                ),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PaginaCadastro(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Criar Conta",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
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
