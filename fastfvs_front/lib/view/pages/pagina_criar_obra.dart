import 'package:fastfvs_front/view/widgets/contador_numero.dart';
import 'package:flutter/material.dart';

class _Subsecao {
  String nome;
  List<_Subsecao> filhos;
  _Subsecao({required this.nome, List<_Subsecao>? filhos})
    : filhos = filhos ?? [];
}

class PaginaCriarObra extends StatefulWidget {
  const PaginaCriarObra({super.key});

  @override
  State<PaginaCriarObra> createState() => _PaginaCriarObraState();
}

class _PaginaCriarObraState extends State<PaginaCriarObra> {
  final TextEditingController _nomeController = TextEditingController();

  List<_Subsecao> _blocos = [];
  final Set<_Subsecao> _expandidos = {};

  bool _secaoCriacaoAberta = false;
  bool _secaoFvsAberta = false;

  int _numBlocos = 1;
  int _numPavimentos = 1;
  int _numApts = 1;
  int _numeracaoInicio = 1;
  int _numeracaoFim = 1;

  final Map<String, bool> _fvs = {
    'FVS - Hidráulica': false,
    'FVS - Azulejo': false,
    'FVS - Concretagem': false,
    'FVS - Aviamento': false,
    'FVS - Pintura': false,
    'FVS - Instalação Elétrica': false,
    'FVS - Piso': false,
  };

