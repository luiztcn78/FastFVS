class DadosParticao {
  final int id; 
  final String nome;
  final bool mostrarVerde;
  final bool mostrarAmarelo;
  final bool mostrarVermelho;
  final bool mostrarCinza;
 
  const DadosParticao({
    required this.nome,
    this.id = 0, //pegar do back
    this.mostrarVerde = true,
    this.mostrarAmarelo = true,
    this.mostrarVermelho = true,
    this.mostrarCinza = true,
  });
 
  // mudar aqui pra ver direitinho dps
  factory DadosParticao.fromJson(Map<String, dynamic> json) {
    return DadosParticao(
      id: json['id'],
      nome: json['nome'],
      mostrarVerde: json['mostrarVerde'] ?? true,
      mostrarAmarelo: json['mostrarAmarelo'] ?? true,
      mostrarVermelho: json['mostrarVermelho'] ?? true,
      mostrarCinza: json['mostrarCinza'] ?? true,
    );
  }
}