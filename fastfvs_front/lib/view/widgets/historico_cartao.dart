import 'package:flutter/material.dart';
 
class HistoricoCartao extends StatelessWidget {
  final String tipoAlteracao;
  final String dataAlteracao;
  final String usuario;
 
  const HistoricoCartao({
    super.key,
    required this.tipoAlteracao,
    required this.dataAlteracao,
    required this.usuario,
  });
 
  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 15,
      color: Color(0xff3C1E01),
    );
    const valueStyle = TextStyle(
      fontSize: 16,
      color: Color(0xff3C1E01),
      fontWeight: FontWeight.w500,
    );
 
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Tipo de Alteração:', tipoAlteracao, labelStyle, valueStyle),
          const SizedBox(height: 8),
          _buildRow('Data da Alteração:', dataAlteracao, labelStyle, valueStyle),
          const SizedBox(height: 8),
          _buildRow('Usuário:', usuario, labelStyle, valueStyle),
        ],
      ),
    );
  }
 
  Widget _buildRow(
    String label,
    String value,
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(label, style: labelStyle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(value, style: valueStyle),
        ),
      ],
    );
  }
}