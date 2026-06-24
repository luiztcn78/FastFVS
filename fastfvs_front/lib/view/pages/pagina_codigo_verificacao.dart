import 'package:flutter/material.dart';
import 'package:fastfvs_front/view/pages/pagina_redefinir_senha.dart'; 
import 'package:fastfvs_front/view/widgets/rodape_acesso.dart';
import 'package:fastfvs_front/view/widgets/botao_input_acesso.dart';

class PaginaCodigoVerificacao extends StatefulWidget {
  const PaginaCodigoVerificacao({super.key});

  @override
  State<PaginaCodigoVerificacao> createState() => _PaginaCodigoVerificacaoState();
}

class _PaginaCodigoVerificacaoState extends State<PaginaCodigoVerificacao> {
  final _formKey = GlobalKey<FormState>();

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
                        color: Theme.of(context).colorScheme.onSecondary,
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
                          )
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
                              'Digite o código que enviamos para o seu email.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 25),

                            BotaoInputAcesso(
                              label: 'Código',
                              hintText: 'XXXXXX',
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Informe o código';
                                if (value.length < 6) return 'O código deve ter 6 dígitos';
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 25),

                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const PaginaRedefinirSenha()),
                                    );
                                  }
                                },
                                style: buttonStyleFilled,
                                child: const Text('Confirmar', style: TextStyle(fontSize: 14, color: Colors.white)),
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