class MembroObra {
  final int id;
  final int usuarioId;
  final String usuarioNome;
  final int obraId;
  final String role;


  MembroObra({
    required this.id, 
    required this.usuarioId, 
    required this.usuarioNome, 
    required this.obraId, 
    required this.role
  });

  factory MembroObra.fromJson(Map<String, dynamic> json){
    return MembroObra(
      id: json['id'],
      usuarioId: json['usuarioId'],
      usuarioNome: json['usuarioNome'],
      obraId: json['obraId'],
      role: json['role']
    );
  }
}

