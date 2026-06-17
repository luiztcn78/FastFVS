import 'package:fastfvs_front/main.dart';
import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/pages/pagina_perfil.dart';
import 'package:flutter/material.dart';

class PaginaConfiguracao extends StatelessWidget {
  const PaginaConfiguracao({super.key});

  void _mostrarDialogExcluir(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
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
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // lógica de excluir conta
                      },
                      child: const Text('Confirmar', style: TextStyle(fontSize: 16)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
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

    return PaginaBase(
      paginaAberta: 2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Card de Perfil ──────────────────────────────────────
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Foto de perfil
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: primary.withOpacity(0.2),
                      child: Icon(Icons.person, size: 40, color: primary),
                      // pegar a foto do usuário aqui
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            'Bem-vindo(a),',
                            style: TextStyle(fontSize: 14,
                            color: Theme.of(context).colorScheme.onSecondary,),                           
                          ),
                           Text(
                            'Nome Genérico', //pegar o nome do userr
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
                              side: BorderSide(color: onSurface.withOpacity(0.4)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (context, mode, _) {
                    return SwitchListTile(
                      title: const Text('Dark Mode', style: TextStyle(fontSize: 16)),
                      value: mode == ThemeMode.dark,
                      onChanged: (bool value) {
                        themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                      },
                      activeColor: primary,
                      activeTrackColor: Colors.white,
                      inactiveThumbColor: Theme.of(context).colorScheme.secondary,
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Column(
                children: [

                  // Sair da Conta
                  ListTile(
                    title: const Text('Sair da Conta', style: TextStyle(fontSize: 16)),
                    leading: const Icon(Icons.account_circle_outlined),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // sair da conta aqui lógica
                    },
                  ),

                  Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.shade300),

                  // Excluir Conta
                  ListTile(
                    title: const Text('Excluir Conta', style: TextStyle(fontSize: 16)),
                    leading: const Icon(Icons.delete_outline),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_outlined, color: Theme.of(context).colorScheme.error),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () => _mostrarDialogExcluir(context),
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