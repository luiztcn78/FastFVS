import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/widgets/barra_pesquisar.dart';
import 'package:fastfvs_front/view/widgets/contador_numero.dart';
import 'package:fastfvs_front/view/widgets/popup_compartilhar.dart';
import 'package:fastfvs_front/view/widgets/popup_criacao_automatica.dart';
import 'package:fastfvs_front/view/widgets/popup_editar_obra.dart';
import 'package:fastfvs_front/view/widgets/popup_fvs_padroes.dart';
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

  String? _subPopup;

  final TextEditingController _nomeController = TextEditingController(
    text: "Residencial Flores",
  );

  void _fecharTudo() {
    setState(() {
      _popupAberto = false;
      _blocoAberto = false;
      _pavAberto = false;
      _mostrarBotoes = false;
      _subPopup = null;
    });
  }

  void _fecharSubPopup() {
    setState(() => _subPopup = null);
  }

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
                      fontSize: largura * 0.06, color: Theme.of(context).colorScheme.onSecondary,
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
              onPressed: () => setState(() => _popupAberto = true),
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
              onTap: _fecharTudo,
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
                            GestureDetector(
                              onTap: () => setState(() => _subPopup = 'editar'),
                              child: Icon(
                                Icons.edit,
                                color: cor.onPrimary,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      _linhaArvore(
                        cor: cor,
                        icone: Icons.view_module,
                        label: "Bloco A",
                        expandido: _blocoAberto,
                        onExpandir: () =>
                            setState(() => _blocoAberto = !_blocoAberto),
                        indent: 0,
                      ),

                      if (_blocoAberto)
                        _linhaArvore(
                          cor: cor,
                          icone: Icons.layers,
                          label: "Pav 1",
                          expandido: _pavAberto,
                          onExpandir: () =>
                              setState(() => _pavAberto = !_pavAberto),
                          indent: 16,
                        ),

                      if (_blocoAberto && _pavAberto)
                        _linhaArvore(
                          cor: cor,
                          icone: Icons.door_front_door,
                          label: "Apt 1",
                          expandido: false,
                          onExpandir: null,
                          indent: 32,
                        ),
                      const SizedBox(height: 12),
                      if (_mostrarBotoes) ...[
                        _botaoOutlined(
                          cor,
                          "Criação Automática",
                          () => setState(() => _subPopup = 'criacao'),
                        ),
                        const SizedBox(height: 8),
                        _botaoOutlined(
                          cor,
                          "FVS Padrões",
                          () => setState(() => _subPopup = 'fvs'),
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
                            onPressed: () =>
                                setState(() => _subPopup = 'compartilhar'),
                          ),
                          ElevatedButton(
                            onPressed: () => setState(() => _popupAberto = !_popupAberto,),

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
                            onPressed: () => setState(
                              () => _mostrarBotoes = !_mostrarBotoes
                              ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (_subPopup == 'criacao')
            PopupCriacaoAutomatica(onFechar: _fecharSubPopup),

          if (_subPopup == 'fvs') PopupFvsPadroes(onFechar: _fecharSubPopup),

          if (_subPopup == 'compartilhar')
            PopupCompartilhar(onFechar: _fecharSubPopup),

          if (_subPopup == 'editar')
            PopupEditarObra(
              nomeController: _nomeController,
              onFechar: _fecharSubPopup,
            ),
        ],
      ),
    );
  }

  Widget _linhaArvore({
    required ColorScheme cor,
    required IconData icone,
    required String label,
    required bool expandido,
    required VoidCallback? onExpandir,
    required double indent,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Row(
        children: [
          GestureDetector(
            onTap: onExpandir,
            child: Icon(
              onExpandir == null
                  ? Icons.chevron_right
                  : expandido
                  ? Icons.expand_more
                  : Icons.chevron_right,
              color: cor.primary,
            ),
          ),
          Icon(icone, color: cor.primary, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label, style: TextStyle(color: cor.primary)),
          ),
          Icon(Icons.edit, color: cor.primary, size: 18),
          const SizedBox(width: 8),
          Icon(Icons.add, color: cor.primary, size: 20),
        ],
      ),
    );
  }

  Widget _botaoOutlined(ColorScheme cor, String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: cor.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(label, style: TextStyle(color: cor.primary)),
      ),
    );
  }
}
