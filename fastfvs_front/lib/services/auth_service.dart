import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fastfvs_front/models/usuario.dart';

class AuthService {
  static const String _baseUrl = 'http://SEU_IP:8080/api/auth';

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
    } else {
      throw Exception('Erro ao conectar com o servidor.');
    }
  }
}
