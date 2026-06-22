import 'package:fastfvs_front/services/obra_service.dart';
import 'package:fastfvs_front/services/sessao_usuario.dart';
import 'package:fastfvs_front/services/subsecao_service.dart';
import 'package:fastfvs_front/view/widgets/contador_numero.dart';
import 'package:flutter/material.dart';

//fazer a animação do botão finalizar carregando

class _Subsecao {
  String nome;
  List<_Subsecao> filhos;
  _Subsecao({required this.nome, List<_Subsecao>? filhos})
    : filhos = filhos ?? [];
}

// Representa uma linha de configuração da Criação Automática:
// um nome-base para o nível (ex: "Bloco") + uma quantidade.
class _NivelAuto {
  TextEditingController nomeController;
  int quantidade;
  _NivelAuto({String nome = '', this.quantidade = 1})
    : nomeController = TextEditingController(text: nome);
}

// Ícones usados para diferenciar visualmente cada profundidade da árvore.
// Não têm mais relação com um nome fixo (Bloco/Pavimento/Apt), apenas
// repetem em ciclo conforme o nível vai ficando mais profundo.
const List<IconData> _iconesPorProfundidade = [
  Icons.view_module,
  Icons.layers,
  Icons.door_front_door,
  Icons.king_bed,
  Icons.bathtub,
  Icons.category,
];

class PaginaCriarObra extends StatefulWidget {
  const PaginaCriarObra({super.key});

  @override
  State<PaginaCriarObra> createState() => _PaginaCriarObraState();
}

class _PaginaCriarObraState extends State<PaginaCriarObra> {
  final TextEditingController _nomeController = TextEditingController();
  final SubsecaoService subsecaoService = SubsecaoService();
  final ObraService obraService = ObraService();

  // Antes: _blocos (só nível 1). Agora: raiz da árvore, qualquer profundidade.
  List<_Subsecao> _raiz = [];
  final Set<_Subsecao> _expandidos = {};

  bool _secaoCriacaoAberta = false;
  bool _secaoFvsAberta = false;

  // Antes: _numBlocos / _numPavimentos / _numApts / _numeracaoInicio.
  // Agora: lista dinâmica de níveis (nome + quantidade), tantos quanto
  // o usuário quiser.
  List<_NivelAuto> _niveisAuto = [_NivelAuto()];

  final Map<String, bool> _fvs = {
    'FVS - Hidráulica': false,
    'FVS - Azulejo': false,
    'FVS - Concretagem': false,
    'FVS - Aviamento': false,
    'FVS - Pintura': false,
    'FVS - Instalação Elétrica': false,
    'FVS - Piso': false,
  };

  @override
  void dispose() {
    _nomeController.dispose();
    for (final nivel in _niveisAuto) {
      nivel.nomeController.dispose();
    }
    super.dispose();
  }

  // ---------------------------------------------------------------------
  // Criação Automática (N níveis dinâmicos)
  // ---------------------------------------------------------------------

  void _adicionarNivelAuto() {
    setState(() => _niveisAuto.add(_NivelAuto()));
  }

  void _removerNivelAuto(_NivelAuto nivel) {
    if (_niveisAuto.length <= 1) return; // sempre mantém ao menos 1 nível
    setState(() {
      nivel.nomeController.dispose();
      _niveisAuto.remove(nivel);
    });
  }

