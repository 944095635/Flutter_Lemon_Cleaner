import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lemon_cleaner/page/clean/clean_page.dart';
import 'package:lemon_cleaner/page/home/home_page.dart';
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
      //backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Lottie.asset(
          //   'images/3.json',
          //   fit: BoxFit.none,
          //   alignment: Alignment.bottomRight,
          // ),
          // Lottie.asset(
          //   'images/3.json',
          // ),
          //  Positioned(
          //   left: 0,
          //   right: 0,
          //   top: 0,
          //   child: Container(
          //     height: 80,
          //     color: Colors.amber,
          //     child: DragToMoveArea(
          //       child: SizedBox(),
          //     ),
          //   ),
          // ),
          Navigator(
            key: Get.nestedKey(1),
            initialRoute: '/home',
            onGenerateRoute: onGenerateRoute,
          ),
          // 手机才显示右侧的系统按钮
          if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) ...{
            Positioned(
              top: 26,
              right: 16,
              child: IconButton(
                onPressed: () {
                  windowManager.close();
                },
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedLogout04,
                  color: Color(0xFF94a0bd),
                ),
              ),
            ),
          },
        ],
      ),
    );
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/home') {
      return GetPageRoute(
        settings: settings,
        page: () => const HomePage(),
        transition: Transition.topLevel,
      );
    } else if (settings.name == '/clean') {
      return GetPageRoute(
        settings: settings,
        page: () => const CleanPage(),
        transition: Transition.rightToLeftWithFade,
      );
    }
    return null;
  }
}
