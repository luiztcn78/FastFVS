import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:fastfvs_front/models/usuario.dart';

class UsuarioService {
  String get _baseUrl {
    if (kIsWeb) {
      return 'http://192.168.1.7:8080/api/usuarios';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api/usuarios';
    } else if (Platform.isIOS) {
      return 'http://localhost:8080/api/usuarios';
    } else {
      return 'http://192.168.3.105:8080/api/usuarios';
    }
  }

  String _extrairMensagemErro(http.Response response, String fallback) {
    try {
      if (response.body.isNotEmpty) {
        final corpo = jsonDecode(response.body);
        if (corpo is Map) {
          if (corpo.containsKey('message')) return corpo['message'].toString();
          if (corpo.containsKey('error')) return corpo['error'].toString();
        }
      }
    } catch (_) {
      if (response.body.isNotEmpty) return response.body;
    }
    return fallback;
  }

  Future<Usuario> buscarPerfil(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Conta não encontrada.');
    } else {
      throw Exception(
        _extrairMensagemErro(
          response,
          'Erro ao carregar perfil (Status: ${response.statusCode}).',
        ),
      );
    }
  }

  Future<void> atualizarDados(int id, String nome, String email) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/$id/dados'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'email': email}),
    );

    if (response.statusCode == 204 || response.statusCode == 200) return;

    if (response.statusCode == 404) {
      throw Exception('Conta não encontrada.');
    } else if (response.statusCode == 409) {
      throw Exception('Este e-mail já está em uso.');
    } else {
      throw Exception(
        _extrairMensagemErro(
          response,
          'Erro ao atualizar dados (Status: ${response.statusCode}).',
        ),
      );
    }
  }

  Future<void> atualizarSenha(
    int id,
    String senhaAtual,
    String novaSenha,
  ) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/$id/senha'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'senhaAtual': senhaAtual, 'novaSenha': novaSenha}),
    );

    if (response.statusCode == 204 || response.statusCode == 200) return;

    if (response.statusCode == 404) {
      throw Exception('Conta não encontrada.');
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      throw Exception(_extrairMensagemErro(response, 'Senha atual incorreta.'));
    } else {
      throw Exception(
        _extrairMensagemErro(
          response,
          'Erro ao atualizar senha (Status: ${response.statusCode}).',
        ),
      );
    }
  }

  Future<void> atualizarFoto(int id, String fotoUrlOrBase64) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/$id/foto'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fotoUrlOrBase64': fotoUrlOrBase64}),
    );

    if (response.statusCode == 204 || response.statusCode == 200) return;

    if (response.statusCode == 404) {
      throw Exception('Conta não encontrada.');
    } else {
      throw Exception(
        _extrairMensagemErro(
          response,
          'Erro ao atualizar foto (Status: ${response.statusCode}).',
        ),
      );
    }
  }

  Future<void> excluirConta(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 204 || response.statusCode == 200) return;

    if (response.statusCode == 404) {
      throw Exception('Conta não encontrada. Ela pode já ter sido excluída.');
    } else {
      throw Exception(
        _extrairMensagemErro(
          response,
          'Erro ao excluir conta (Status: ${response.statusCode}).',
        ),
      );
    }
  }
}
