import 'package:flutter/material.dart';


class BolinhasCarregamento extends StatefulWidget {
  @override
  _BolinhasCarregamentoState createState() => _BolinhasCarregamentoState();
}

class _BolinhasCarregamentoState extends State<BolinhasCarregamento>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animation = IntTween(begin: 0, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 
    final Color corPrimaria = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            bool isActive = _animation.value == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive 
                    ? corPrimaria 
                    : corPrimaria.withOpacity(0.3),
              ),
            );
          }),
        );
      },
    );
  }
}