class Usuario {
  final int id;
  final String nome;
  final String email;
  final String? fotoPerfil; // 1. O '?' indica que este campo PODE ser nulo

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.fotoPerfil, // 2. O 'required' foi removido porque a foto é opcional
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      // 3. 'foto_perfil' no json (conforme log do seu banco), e aceita null
      fotoPerfil: json['foto_perfil'] ?? json['fotoPerfil'],
    );
  }
}
