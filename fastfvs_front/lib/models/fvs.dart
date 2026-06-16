
class Fvs {
  final String id;
  final String titulo;
  final String status;
  final DateTime dataAbertura;
  final DateTime dataUltimaEdicao;

  Fvs({
    required this.id,
    required this.titulo,
    required this.status,
    required this.dataAbertura,
    required this.dataUltimaEdicao,
  });

  factory Fvs.fromJson(Map<String, dynamic> json){
    return Fvs(
      id: json['id'],
      titulo: json['titulo'],
      status: json['status'],
      dataAbertura: DateTime.parse(json['dataAbertura']),
      dataUltimaEdicao: json['dataUltimaEdicao']
    );
  }
}