  void _aplicarCriacaoAutomatica() {
    for (final nivel in _niveisAuto) {
      if (nivel.nomeController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preencha o nome de todos os níveis.'),
          ),
        );
        return;
      }
    }

    // Gera recursivamente a árvore a partir do índice de nível atual.
    List<_Subsecao> gerarNivel(int indice) {
      if (indice >= _niveisAuto.length) return [];
      final nivel = _niveisAuto[indice];
      final nomeBase = nivel.nomeController.text.trim();
      return List.generate(nivel.quantidade, (i) {
        return _Subsecao(
          nome: '$nomeBase ${i + 1}',
          filhos: gerarNivel(indice + 1),
        );
      });
    }

    setState(() {
      _raiz = gerarNivel(0);
      _expandidos.clear();
      _secaoCriacaoAberta = false;
    });
  }

  // ---------------------------------------------------------------------
  // Estrutura manual (árvore genérica, qualquer profundidade)
  // ---------------------------------------------------------------------

  void _abrirDialogoNome({
    required String titulo,
    required String valorInicial,
    required void Function(String) onConfirmar,
  }) {
    final ctrl = TextEditingController(text: valorInicial);
    final cor = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cor.primary, width: 2),
        ),
        title: Text(
          titulo,
          style: TextStyle(color: cor.onSecondary, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cor.primary, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cor.primary, width: 2),
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton(
            onPressed: () {
              onConfirmar(ctrl.text.trim());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff84E08F),
              foregroundColor: cor.onSecondary,
              fixedSize: const Size(120, 40),
              side: BorderSide(color: cor.primary, width: 2),
            ),
            child: const Text('Confirmar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFF6D6D),
              foregroundColor: cor.onSecondary,
              fixedSize: const Size(120, 40),
              side: BorderSide(color: cor.primary, width: 2),
            ),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  // Adiciona um filho em qualquer lista (raiz ou filhos de um nó).
  // 'pai' é opcional: se informado, o pai é expandido automaticamente
  // para o novo filho ficar visível.
  void _adicionarFilho(List<_Subsecao> lista, {_Subsecao? pai}) {
    _abrirDialogoNome(
      titulo: 'Adicionar Item',
      valorInicial: 'Item ${lista.length + 1}',
      onConfirmar: (nome) {
        if (nome.isNotEmpty) {
          setState(() {
            lista.add(_Subsecao(nome: nome));
            if (pai != null) _expandidos.add(pai);
          });
        }
      },
    );
  }

  void _editarNo(_Subsecao no) {
    _abrirDialogoNome(
      titulo: 'Editar Item',
      valorInicial: no.nome,
      onConfirmar: (nome) {
        if (nome.isNotEmpty) setState(() => no.nome = nome);
      },
    );
  }

  void _removerNo(List<_Subsecao> listaPai, _Subsecao no) {
    setState(() {
      listaPai.remove(no);
      _expandidos.remove(no);
    });
  }

  bool _validar() {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe o nome da obra.')));
      return false;
    }
    return true;
  }

  //conexão com o back

  Future<void> criarSubsecoes(
    List<_Subsecao> lista,
    int obraId,
    int usuarioId,
    List<String> fvsEscolhidas,
    int? paiId,
    ) async {
      for(final subsecao in lista){
        final subsecaoCriada = await subsecaoService.criarSubsecao(subsecao.nome, 
        obraId, 
        usuarioId, 
        paiId: paiId, 
        fvsEscolhidas: fvsEscolhidas);

        if(subsecao.filhos.isNotEmpty){
          await criarSubsecoes(subsecao.filhos, obraId, usuarioId, fvsEscolhidas, subsecaoCriada.id);
        }
      }
    }



  void _finalizar() async {
    if (!_validar()) return;
    
    final usuarioId = SessaoUsuario.usuario!.id;

    final fvsEscolhidas = _fvs.entries.where((fvs) => fvs.value).map((fvs) => fvs.key).toList();

    final obraCriada = await obraService.criarObra(_nomeController.text.trim(), null, usuarioId);

    await criarSubsecoes(_raiz, obraCriada.id, usuarioId, fvsEscolhidas, null);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme;
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cor.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cor.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nova Obra',
          style: TextStyle(
            color: cor.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: largura * 0.05,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _secaoTitulo(cor, 'Identificação'),
            const SizedBox(height: 12),
            _cardNome(cor),
            const SizedBox(height: 24),
            _secaoTitulo(cor, 'Estrutura'),
            const SizedBox(height: 12),
            _cardEstrutura(cor),
            const SizedBox(height: 24),
            _cardExpansivel(
              cor: cor,
              titulo: 'Criação Automática',
              aberto: _secaoCriacaoAberta,
              onToggle: () =>
                  setState(() => _secaoCriacaoAberta = !_secaoCriacaoAberta),
              filho: _conteudoCriacaoAutomatica(cor),
            ),
            const SizedBox(height: 16),
            _cardExpansivel(
              cor: cor,
              titulo: 'FVS Padrões',
              aberto: _secaoFvsAberta,
              onToggle: () =>
                  setState(() => _secaoFvsAberta = !_secaoFvsAberta),
              filho: _conteudoFvsPadroes(cor),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _finalizar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text(
                  'Finalizar',
                  style: TextStyle(
                    color: cor.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _secaoTitulo(ColorScheme cor, String titulo) {
    return Text(
      titulo,
      style: TextStyle(
        color: cor.onSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _cardNome(ColorScheme cor) {
    return GestureDetector(
      onTap: () => _abrirDialogoNome(
        titulo: 'Nome da Obra',
        valorInicial: _nomeController.text,
        onConfirmar: (v) => setState(() => _nomeController.text = v),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cor.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.home, color: cor.onPrimary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _nomeController,
                builder: (_, value, __) => Text(
                  value.text.isEmpty ? 'Toque para nomear' : value.text,
                  style: TextStyle(
                    color: cor.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Icon(Icons.edit, color: cor.onPrimary, size: 20),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Card "Estrutura" — agora desenha a árvore recursivamente, sem nomes fixos
  // ---------------------------------------------------------------------

  Widget _cardEstrutura(ColorScheme cor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: cor.primary.withOpacity(0.35)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (_raiz.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Nenhuma estrutura. Use "Criação Automática" ou adicione manualmente.',
                style: TextStyle(
                  color: cor.primary.withOpacity(0.6),
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ..._raiz.map((no) => _noWidget(cor, _raiz, no, 0)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _adicionarFilho(_raiz),
              icon: Icon(Icons.add, color: cor.primary, size: 18),
              label: Text(
                'Adicionar Item',
                style: TextStyle(color: cor.primary, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget único e recursivo: substitui _blocoWidget / _pavimentoWidget /
  // _aptWidget. Funciona para qualquer profundidade de hierarquia.
  Widget _noWidget(
    ColorScheme cor,
    List<_Subsecao> listaPai,
    _Subsecao no,
    int profundidade,
  ) {
    final expandido = _expandidos.contains(no);
    final icone = _iconesPorProfundidade[profundidade % _iconesPorProfundidade.length];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: profundidade * 16.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(
                  () => expandido
                      ? _expandidos.remove(no)
                      : _expandidos.add(no),
                ),
                child: Icon(
                  expandido ? Icons.expand_more : Icons.chevron_right,
                  color: cor.primary,
                ),
              ),
              Icon(icone, color: cor.primary, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(no.nome, style: TextStyle(color: cor.primary)),
              ),
              GestureDetector(
                onTap: () => _editarNo(no),
                child: Icon(Icons.edit, color: cor.primary, size: 18),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _adicionarFilho(no.filhos, pai: no),
                child: Icon(Icons.add, color: cor.primary, size: 20),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => _removerNo(listaPai, no),
                child: Icon(
                  Icons.delete_outline,
                  color: cor.primary.withOpacity(0.6),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        if (expandido)
          ...no.filhos.map(
            (filho) => _noWidget(cor, no.filhos, filho, profundidade + 1),
          ),
      ],
    );
  }

  Widget _cardExpansivel({
    required ColorScheme cor,
    required String titulo,
    required bool aberto,
    required VoidCallback onToggle,
    required Widget filho,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cor.primary.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      titulo,
                      style: TextStyle(
                        color: cor.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(
                    aberto ? Icons.expand_less : Icons.expand_more,
                    color: cor.primary,
                  ),
                ],
              ),
            ),
          ),
          if (aberto)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: filho,
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Card "Criação Automática" — N níveis dinâmicos (nome + quantidade)
  // ---------------------------------------------------------------------

  Widget _conteudoCriacaoAutomatica(ColorScheme cor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: cor.primary.withOpacity(0.3)),
        const SizedBox(height: 4),
        Text(
          'Definir níveis de hierarquia:',
          style: TextStyle(
            color: cor.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          'A ordem abaixo define a hierarquia (do nível 1, mais externo, ao mais interno).',
          style: TextStyle(color: cor.primary.withOpacity(0.6), fontSize: 11),
        ),
        const SizedBox(height: 14),
        ..._niveisAuto.asMap().entries.map((entry) {
          final indice = entry.key;
          final nivel = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nível ${indice + 1}',
                  style: TextStyle(
                    color: cor.primary.withOpacity(0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nivel.nomeController,
                        style: TextStyle(color: cor.onSecondary, fontSize: 13),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Ex: Bloco, Quarto...',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cor.primary, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cor.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ContadorNumero(
                      valor: nivel.quantidade,
                      onAumentar: () => setState(() => nivel.quantidade++),
                      onDiminuir: () => setState(() {
                        if (nivel.quantidade > 1) nivel.quantidade--;
                      }),
                    ),
                    if (_niveisAuto.length > 1) ...[
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _removerNivelAuto(nivel),
                        child: Icon(
                          Icons.delete_outline,
                          color: cor.primary.withOpacity(0.6),
                          size: 20,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          );
        }),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _adicionarNivelAuto,
            icon: Icon(Icons.add, color: cor.primary, size: 18),
            label: Text(
              'Adicionar Nível',
              style: TextStyle(color: cor.primary, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _aplicarCriacaoAutomatica,
            style: ElevatedButton.styleFrom(
              backgroundColor: cor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Aplicar', style: TextStyle(color: cor.onPrimary)),
          ),
        ),
      ],
    );
  }

  Widget _conteudoFvsPadroes(ColorScheme cor) {
    return Column(
      children: [
        Divider(color: cor.primary.withOpacity(0.3)),
        ..._fvs.entries.map(
          (entry) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: TextStyle(color: cor.primary, fontSize: 13),
              ),
              Checkbox(
                value: entry.value,
                activeColor: cor.primary,
                onChanged: (v) => setState(() => _fvs[entry.key] = v ?? false),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => setState(() => _secaoFvsAberta = false),
            icon: Icon(Icons.check, color: cor.primary, size: 18),
            label: Text(
              'Confirmar',
              style: TextStyle(color: cor.primary, fontSize: 13),
            ),
          ),
        ),
      ], 
    );
  }
}