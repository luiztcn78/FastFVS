class Obra{
  final int id;
  final String nome;
  final String? linkProjeto;
  final double percentualConformidade;
  final String? role;
  final int usuarioId;

  Obra({
    required this.id, 
    required this.nome, 
    required this.linkProjeto, 
    required this.percentualConformidade, 
    required this.role, 
    required this.usuarioId
  });

  factory Obra.fromJson(Map<String, dynamic> json){
    return Obra(
      id: json['id'],
      usuarioId: json['usuarioId'],
      role: json['role'],
      linkProjeto: json['linkProjeto'],
      percentualConformidade: json['percentualConformidade']?.toDouble(),
      nome: json['nome'],
    );
  }
}