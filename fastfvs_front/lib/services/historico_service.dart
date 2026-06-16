import 'dart:convert';

import 'package:fastfvs_front/models/historico_fvs.dart';
import 'package:http/http.dart' as http;

class HistoricoService {
  final String urlBase = "http://172.16.32.80:8080/api/historico-fvs";

  Future<List<HistoricoFvs>> listarHistoricoFvs(String fvsId) async{
    final response = await http.get(Uri.parse('$urlBase/ficha/$fvsId'));

    if(response.statusCode == 200){

      List jsonResponse = jsonDecode(response.body);

      return jsonResponse
        .map((historico) => HistoricoFvs.fromJson(historico))
        .toList();

    }else{
      throw Exception("Erro ao Encontrar o histórico");
    }
  }
}