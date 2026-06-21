import 'dart:convert';
import 'package:flutter/material.dart';

/// Constrói o ImageProvider para a foto de perfil do usuário.
/// Suporta tanto URLs (http/https) quanto strings base64.
/// Retorna null se não houver foto ou se o valor for inválido.
ImageProvider? construirImagemPerfil(String? foto) {
  if (foto == null || foto.isEmpty) return null;

  if (foto.startsWith('http://') || foto.startsWith('https://')) {
    return NetworkImage(foto);
  }

  try {
    return MemoryImage(base64Decode(foto));
  } catch (_) {
    return null;
  }
}
