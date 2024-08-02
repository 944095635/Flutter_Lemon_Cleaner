import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lemon_cleaner/page/home/home_page.dart';
import 'package:lemon_cleaner/widget/window_caption.dart';
import 'package:window_manager/window_manager.dart';

class FramePage extends StatefulWidget {
  const FramePage({super.key});

  @override
  State<FramePage> createState() => _FramePageState();
}

class _FramePageState extends State<FramePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Stack(
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
          // Lottie.asset(
          //   'images/3.json',
          //   fit: BoxFit.none,
          //   alignment: Alignment.bottomRight,
          // ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: 80,
              //color: Colors.amber,
              child: DragToMoveArea(
                child: SizedBox(),
              ),
            ),
          ),
          const HomePage(),
          // 手机才显示右侧的系统按钮
          if (Platform.isWindows || Platform.isMacOS) ...{
            Positioned(
              top: 26,
              right: 16,
              child: IconButton(
                onPressed: () {
                  windowManager.close();
                },
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedLogout04,
                  color: Color(0xFF94a0bd),
                ),
              ),
            ),
          }
        ],
      ),
    );
  }
}
