import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:fastfvs_front/models/usuario.dart';
import 'package:fastfvs_front/services/sessao_usuario.dart';
import 'package:fastfvs_front/services/usuario_service.dart';
import 'package:fastfvs_front/utils/foto_perfil_utils.dart'; // Import adicionado
import 'package:flutter/material.dart';

class PaginaPerfil extends StatefulWidget {
  const PaginaPerfil({super.key});

  @override
  State<PaginaPerfil> createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> {
  final UsuarioService _usuarioService = UsuarioService();
  bool _senhaVisivel = false;
  bool _salvando = false;

  late String nome;
  late String email;

  @override
  void initState() {
    super.initState();
    final usuario = SessaoUsuario.usuario;
    nome = usuario?.nome ?? '';
    email = usuario?.email ?? '';
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  // Método _buildFotoPerfil removido

  Future<void> _editarFoto() async {
    final usuario = SessaoUsuario.usuario;
    if (usuario == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );

    if (imagem == null) return;

    setState(() => _salvando = true);
    try {
      final Uint8List bytes = await imagem.readAsBytes();
      final String base64Foto = base64Encode(bytes);

      await _usuarioService.atualizarFoto(usuario.id, base64Foto);

      SessaoUsuario.iniciar(
        Usuario(
          id: usuario.id,
          nome: usuario.nome,
          email: usuario.email,
          fotoPerfil: base64Foto,
        ),
      );
      setState(() {});
    } catch (e) {
      _mostrarErro(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _salvarNome(String novoNome) async {
    final usuario = SessaoUsuario.usuario;
    if (usuario == null || novoNome.trim().isEmpty) return;

    setState(() => _salvando = true);
    try {
      await _usuarioService.atualizarDados(usuario.id, novoNome.trim(), email);
      SessaoUsuario.iniciar(
        Usuario(
          id: usuario.id,
          nome: novoNome.trim(),
          email: email,
          fotoPerfil: usuario.fotoPerfil,
        ),
      );
      setState(() => nome = novoNome.trim());
    } catch (e) {
      _mostrarErro(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _salvarEmail(String novoEmail) async {
    final usuario = SessaoUsuario.usuario;
    if (usuario == null || novoEmail.trim().isEmpty) return;

    setState(() => _salvando = true);
    try {
      await _usuarioService.atualizarDados(usuario.id, nome, novoEmail.trim());
      SessaoUsuario.iniciar(
        Usuario(
          id: usuario.id,
          nome: nome,
          email: novoEmail.trim(),
          fotoPerfil: usuario.fotoPerfil,
        ),
      );
      setState(() => email = novoEmail.trim());
    } catch (e) {
      _mostrarErro(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _salvarSenha(
    String senhaAtual,
    String novaSenha,
    String confirmarSenha,
  ) async {
    final usuario = SessaoUsuario.usuario;
    if (usuario == null) return;

    if (novaSenha != confirmarSenha) {
      _mostrarErro('As senhas não correspondem.');
      return;
    }
    if (novaSenha.isEmpty) {
      _mostrarErro('A nova senha não pode ficar em branco.');
      return;
    }

    setState(() => _salvando = true);
    try {
      await _usuarioService.atualizarSenha(usuario.id, senhaAtual, novaSenha);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha atualizada com sucesso.')),
        );
      }
    } catch (e) {
      _mostrarErro(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      onTap: _salvando ? null : _editarFoto,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 4),
                          Text('Editar foto'),
                        ],
                      ),
                    ),
                  ),
                ),
                // CircleAvatar atualizado com função compartilhada
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFE0D7F5),
                  backgroundImage: construirImagemPerfil(
                    SessaoUsuario.usuario?.fotoPerfil,
                  ),
                  child:
                      construirImagemPerfil(
                            SessaoUsuario.usuario?.fotoPerfil,
                          ) ==
                          null
                      ? Icon(
                          Icons.person_outline,
                          size: 60,
                          color: Theme.of(context).colorScheme.onSecondary,
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  'Olá, $nome!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nome:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: nome),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onTap: _salvando
                        ? null
                        : () {
                            final controller = TextEditingController(
                              text: nome,
                            );
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Center(child: Text('Editar Nome')),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Nome:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                          _salvarNome(controller.text);
                                        },
                                        child: const Text(
                                          'Confirmar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(dialogContext).pop(),
                                        child: const Text(
                                          'Cancelar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Email:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: email),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onTap: _salvando
                        ? null
                        : () {
                            final controller = TextEditingController(
                              text: email,
                            );
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Center(
                                  child: Text('Editar Email'),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Email:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                          _salvarEmail(controller.text);
                                        },
                                        child: const Text(
                                          'Confirmar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(dialogContext).pop(),
                                        child: const Text(
                                          'Cancelar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Senha:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    readOnly: true,
                    obscureText: !_senhaVisivel,
                    controller: TextEditingController(text: '••••••••'),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _senhaVisivel
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () =>
                            setState(() => _senhaVisivel = !_senhaVisivel),
                      ),
                    ),
                    onTap: _salvando
                        ? null
                        : () {
                            final senhaAtualController =
                                TextEditingController();
                            final novaSenhaController = TextEditingController();
                            final confirmarSenhaController =
                                TextEditingController();
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Center(
                                  child: Text('Editar Senha'),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Senha atual:'),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: senhaAtualController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text('Nova senha:'),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: novaSenhaController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text('Confirmar senha:'),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: confirmarSenhaController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                          _salvarSenha(
                                            senhaAtualController.text,
                                            novaSenhaController.text,
                                            confirmarSenhaController.text,
                                          );
                                        },
                                        child: const Text(
                                          'Confirmar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(dialogContext).pop(),
                                        child: const Text(
                                          'Cancelar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xFF3C1E01),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
