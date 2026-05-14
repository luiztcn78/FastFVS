import 'package:flutter/material.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fastfvs_front/view/widgets/rodape_acesso.dart';
import 'package:fastfvs_front/view/widgets/botao_input_acesso.dart';

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});

  @override
  State<PaginaCadastro> createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  
  bool _ocultarSenha = true;
  bool _ocultarConfirmarSenha = true;

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyleFilled = ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
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
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
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
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
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
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Informe seu nome';
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          BotaoInputAcesso(
                            label: 'E-mail',
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Informe seu e-mail';
                              if (!value.contains('@')) return 'E-mail inválido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          BotaoInputAcesso(
                            label: 'Senha',
                            controller: _senhaController,
                            obscureText: _ocultarSenha,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Informe uma senha';
                              if (value.length < 6) return 'Mínimo de 6 caracteres';
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _ocultarSenha = !_ocultarSenha),
                              icon: Icon(_ocultarSenha ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                            ),
                          ),
                          const SizedBox(height: 15),

                          BotaoInputAcesso(
                            label: 'Confirmar Senha',
                            obscureText: _ocultarConfirmarSenha,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Confirme sua senha';
                              if (value != _senhaController.text) return 'As senhas não coincidem';
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _ocultarConfirmarSenha = !_ocultarConfirmarSenha),
                              icon: Icon(_ocultarConfirmarSenha ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                            ),
                          ),
                          
                          const SizedBox(height: 20),

                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                 
                                }
                              },
                              style: buttonStyleFilled,
                              child: const Text('Cadastrar', style: TextStyle(fontSize: 14)),
                            ),
                          ),

                          const SizedBox(height: 20),
                
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const FaIcon(FontAwesomeIcons.google, size: 20),
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