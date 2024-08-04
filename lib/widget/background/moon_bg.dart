import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lemon_cleaner/utils/shader_painter.dart';

/// 月亮卡片背景
class MoonBgWidget extends StatefulWidget {
  const MoonBgWidget({super.key});

  @override
  State<MoonBgWidget> createState() => _MoonBgWidgetState();
}

class _MoonBgWidgetState extends State<MoonBgWidget>
    with TickerProviderStateMixin {
  Ticker? _ticker;
  FragmentProgram? shaderProgram;
  final ValueNotifier<double> _elapsedTime = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 3),
    // );
    init();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void init() async {
    final moonShaderProgram = await FragmentProgram.fromAsset(
        'assets/shaders/moon.frag');
    // final gameShaderProgram = await FragmentProgram.fromAsset(
    //     'assets/shaders/spherical_polyhedra.frag');
    // final glowingShaderProgram =
    //     await FragmentProgram.fromAsset('assets/shaders/neon_lines.frag');
    // final bubbleShaderProgram =
    //     await FragmentProgram.fromAsset('assets/shaders/bubble_ring.frag');

    // final test = await FragmentProgram.fromAsset('assets/shaders/test.frag');

    shaderProgram = moonShaderProgram;
    setState(() {});
    _ticker = createTicker(_onTick)..start();
    //Timer.periodic(Duration(milliseconds: 50), _onTick);
  }

  void _onTick(Duration elapsed) {
    debugPrint("触发:${_elapsedTime.value}");
    _elapsedTime.value = _elapsedTime.value + 0.004;
  }

  @override
  Widget build(BuildContext context) {
    if (shaderProgram == null) {
      return const SizedBox();
    } else {
      return ClipPath(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ValueListenableBuilder<double>(
              valueListenable: _elapsedTime,
              builder: (context, value, child) {
                return CustomPaint(
                  painter: ShaderPainter(
                    shader: shaderProgram!.fragmentShader(),
                    shaderSize:
                        Size(constraints.maxWidth, constraints.maxHeight),
                    time: value,
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
}
