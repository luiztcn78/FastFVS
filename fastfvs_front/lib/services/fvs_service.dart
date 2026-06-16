import 'dart:convert';

import 'package:fastfvs_front/models/fvs.dart';
import 'package:http/http.dart' as http;

class FvsService {

  final String urlBase = "http://172.16.32.80:8080";

  Future<List<String>> listarFvsPadroes() async {

    final response = await http.get(
        Uri.parse("$urlBase/api/fvs/padroes")
      );

      if(response.statusCode == 200){

        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        
        return List<String>.from(jsonResponse['padroes']);

      }else{
        throw Exception("Erro ao buscar Fvs padrões");
      }

  }

  Future<void> criarFVS(String titulo, int subsecaoId, int usuarioId) async {

    final response = await http.post(
      Uri.parse('$urlBase/fvs?usuarioId=$usuarioId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'titulo': titulo,
        'subsecaoId': subsecaoId,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
    } else {
      throw Exception('Erro ao criar FVS');
    }
  }

  Future<void> atualizarStatus(String idFvs, String status, int usuarioId) async {
    final response = await http.patch(Uri.parse('$urlBase/$idFvs/status/'), 
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "status": status,
      "usuarioId": usuarioId,
    }),
    );

    if(response.statusCode != 200){
      throw Exception('Erro ao atualizar o status');
    }
  }

  Future<List<Fvs>> listarFvsPorSubsecao(int subsecaoId) async {
    final response = await http.get(Uri.parse('$urlBase/subsecao/$subsecaoId'));

     if(response.statusCode == 200){

        List jsonResponse = jsonDecode(response.body);

        return jsonResponse
          .map((fvs) => Fvs.fromJson(fvs))
          .toList();

      }else{
        throw Exception("Erro ao listar Fvss");
      }
  }

  Future<void> deletarFvs(String fvsId) async {
    final response = await http.get(Uri.parse('$urlBase/$fvsId'));

    if(response.statusCode != 204) {
      throw Exception("Erro ao excluir fvs");
    }
  }
}