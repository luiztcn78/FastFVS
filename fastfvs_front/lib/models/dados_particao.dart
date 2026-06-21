class DadosParticao {
  final int id; 
  final String nome;
  final double percentualConformidade;
  final bool mostrarVerde;
  final bool mostrarAmarelo;
  final bool mostrarVermelho;
  final bool mostrarCinza;
 
  const DadosParticao({
    required this.nome,
    this.percentualConformidade = 0.0,
    this.id = 0,
    this.mostrarVerde = true,
    this.mostrarAmarelo = true,
    this.mostrarVermelho = true,
    this.mostrarCinza = true,
  });
 
  // mudar aqui pra ver direitinho dps
  factory DadosParticao.fromJson(Map<String, dynamic> json, int particaoId, String particaoNome, double percentualConformidade) {
    return DadosParticao(
      id: particaoId,
      nome: particaoNome,
      percentualConformidade: percentualConformidade,
      mostrarVerde: json['CONFORME'] ?? true,
      mostrarAmarelo: json['EM_ANALISE'] ?? true,
      mostrarVermelho: json['NAO_CONFORME'] ?? true,
      mostrarCinza: json['NAO_INICIADA'] ?? true,
    );
  }
}