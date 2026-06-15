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
      // Caso vá testar direto no seu celular físico conectado via USB/Wi-Fi,
      // troque este 192.168.X.X pelo IP local do seu computador.
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
      // Tenta extrair a mensagem de erro do backend (se houver), senão mostra o status
      String mensagem =
          'Erro ao conectar com o servidor (Status: ${response.statusCode}).';
      try {
        final corpoErro = jsonDecode(response.body);
        if (corpoErro.containsKey('message')) {
          mensagem = corpoErro['message'];
        } else if (corpoErro.containsKey('error')) {
          mensagem = corpoErro['error'];
        }
      } catch (_) {
        // Ignora se o corpo não for um JSON válido
      }
      throw Exception(mensagem);
    }
  }
}
