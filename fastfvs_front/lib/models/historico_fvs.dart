class HistoricoFvs {
  final String id;
  final String nomeUsuario;
  final String acao;
  final DateTime momentoAcao;
  final String? observacao;

  HistoricoFvs({
    required this.acao, 
    required this.id, 
    required this.momentoAcao, 
    required this.observacao, 
    required this.nomeUsuario,
  });

  factory HistoricoFvs.fromJson(Map<String, dynamic> json){
    return HistoricoFvs(
      id: json['id'],
      nomeUsuario: json['usuarioNome'],
      acao: json['acao'],
      momentoAcao: json['dataHora'],
      observacao: json['observacao']
    );
  }
}