import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF302F43),
                Color(0xFF43556E),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: -420,
          child: SvgPicture.asset(
            "images/bg_mask.svg",
            fit: BoxFit.cover,
            width: 1200,
            height: 1200,
          ),
        ),
        child,
      ],
    );
  }
}
