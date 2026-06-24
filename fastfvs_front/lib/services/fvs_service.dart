import 'dart:convert';

import 'package:fastfvs_front/models/fvs.dart';
import 'package:http/http.dart' as http;

class FvsService {

  //aqui tem as coisas de fvs incluindo o listar histórico

  final String urlBase = "http://192.168.1.6:8080/api/fvs";

  Future<List<String>> listarFvsPadroes() async {

    final response = await http.get(
        Uri.parse("$urlBase/padroes")
      );

      if(response.statusCode == 200){

        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        
        return List<String>.from(jsonResponse['padroes']);

      }else{
        throw Exception("Erro ao buscar Fvs padrões");
      }

  }

  Future<void> criarFVS({
    required String titulo,
    required int usuarioId,
    int? subsecaoId,
    int? obraId,
    bool aplicarEmTodas = false,
  }) async {
    final response = await http.post(
      Uri.parse('$urlBase?usuarioId=$usuarioId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'titulo': titulo,
        'subsecaoId': subsecaoId,
        'obraId': obraId,
        'aplicarEmTodas': aplicarEmTodas,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar FVS');
    }
}
  Future<void> atualizarStatus(String idFvs, String status, int usuarioId) async {
    final response = await http.patch(Uri.parse('$urlBase/$idFvs/status'), 
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
    final response = await http.delete(Uri.parse('$urlBase/$fvsId'));

    if(response.statusCode != 204) {
      throw Exception("Erro ao excluir fvs");
    }
  }

  Future<void> deletarPorTituloNaObra(int obraId, String titulo) async {
    final tituloCodificado = Uri.encodeComponent(titulo);
    final response = await http.delete(Uri.parse('$urlBase/obra/$obraId/titulo/$tituloCodificado'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir FVS de todas as subseções');
    }
  }
}