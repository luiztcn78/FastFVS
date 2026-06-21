import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class UsuarioService {
  String get _baseUrl {
    if (kIsWeb) {
      return 'http://192.168.191.164:8080/api/usuarios';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api/usuarios';
    } else if (Platform.isIOS) {
      return 'http://localhost:8080/api/usuarios';
    } else {
      return 'http://192.168.191.164:8080/api/usuarios';
    }
  }

  Future<void> excluirConta(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 204 || response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 404) {
      throw Exception('Conta não encontrada. Ela pode já ter sido excluída.');
    }

    String mensagem = 'Erro ao excluir conta (Status: ${response.statusCode}).';
    try {
      if (response.body.isNotEmpty) {
        mensagem = response.body;
      }
    } catch (_) {}
    throw Exception(mensagem);
  }
}
