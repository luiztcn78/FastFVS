import 'dart:convert';
import 'package:fastfvs_front/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessaoUsuario {
  static Usuario? _usuarioLogado;
  static const String _chaveStorage = 'usuario_logado';

  static Usuario? get usuario => _usuarioLogado;

  static bool get estaLogado => _usuarioLogado != null;

  /// Inicia a sessão em memória e persiste no storage local.
  static Future<void> iniciar(Usuario usuario) async {
    _usuarioLogado = usuario;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _chaveStorage,
      jsonEncode({
        'id': usuario.id,
        'nome': usuario.nome,
        'email': usuario.email,
        'fotoPerfil': usuario.fotoPerfil,
      }),
    );
  }

  /// Encerra a sessão em memória e remove do storage local.
  static Future<void> encerrar() async {
    _usuarioLogado = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveStorage);
  }

  /// Tenta recarregar a sessão salva. Deve ser chamado uma vez,
  /// antes do runApp, para sobreviver a refresh da página (web)
  /// ou reinício do app (mobile/desktop).
  static Future<bool> recarregarSessaoSalva() async {
    final prefs = await SharedPreferences.getInstance();
    final dadosSalvos = prefs.getString(_chaveStorage);
    if (dadosSalvos == null) return false;

    try {
      final json = jsonDecode(dadosSalvos) as Map<String, dynamic>;
      _usuarioLogado = Usuario.fromJson(json);
      return true;
    } catch (_) {
      await prefs.remove(_chaveStorage);
      return false;
    }
  }
}
