import 'dart:convert';

import 'package:fastfvs_front/models/compartilhamento_dto.dart';
import 'package:fastfvs_front/models/subsecao.dart';
import 'package:http/http.dart' as http;

class SubsecaoService {
    final String urlBase = "http://172.16.32.80:8080/api/subsecao";

    Future<void> criarSubsecao(String nome, int obraId, int usuarioId, {int? paiId, List<String>? fvsEscolhidas}) async {
    final response = await http.post(
      Uri.parse(urlBase),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'obraId': obraId,
        'usuarioId': usuarioId,
        'paiId': paiId,
        'fvsEscolhidas': fvsEscolhidas,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao criar subsecao');
    }
  }

  Future<Map<String, bool>> statusPresentesNasubsecao(int subsecaoId) async {
    final response = await http.get(Uri.parse('$urlBase/$subsecaoId/status-presentes'));

    if(response.statusCode == 200) {
      Map<String, bool> resumo = Map<String, bool>.from(jsonDecode(response.body));
      return resumo;
    }
    else{
      throw Exception('Erro ao retornar resumo de status');
    }
  } 

  Future<void> criarEstruturaAutomatica(
    int obraId,
    int qtdBlocos,
    int pavPorBloco,
    int aptPorPav,
    String padraoNumeracao,
    int usuarioId,
    List<String> fvsEscolhidas,
  ) async {
    final response = await http.post(
      Uri.parse('$urlBase/geracao-automatica'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'obraId': obraId,
        'qtdBlocos': qtdBlocos,
        'pavPorBloco': pavPorBloco,
        'aptPorPav': aptPorPav,
        'padraoNumeracao': padraoNumeracao,
        'usuarioId': usuarioId,
        'fvsEscolhidas': fvsEscolhidas,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao criar estrutura automática');
    }
  }

  Future<List<Subsecao>> listarFilhas(int paiId) async {
    final response = await http.get(Uri.parse('$urlBase/$paiId/filhas'));

    if(response.statusCode == 200) {
       List jsonResponse = jsonDecode(response.body);

        return jsonResponse
          .map((subsecao) => Subsecao.fromJson(subsecao))
          .toList();
    }
    else{
      throw Exception('Erro ao listar subseções filhas');
    }
  }

  Future<Subsecao> buscarSubsecao(int subsecaoId) async {
    final response = await http.get(Uri.parse('$urlBase/$subsecaoId'));

    if(response.statusCode == 200) {

        return Subsecao.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception('Erro ao buscar subseção');
    }
  }

  Future<List<Subsecao>> listarRaizesPorObra(int obraId) async {
    final response = await http.get(Uri.parse('$urlBase/obra/$obraId/raizes'));

    if(response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);

      return jsonResponse
        .map((subsecao) => Subsecao.fromJson(subsecao))
        .toList();
    }
    else{
      throw Exception('Erro ao buscar raízes');
    }
  }

  Future<String> obterCaminhoCompleto(int subsecaoId) async {
    final response = await http.get(Uri.parse('$urlBase/$subsecaoId/caminho'));

    if(response.statusCode == 200) {
      final json = jsonDecode(response.body);
      String caminho = json['caminho'];
      return caminho;
    }
    else{
      throw Exception('Erro ao buscar raízes');
    }
  }

  Future<String> obterLink(int subsecaoId) async {
    final response = await http.get(Uri.parse('$urlBase/$subsecaoId/link'));

    if(response.statusCode == 200) {
      final json = jsonDecode(response.body);
      String link = json['link'];
      return link;
    }
    else{
      throw Exception('Erro ao buscar raízes');
    }
  }

  Future<CompartilhamentoDTO> obterQrCode(int subsecaoId) async {
    final response = await http.get(Uri.parse('$urlBase/$subsecaoId/link'));

    if (response.statusCode == 200) {
      return CompartilhamentoDTO.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Erro ao retornar QrCode');
    }
  }

  Future<void> deletarSubsecao(int subsecaoId) async {
    final response = await http.delete(Uri.parse('$urlBase/$subsecaoId'));

    if (response.statusCode != 204) {
      throw Exception('Erro ao retornar deletar subseção');
    }
  }
}