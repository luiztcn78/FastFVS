import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:fastfvs_front/models/usuario.dart';

class AuthService {
  String get _baseUrl {
    if (kIsWeb) {
      return 'http://172.16.30.248:8080/api/auth';
    } else if (Platform.isAndroid) {
      return 'http://172.16.30.248:8080/api/auth';
    } else if (Platform.isIOS) {
      return 'http://localhost:8080/api/auth';
    } else {
      return 'http://172.16.30.248:8080/api/auth';
    }
  }

  Future<Usuario> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('E-mail ou senha incorretos.');
    } else if (response.statusCode == 404) {
      throw Exception('Usuário não encontrado.');
    } else {
      String mensagem =
          'Erro ao conectar com o servidor (Status: ${response.statusCode}).';
      try {
        final corpoErro = jsonDecode(response.body);
        if (corpoErro.containsKey('message')) {
          mensagem = corpoErro['message'];
        } else if (corpoErro.containsKey('error')) {
          mensagem = corpoErro['error'];
        }
      } catch (_) {}
      throw Exception(mensagem);
    }
  }

  Future<Usuario> register({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
        'confirmarSenha': senha,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return Usuario.fromJson(jsonDecode(response.body));
      } catch (e) {
        throw Exception('Cadastro realizado, mas erro ao processar retorno: $e');
      }
    } else if (response.statusCode == 409) {
      throw Exception('E-mail já cadastrado.');
    } else {
      String mensagem = 'Erro ao criar conta (Status: ${response.statusCode}).';
      try {
        final corpoErro = jsonDecode(response.body);
        if (corpoErro.containsKey('message')) {
          mensagem = corpoErro['message'];
        } else if (corpoErro.containsKey('error')) {
          mensagem = corpoErro['error'];
        }
      } catch (_) {}
      throw Exception(mensagem);
    }
  }

  // NOVO: solicita o envio do código de recuperação por e-mail
  Future<void> solicitarReset(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/solicitar-reset?email=${Uri.encodeComponent(email)}'),
    );

    // O backend sempre retorna 200 mesmo se o e-mail não existir (segurança silenciosa)
    if (response.statusCode != 200) {
      throw Exception('Erro ao solicitar recuperação de senha.');
    }
  }

  // NOVO: valida se o código digitado é válido para o e-mail informado
  Future<bool> validarToken(String email, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/validar-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'token': token}),
    );

    if (response.statusCode == 200) return true;
    if (response.statusCode == 401) return false;
    throw Exception('Erro ao validar código.');
  }


  Future<void> redefinirSenha({
    required String email,
    required String token,
    required String novaSenha,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/redefinir-senha'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'token': token,
        'novaSenha': novaSenha,
      }),
    );

    if (response.statusCode == 200) return;

    String mensagem = 'Erro ao redefinir senha.';
    try {
      final corpo = jsonDecode(response.body);
      if (corpo.containsKey('mensagem')) mensagem = corpo['mensagem'];
    } catch (_) {}
    throw Exception(mensagem);
  }
}