  void _aplicarCriacaoAutomatica() {
    setState(() {
      _blocos = List.generate(_numBlocos, (b) {
        return _Subsecao(
          nome: 'Bloco ${String.fromCharCode(65 + b)}',
          filhos: List.generate(_numPavimentos, (p) {
            return _Subsecao(
              nome: 'Pav ${p + 1}',
              filhos: List.generate(_numApts, (a) {
                final num = _numeracaoInicio + (p * _numApts) + a;
                return _Subsecao(nome: 'Apt $num');
              }),
            );
          }),
        );
      });
      _expandidos.clear();
      _secaoCriacaoAberta = false;
    });
  }

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
              fixedSize: const Size(110, 40),
              side: BorderSide(color: cor.primary, width: 2),
            ),
            child: const Text('Confirmar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFF6D6D),
              foregroundColor: cor.onSecondary,
              fixedSize: const Size(110, 40),
              side: BorderSide(color: cor.primary, width: 2),
            ),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _adicionarBloco() {
    _abrirDialogoNome(
      titulo: 'Nome do Bloco',
      valorInicial: 'Bloco ${String.fromCharCode(65 + _blocos.length)}',
      onConfirmar: (nome) {
        if (nome.isNotEmpty) setState(() => _blocos.add(_Subsecao(nome: nome)));
      },
    );
  }

  void _editarBloco(_Subsecao bloco) {
    _abrirDialogoNome(
      titulo: 'Editar Bloco',
      valorInicial: bloco.nome,
      onConfirmar: (nome) {
        if (nome.isNotEmpty) setState(() => bloco.nome = nome);
      },
    );
  }

  void _adicionarPavimento(_Subsecao bloco) {
    _abrirDialogoNome(
      titulo: 'Nome do Pavimento',
      valorInicial: 'Pav ${bloco.filhos.length + 1}',
      onConfirmar: (nome) {
        if (nome.isNotEmpty) {
          setState(() => bloco.filhos.add(_Subsecao(nome: nome)));
          _expandidos.add(bloco);
        }
      },
    );
  }

  void _editarPavimento(_Subsecao pav) {
    _abrirDialogoNome(
      titulo: 'Editar Pavimento',
      valorInicial: pav.nome,
      onConfirmar: (nome) {
        if (nome.isNotEmpty) setState(() => pav.nome = nome);
      },
    );
  }

  void _adicionarApt(_Subsecao pav) {
    _abrirDialogoNome(
      titulo: 'Nome do Apartamento',
      valorInicial: 'Apt ${pav.filhos.length + 1}',
      onConfirmar: (nome) {
        if (nome.isNotEmpty) {
          setState(() => pav.filhos.add(_Subsecao(nome: nome)));
          _expandidos.add(pav);
        }
      },
    );
  }

  void _editarApt(_Subsecao apt) {
    _abrirDialogoNome(
      titulo: 'Editar Apartamento',
      valorInicial: apt.nome,
      onConfirmar: (nome) {
        if (nome.isNotEmpty) setState(() => apt.nome = nome);
      },
    );
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

  void _finalizar() {
    if (!_validar()) return;
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

  Widget _cardEstrutura(ColorScheme cor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: cor.primary.withOpacity(0.35)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (_blocos.isEmpty)
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
          ..._blocos.map((bloco) => _blocoWidget(cor, bloco)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _adicionarBloco,
              icon: Icon(Icons.add, color: cor.primary, size: 18),
              label: Text(
                'Adicionar Bloco',
                style: TextStyle(color: cor.primary, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blocoWidget(ColorScheme cor, _Subsecao bloco) {
    final expandido = _expandidos.contains(bloco);
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(
                () => expandido
                    ? _expandidos.remove(bloco)
                    : _expandidos.add(bloco),
              ),
              child: Icon(
                expandido ? Icons.expand_more : Icons.chevron_right,
                color: cor.primary,
              ),
            ),
            Icon(Icons.view_module, color: cor.primary, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(bloco.nome, style: TextStyle(color: cor.primary)),
            ),
            GestureDetector(
              onTap: () => _editarBloco(bloco),
              child: Icon(Icons.edit, color: cor.primary, size: 18),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _adicionarPavimento(bloco),
              child: Icon(Icons.add, color: cor.primary, size: 20),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => setState(() {
                _blocos.remove(bloco);
                _expandidos.remove(bloco);
              }),
              child: Icon(
                Icons.delete_outline,
                color: cor.primary.withOpacity(0.6),
                size: 18,
              ),
            ),
          ],
        ),
        if (expandido)
          ...bloco.filhos.map((pav) => _pavimentoWidget(cor, bloco, pav)),
      ],
    );
  }

  Widget _pavimentoWidget(ColorScheme cor, _Subsecao bloco, _Subsecao pav) {
    final expandido = _expandidos.contains(pav);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(
                  () => expandido
                      ? _expandidos.remove(pav)
                      : _expandidos.add(pav),
                ),
                child: Icon(
                  expandido ? Icons.expand_more : Icons.chevron_right,
                  color: cor.primary,
                ),
              ),
              Icon(Icons.layers, color: cor.primary, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(pav.nome, style: TextStyle(color: cor.primary)),
              ),
              GestureDetector(
                onTap: () => _editarPavimento(pav),
                child: Icon(Icons.edit, color: cor.primary, size: 18),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _adicionarApt(pav),
                child: Icon(Icons.add, color: cor.primary, size: 20),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => setState(() {
                  bloco.filhos.remove(pav);
                  _expandidos.remove(pav);
                }),
                child: Icon(
                  Icons.delete_outline,
                  color: cor.primary.withOpacity(0.6),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        if (expandido) ...pav.filhos.map((apt) => _aptWidget(cor, pav, apt)),
      ],
    );
  }

  Widget _aptWidget(ColorScheme cor, _Subsecao pav, _Subsecao apt) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Row(
        children: [
          Icon(Icons.chevron_right, color: cor.primary),
          Icon(Icons.door_front_door, color: cor.primary, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(apt.nome, style: TextStyle(color: cor.primary)),
          ),
          GestureDetector(
            onTap: () => _editarApt(apt),
            child: Icon(Icons.edit, color: cor.primary, size: 18),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => pav.filhos.remove(apt)),
            child: Icon(
              Icons.delete_outline,
              color: cor.primary.withOpacity(0.6),
              size: 18,
            ),
          ),
        ],
      ),
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

  Widget _conteudoCriacaoAutomatica(ColorScheme cor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: cor.primary.withOpacity(0.3)),
        const SizedBox(height: 4),
        Text(
          'Definir padrão de:',
          style: TextStyle(
            color: cor.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 14),
        _linhaContador(
          cor,
          'N° de Blocos:',
          _numBlocos,
          () => setState(() => _numBlocos++),
          () => setState(() {
            if (_numBlocos > 1) _numBlocos--;
          }),
        ),
        const SizedBox(height: 10),
        _linhaContador(
          cor,
          'Pavimentos por Bloco:',
          _numPavimentos,
          () => setState(() => _numPavimentos++),
          () => setState(() {
            if (_numPavimentos > 1) _numPavimentos--;
          }),
        ),
        const SizedBox(height: 10),
        _linhaContador(
          cor,
          'Apts por Pavimento:',
          _numApts,
          () => setState(() => _numApts++),
          () => setState(() {
            if (_numApts > 1) _numApts--;
          }),
        ),
        const SizedBox(height: 18),
        Text(
          'Padrão de Numeração:',
          style: TextStyle(
            color: cor.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ContadorNumero(
              valor: _numeracaoInicio,
              onAumentar: () => setState(() => _numeracaoInicio++),
              onDiminuir: () => setState(() {
                if (_numeracaoInicio > 1) _numeracaoInicio--;
              }),
            ),
            Text('a', style: TextStyle(color: cor.primary, fontSize: 16)),
            ContadorNumero(
              valor: _numeracaoFim,
              onAumentar: () => setState(() => _numeracaoFim++),
              onDiminuir: () => setState(() {
                if (_numeracaoFim > 1) _numeracaoFim--;
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
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

  Widget _linhaContador(
    ColorScheme cor,
    String label,
    int valor,
    VoidCallback onAumentar,
    VoidCallback onDiminuir,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: cor.primary, fontSize: 13)),
        ContadorNumero(
          valor: valor,
          onAumentar: onAumentar,
          onDiminuir: onDiminuir,
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
