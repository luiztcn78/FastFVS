import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/widgets/barra_pesquisar.dart';
import 'package:flutter/material.dart';

class PaginaMinhasObras extends StatefulWidget {
  const PaginaMinhasObras({super.key});

  @override
  State<PaginaMinhasObras> createState() => _PaginaMinhasObrasState();
}

class _PaginaMinhasObrasState extends State<PaginaMinhasObras> {
  bool _popupAberto = false;
  bool _blocoAberto = false;
  bool _pavAberto = false;
  bool _mostrarBotoes = false;

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final cor = Theme.of(context).colorScheme;

    return PaginaBase(
      paginaAberta: 0,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: largura * 0.1),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Minhas Obras",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: largura * 0.06,
                    ),
                  ),
                ),
              ),
              Expanded(child: BarraPesquisar()),
            ],
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _popupAberto = true;
                });
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add Obra",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: cor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          if (_popupAberto) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  _popupAberto = false;
                  _blocoAberto = false;
                  _pavAberto = false;
                  _mostrarBotoes = false;
                });
              },
              child: Container(color: Colors.black26),
            ),
            Positioned(
              top: 60,
              left: largura * 0.05,
              right: largura * 0.05,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: cor.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.home, color: cor.onPrimary, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Nome",
                                style: TextStyle(
                                  color: cor.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.edit, color: cor.onPrimary, size: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Bloco A
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                setState(() => _blocoAberto = !_blocoAberto),
                            child: Icon(
                              _blocoAberto
                                  ? Icons.expand_more
                                  : Icons.chevron_right,
                              color: cor.primary,
                            ),
                          ),
                          Icon(Icons.view_module, color: cor.primary, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "Bloco A",
                              style: TextStyle(color: cor.primary),
                            ),
                          ),
                          Icon(Icons.edit, color: cor.primary, size: 18),
                          const SizedBox(width: 8),
                          Icon(Icons.add, color: cor.primary, size: 20),
                        ],
                      ),
                      if (_blocoAberto)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _pavAberto = !_pavAberto),
                                child: Icon(
                                  _pavAberto
                                      ? Icons.expand_more
                                      : Icons.chevron_right,
                                  color: cor.primary,
                                ),
                              ),
                              Icon(Icons.layers, color: cor.primary, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Pav 1",
                                  style: TextStyle(color: cor.primary),
                                ),
                              ),
                              Icon(Icons.edit, color: cor.primary, size: 18),
                              const SizedBox(width: 8),
                              Icon(Icons.add, color: cor.primary, size: 20),
                            ],
                          ),
                        ),
                      if (_blocoAberto && _pavAberto)
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Row(
                            children: [
                              Icon(Icons.chevron_right, color: cor.primary),
                              Icon(
                                Icons.door_front_door,
                                color: cor.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Apt 1",
                                  style: TextStyle(color: cor.primary),
                                ),
                              ),
                              Icon(Icons.edit, color: cor.primary, size: 18),
                              const SizedBox(width: 8),
                              Icon(Icons.add, color: cor.primary, size: 20),
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),
                      if (_mostrarBotoes) ...[
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: cor.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Criação Automática",
                              style: TextStyle(color: cor.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: cor.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "FVS Padrões",
                              style: TextStyle(color: cor.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.person_add_outlined,
                              color: cor.primary,
                            ),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() => _mostrarBotoes = !_mostrarBotoes);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cor.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              "Finalizar",
                              style: TextStyle(color: cor.onPrimary),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.settings_outlined,
                              color: cor.primary,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
