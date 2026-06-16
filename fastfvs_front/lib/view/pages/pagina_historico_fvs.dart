import 'package:fastfvs_front/view/pages/pagina_base.dart';
import 'package:fastfvs_front/view/widgets/historico_cartao.dart';
import 'package:flutter/material.dart';

class PaginaHistoricoFVS extends StatelessWidget {
  const PaginaHistoricoFVS({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      paginaAberta: 0,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'FVS - Hidráulica',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff3C1E01),
              ),
            ),
            const SizedBox(height: 20),
            const HistoricoCartao(
              tipoAlteracao: 'Criação',
              dataAlteracao: '13/04/2006 - 21:33',
              usuario: 'Pedro Vitor',
            ),
            const SizedBox(height: 16),
            const HistoricoCartao(
              tipoAlteracao: 'Edição',
              dataAlteracao: '14/04/2006 - 01:13',
              usuario: 'João Marcelo',
            ),
            const SizedBox(height: 16),
            const HistoricoCartao(
              tipoAlteracao: 'Edição',
              dataAlteracao: '16/04/2006 - 12:54',
              usuario: 'João Marcelo',
            ),
            const SizedBox(height: 16),
            const HistoricoCartao(
              tipoAlteracao: 'Edição',
              dataAlteracao: '16/04/2006 - 12:54',
              usuario: 'João Marcelo',
            ),
            const SizedBox(height: 16),
            const HistoricoCartao(
              tipoAlteracao: 'Edição',
              dataAlteracao: '16/04/2006 - 12:54',
              usuario: 'João Marcelo',
            ),
          ],
        ),
      ),
    );
  }
}