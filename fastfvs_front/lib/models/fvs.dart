class Fvs {
  final String id;
  final String titulo;
  final String status;
  final DateTime dataAbertura;
  final DateTime dataUltimaEdicao;
  final String? ultimaEdicaoPorNome;

  Fvs({
    required this.id,
    required this.titulo,
    required this.status,
    required this.dataAbertura,
    required this.dataUltimaEdicao,
    this.ultimaEdicaoPorNome,
  });

  factory Fvs.fromJson(Map<String, dynamic> json) {
    return Fvs(
      id: json['id'],
      titulo: json['titulo'],
      status: json['status'],
      dataAbertura: DateTime.parse(json['dataAbertura']),
      dataUltimaEdicao: DateTime.parse(json['dataUltimaEdicao']),
      ultimaEdicaoPorNome: json['ultimaEdicaoPorNome'],
    );
  }
}