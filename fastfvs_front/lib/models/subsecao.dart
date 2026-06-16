class Subsecao {
  final int id;
  final String nome;
  final int obraId;
  final int? paiId;

  Subsecao({
    required this.id, 
    required this.nome, 
    required this.obraId, 
    required this.paiId
  });

  factory Subsecao.fromJson(Map<String, dynamic> json){
    return Subsecao(
      id: json['id'],
      nome: json['nome'],
      obraId: json['obraId'],
      paiId: json['paiId'],
    );
  }
}