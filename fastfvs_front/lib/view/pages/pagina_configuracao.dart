import 'package:fastfvs_front/main.dart';
import 'package:fastfvs_front/services/sessao_usuario.dart';
import 'package:fastfvs_front/services/usuario_service.dart';
import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/pages/pagina_perfil.dart';
import 'package:flutter/material.dart';

class PaginaConfiguracao extends StatefulWidget {
  const PaginaConfiguracao({super.key});

  @override
  State<PaginaConfiguracao> createState() => _PaginaConfiguracaoState();
}

class _PaginaConfiguracaoState extends State<PaginaConfiguracao> {
  final UsuarioService _usuarioService = UsuarioService();
  bool _excluindo = false;

  void _sairDaConta(BuildContext context) {
    SessaoUsuario.encerrar();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> _excluirConta(BuildContext context) async {
    final usuario = SessaoUsuario.usuario;
    if (usuario == null) return;

    setState(() => _excluindo = true);

    try {
      await _usuarioService.excluirConta(usuario.id);
      SessaoUsuario.encerrar();
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível excluir a conta: $e')),
      );
    } finally {
      if (mounted) setState(() => _excluindo = false);
    }
  }

  void _mostrarDialogExcluir(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirme a exclusão',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6BCB77),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _excluirConta(context);
                      },
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final usuario = SessaoUsuario.usuario;

    return PaginaBase(
      paginaAberta: 2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card de Perfil ──────────────────────────────────────
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: primary.withOpacity(0.2),
                      backgroundImage:
                          (usuario?.fotoPerfil != null &&
                              usuario!.fotoPerfil!.isNotEmpty)
                          ? NetworkImage(usuario.fotoPerfil!)
                          : null,
                      child:
                          (usuario?.fotoPerfil == null ||
                              usuario!.fotoPerfil!.isEmpty)
                          ? Icon(Icons.person, size: 40, color: primary)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bem-vindo(a),',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          Text(
                            usuario?.nome ?? 'Usuário',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaginaPerfil(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Editar Perfil'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: onSurface,
                              side: BorderSide(
                                color: onSurface.withOpacity(0.4),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Preferências ────────────────────────────────────────
            Text(
              'Preferências',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (context, mode, _) {
                    return SwitchListTile(
                      title: const Text(
                        'Dark Mode',
                        style: TextStyle(fontSize: 16),
                      ),
                      value: mode == ThemeMode.dark,
                      onChanged: (bool value) {
                        themeNotifier.value = value
                            ? ThemeMode.dark
                            : ThemeMode.light;
                      },
                      activeColor: primary,
                      activeTrackColor: Colors.white,
                      inactiveThumbColor: Theme.of(
                        context,
                      ).colorScheme.secondary,
                      inactiveTrackColor: primary,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Configurações de Conta ───────────────────────────────
            Text(
              'Configurações de Conta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Sair da Conta',
                      style: TextStyle(fontSize: 16),
                    ),
                    leading: const Icon(Icons.account_circle_outlined),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _sairDaConta(context),
                  ),

                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.grey.shade300,
                  ),

                  ListTile(
                    title: const Text(
                      'Excluir Conta',
                      style: TextStyle(fontSize: 16),
                    ),
                    leading: _excluindo
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.delete_outline),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: _excluindo
                        ? null
                        : () => _mostrarDialogExcluir(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
