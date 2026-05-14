import 'package:flutter/material.dart';

class BotaoInputAcesso extends StatelessWidget {
  final String label;
  final String? hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const BotaoInputAcesso({
    super.key,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              filled: true,
              isDense: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              suffixIcon: suffixIcon,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}