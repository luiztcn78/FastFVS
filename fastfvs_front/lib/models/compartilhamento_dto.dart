class CompartilhamentoDTO {
  final String link;
  final String qrcode; // base64 da imagem

  CompartilhamentoDTO({
    required this.link,
    required this.qrcode,
  });

  factory CompartilhamentoDTO.fromJson(Map<String, dynamic> json) {
    return CompartilhamentoDTO(
      link: json['link'],
      qrcode: json['qrcode'],
    );
  }
}