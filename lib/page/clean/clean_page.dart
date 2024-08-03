import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_styled/radius_extension.dart';
import 'package:flutter_styled/size_extension.dart';
import 'package:lemon_cleaner/widget/background/background.dart';
import 'package:window_manager/window_manager.dart';

class CleanPage extends StatefulWidget {
  const CleanPage({super.key});

  @override
  State<CleanPage> createState() => _CleanPageState();
}

class _CleanPageState extends State<CleanPage>
    with SingleTickerProviderStateMixin {
  Ticker? _ticker;
  FragmentProgram? shaderProgram;
  final ValueNotifier<double> _elapsedTime = ValueNotifier(0.0);

  //late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 3),
    // );
    init();
  }

  void init() async {
    final moonShaderProgram = await FragmentProgram.fromAsset(
        'assets/shaders/atmospheric_scattering.frag');
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
  }

  @override
  void dispose() {
    _ticker?.dispose();
    //_animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (shaderProgram == null) ...{
            const SizedBox(),
          } else ...{
            ValueListenableBuilder<double>(
                valueListenable: _elapsedTime,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: 1,
                    child: CustomPaint(
                      painter: ShaderPainter(
                        shader: shaderProgram!.fragmentShader(),
                        shaderSize: MediaQuery.of(context).size,
                        time: value,
                      ),
                    ),
                  );
                })
          },
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Lemon Cleaner",
                  style: TextStyle(
                    fontSize: 86,
                    fontFamily: "ITCAvantGarde",
                    color: Color(0xFFE5F0FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              80.verticalSpace,
              GestureDetector(
                onTap: () {
                  _ticker?.stop();
                  // _animationController.reset();
                  // _animationController.forward();
                  _ticker?.start();
                },
                child: Container(
                  width: 230,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.3),
                    borderRadius: 10.borderRadius,
                  ),
                  child: const Center(
                    child: Text(
                      "开始扫描",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFE2F4F6),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SizedBox(
              height: 80,
              //color: Colors.amber,
              child: DragToMoveArea(
                child: SizedBox(),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: BackButton(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _onTick(Duration elapsed) {
    _elapsedTime.value = _elapsedTime.value + 0.02;
  }
}

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
    canvas.drawColor(Colors.white, BlendMode.color);

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
