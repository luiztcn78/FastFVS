class HistoricoFvs {
  final String id;
  final String nomeUsuario;
  final String acao;
  final DateTime momentoAcao;

  HistoricoFvs({
    required this.id,
    required this.nomeUsuario,
    required this.acao,
    required this.momentoAcao,
  });

  factory HistoricoFvs.fromJson(Map<String, dynamic> json) {
    return HistoricoFvs(
      id: json['id'],
      nomeUsuario: json['usuarioNome'],
      acao: json['acao'],
      momentoAcao: DateTime.parse(json['dataHora']),
    );
  }
}