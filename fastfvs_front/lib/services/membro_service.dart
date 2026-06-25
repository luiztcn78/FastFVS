import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class MembroService {
  String get _baseUrl {
    if (kIsWeb) return 'http://192.168.1.7:8080/api/membros';
    if (Platform.isAndroid) return 'http://10.0.2.2:8080/api/membros';
    if (Platform.isIOS) return 'http://localhost:8080/api/membros';
    return 'http://192.168.3.105:8080/api/membros';
  }

  Future<void> adicionarMembroPorEmail({
    required int obraId,
    required String email,
    required String role, // 'GERENTE' ou 'PADRAO'
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/obra/$obraId/por-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'role': role}),
    );

    if (response.statusCode == 201) return;

    String mensagem = 'Erro ao adicionar membro.';
    try {
      final corpo = jsonDecode(response.body);
      if (corpo.containsKey('mensagem')) mensagem = corpo['mensagem'];
    } catch (_) {}
    throw Exception(mensagem);
  }
}