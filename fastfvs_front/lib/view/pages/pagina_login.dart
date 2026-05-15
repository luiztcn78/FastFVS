import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fastfvs_front/view/widgets/rodape_acesso.dart';
import 'package:fastfvs_front/view/pages/pagina_cadastro.dart';
import 'package:fastfvs_front/view/widgets/botao_input_acesso.dart';
import 'package:fastfvs_front/view/pages/pagina_recuperar_senha.dart';


class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final _formKey = GlobalKey<FormState>();
  

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
                                  setState(() => _ocultarSenha = !_ocultarSenha);
                                },
                                icon: Icon(
                                  _ocultarSenha ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey, 
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
                                    MaterialPageRoute(builder: (context) => const PaginaRecuperarSenha()),
                                  );
                                },
                                child: Text(
                                  'Esqueci minha senha',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary, 
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  
                                  setState(() {
                                    _erroLogin = false;
                                    _mensagemErro = '';
                                  });

                                  bool camposVazios = _emailController.text.isEmpty || _senhaController.text.isEmpty;
                                  bool emailInvalido = !_emailController.text.contains('@');

                                  if (camposVazios) {
                                    setState(() {
                                      _erroLogin = true;
                                      _mensagemErro = 'Um ou mais campos estão nulos/vazios.';
                                    });
                                    _formKey.currentState!.validate(); 
                                  } else if (emailInvalido) {
                                    setState(() {
                                      _erroLogin = true;
                                      _mensagemErro = 'E-mail ou senha está incorreto.';
                                    });
                                    _formKey.currentState!.validate(); 
                                  } else {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/minhasObras', // trocar por pagina home lá
                                      (route) => false,
                                    );
                                  }
                                },
                                style: buttonStyleFilled,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text('Entrar', style: TextStyle(fontSize: 13)),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 2),
                          Center(
                            child: Text(
                              "ou", 
                              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14)
                            )
                          ),
                          const SizedBox(height: 10),
                
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const FaIcon(FontAwesomeIcons.google, size: 20),
                              label: const Text('Entrar com Google'),
                              style: buttonStyleFilled,
                            ),
                          ),
                          
                          const SizedBox(height: 20),

                          Center(
                            child: Column(
                              children: [
                                const Text("Não tem conta?", style: TextStyle(fontSize: 14)),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const PaginaCadastro()),
                                    );
                                  },
                                  child: Text(
                                    "Criar Conta",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary, 
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