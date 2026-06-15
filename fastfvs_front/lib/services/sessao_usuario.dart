import 'package:fastfvs_front/models/usuario.dart';

class SessaoUsuario {
  static Usuario? _usuarioLogado;

  static void iniciar(Usuario usuario) {
    _usuarioLogado = usuario;
  }

  static Usuario? get usuario => _usuarioLogado;

  static bool get estaLogado => _usuarioLogado != null;

  static void encerrar() {
    _usuarioLogado = null;
  }
}
