import 'dart:ui';

import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  ShaderPainter({
    super.repaint,
    required this.shader,
    required this.shaderSize,
    required this.time,
  });

  final FragmentShader shader;
  final Size shaderSize;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, shaderSize.width);
    shader.setFloat(1, shaderSize.height);
    shader.setFloat(2, time);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, shaderSize.width, shaderSize.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) {
    return shader != oldDelegate.shader ||
        time != oldDelegate.time ||
        shaderSize != oldDelegate.shaderSize;
  }
}
