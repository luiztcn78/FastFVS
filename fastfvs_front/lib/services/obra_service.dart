import 'dart:convert';

import 'package:fastfvs_front/models/compartilhamento_dto.dart';
import 'package:fastfvs_front/models/obra.dart';
import 'package:http/http.dart' as http;

class ObraService {

  final String urlBase = "http://192.168.1.6:8080/api/obras";

  Future<void> criarObra(String nome, String? linkProjeto, int usuarioId) async {
    final response = await http.post(
      Uri.parse('$urlBase?usuarioId=$usuarioId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'linkProjeto': linkProjeto,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar obra');
    }
  }

  Future<double> getConformidadeObra(int obraId) async {
    final response = await http.get(Uri.parse('$urlBase/$obraId/conformidade'));

    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      double percentual = json['percentual'];
      return percentual;
    }
    else{
      throw Exception('Erro ao informar a conformidade da obra');
    }
  }

  Future<Map<String, int>> contarStatusObra(int obraId) async {
    final response = await http.get(Uri.parse('$urlBase/$obraId/contagem-status'));

    if (response.statusCode == 200){
      Map<String, int> resumo = Map<String, int>.from(jsonDecode(response.body));

      return resumo;
    }
    else{
      throw Exception('Erro ao informar resumo da conformidade da obra');
    }
  }

  Future<List<Obra>> listarObraPorUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('$urlBase/usuario/$usuarioId'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((obra) => Obra.fromJson(obra)).toList();
  }
    else {
      throw Exception('Erro ao listar obras');
    }
  }

  Future<CompartilhamentoDTO> obterQrCodeObra(int obraId) async {
    final response = await http.get(Uri.parse('$urlBase/$obraId/qrcode'));

    if (response.statusCode == 200) {
      return CompartilhamentoDTO.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Erro ao retornar QrCode');
    }
  }

  Future<String> obterLinkObra(int obraId) async {
    final response = await http.get(Uri.parse('$urlBase/$obraId/link'));

    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      String link = json['link'];
      return link;
    }
    else{
      throw Exception('Erro ao informar a conformidade da obra');
    }
  }

  Future<Obra> getObra(int obraId) async {
    final response = await http.get(Uri.parse('$urlBase/$obraId'));

    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      return Obra.fromJson(json);
    }
    else{
      throw Exception('Erro ao encontrar obra');
    }
  }

  Future<void> deletarObra(int obraId) async {
    final response = await http.delete(Uri.parse('$urlBase/$obraId'));

    if(response.statusCode != 204){
      throw Exception('Erro ao deletar obra');
    } 
  }

  Future<void> atualizarNome(int obraId, String novoNome) async {
    final response = await http.patch(Uri.parse('$urlBase/$obraId/nome?novoNome=$novoNome'));

    if(response.statusCode != 200) {
      throw Exception('Erro ao mudar nome da obra');
    }
  }
}