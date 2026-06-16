import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:fastfvs_front/models/usuario.dart';

class AuthService {
  String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api/auth';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api/auth';
    } else if (Platform.isIOS) {
      return 'http://localhost:8080/api/auth';
    } else {
      return 'http://192.168.191.194:8080/api/auth';
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
        'confirmarSenha':
            senha, // backend valida presença, Flutter já validou igualdade
      }),
    );

    // 1. Alterado para aceitar 200 ou 201
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        // Opcional: print para ajudar a debugar se o backend mandar um JSON inesperado
        print('RESPOSTA DE SUCESSO (CADASTRO): ${response.body}');
        return Usuario.fromJson(jsonDecode(response.body));
      } catch (e) {
        throw Exception(
          'Cadastro realizado, mas erro ao processar retorno: $e',
        );
      }
    } else if (response.statusCode == 409) {
      throw Exception('E-mail já cadastrado.');
    } else {
      // 2. Extrai a mensagem real do erro (caso o backend mande)
      String mensagem = 'Erro ao criar conta (Status: ${response.statusCode}).';
      try {
        final corpoErro = jsonDecode(response.body);
        if (corpoErro.containsKey('message')) {
          mensagem = corpoErro['message'];
        } else if (corpoErro.containsKey('error')) {
          mensagem = corpoErro['error'];
        }
      } catch (_) {}

      print('ERRO NO CADASTRO: ${response.body}');
      throw Exception(mensagem);
    }
  }
}
