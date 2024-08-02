import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_styled/radius_extension.dart';
import 'package:flutter_styled/size_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lemon_cleaner/model/chart_sample_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  /// 旋转动画控制器
  late AnimationController _controller;

  Timer? timer;

  //Cpu使用率
  int wave1 = 1;
  List<ChartSampleData>? chartData1;

  _HomePageState() {
    chartData1 = [];
    for (int i = 0; i < 30; i++) {
      chartData1!.add(ChartSampleData(x: i, y: 0));
    }
    wave1 = chartData1!.length;
    timer = Timer.periodic(const Duration(milliseconds: 550), _updateData);
  }

  void _updateData(Timer timer) async {
    if (mounted) {
      setState(() {
        chartData1!.removeAt(0);
        chartData1!
            .add(ChartSampleData(x: wave1, y: Random().nextInt(65) + 10)); // );
        wave1 = wave1 + 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      // 安卓只显示左侧盒子
      return buildLeftBox();
    }
    return Row(
      children: [
        SizedBox(
          width: 360,
          child: buildLeftBox(),
        ),
        Expanded(
          child: buildRightBox(),
        )
      ],
    );
  }

  // 左侧盒子
  Widget buildLeftBox() {
    //动画组件
    //畅快清理 · 清爽一下
    //欢迎使用Lemon Cleaner
    //开始扫描
    return Column(
      children: [
        40.verticalSpace,
        const Text(
          "Lemon Cleaner",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "ITCAvantGarde",
            color: Color(0xFFE5F0FF),
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 260,
          height: 260,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Lottie.asset(
              //   'images/12.json',
              // ),
              // WaveWidget(
              //   config: CustomConfig(
              //     colors: _colors,
              //     durations: _durations,
              //     heightPercentages: _heightPercentages,
              //   ),
              //   size: Size(double.infinity, double.infinity),
              //   waveAmplitude: 0,
              // ),

              RotationTransition(
                turns: _controller, // 使用 AnimationController 控制旋转
                child: Image.asset("images/sylops-symbol.png"),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "CPU",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFBEBEBE),
                      fontFamily: "ITCAvantGarde",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "98%",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Spacer(),
        const Text(
          "畅快清理 · 清爽一下",
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFFE5F0FF),
            fontWeight: FontWeight.w600,
          ),
        ),
        10.verticalSpace,
        const Text(
          "欢迎使用 Lemon Cleaner",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6D748F),
            fontWeight: FontWeight.w500,
          ),
        ),
        30.verticalSpace,
        //230*50
        SizedBox(
          width: 230,
          height: 50,
          child: FilledButton(
            style: ButtonStyle(
              backgroundBuilder: (context, states, child) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2B90CC),
                          Color(0xFF2D93CC),
                          Color(0xFF57C6CC),
                          Color(0xFF5FC9CA),
                        ],
                        stops: [
                          0,
                          0.3,
                          0.7,
                          1
                        ]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: child,
                );
              },
            ),
            onPressed: () {},
            child: const Text(
              "开始扫描",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFE2F4F6),
              ),
            ),
          ),
        ),
        80.verticalSpace,
      ],
    );
  }

  /// 右侧区域
  Widget buildRightBox() {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 50),
      // 2行，3*3的格子 第一行2份行 第二行1份行
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          24.verticalSpace,
          Row(
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "下午好，",
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF94a0bd),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Dream.Machine",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "ITCAvantGarde",
                      color: Color(0xFF94a0bd),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const SizedBox(
                width: 320,
                child: TextField(
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0x888a94b1),
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.amber,
                    fillColor: Color(0xFF30344a),
                    filled: true,
                    hintText: "输入功能，文件内容，联系人进行搜索",
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0x888a94b1),
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hoverColor: Colors.transparent,
                    suffixIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSearch01,
                      color: Color(0xFF626576),
                      size: 16,
                    ),
                  ),
                ),
              ),
              40.horizontalSpace,
            ],
          ),
          30.verticalSpace,
          Flexible(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(
                        child: buildDataCard(
                          name: "系统安全",
                          tips: "系统扫描",
                          image: "images/Security.svg",
                        ),
                      ),
                      20.verticalSpace,
                      Expanded(
                        child: buildDataCard(
                          name: "相册优化",
                          tips: "20个相似文件",
                          image: "images/picture.svg",
                        ),
                      ),
                    ],
                  ),
                ),
                20.horizontalSpace,
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: buildDataCard(
                          name: "文件清理",
                          tips: "1236个垃圾文件",
                          image: "images/folder.svg",
                        ),
                      ),
                      20.verticalSpace,
                      Expanded(
                        child: buildDataCard(
                          name: "保险箱",
                          tips: "保护您的隐私安全",
                          image: "images/suitcase.svg",
                        ),
                      ),
                    ],
                  ),
                ),
                20.horizontalSpace,
                Flexible(
                  flex: 2,
                  child: buildImageCard(),
                )
              ],
            ),
          ),
          20.verticalSpace,
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: buildDataCard(
                    name: "我的钱包",
                    tips: "资产安全",
                    image: "images/wallet.svg",
                    showButton: false,
                  ),
                ),
                20.horizontalSpace,
                Flexible(
                  child: buildDataCard(
                    name: "吐个槽",
                    tips: "提出宝贵的建议",
                    image: "images/chat.svg",
                    showButton: false,
                  ),
                ),
                20.horizontalSpace,
                Flexible(
                  flex: 2,
                  child: buildChart(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// PC信息列
  Widget buildPCInfo({
    required String name,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF76849f),
          ),
        ),
        6.verticalSpace,
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: "ITCAvantGarde",
            fontWeight: FontWeight.bold,
            color: Color(0xFFb0bcd7),
          ),
        )
      ],
    );
  }

  /// 宣传图卡片
  Widget buildImageCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFC48FD9),
            Color(0xFFC591D7),
            Color(0xFFDEADB8),
            Color(0xFFEBBDA7),
          ],
          stops: [0, 0.2, 0.6, 1],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -160,
            bottom: -180,
            child: SvgPicture.asset(
              "images/saly.svg",
              fit: BoxFit.cover,
              width: 440,
              height: 440,
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 56,
            child: Column(
              children: [
                Text(
                  "柠檬精选",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "发现更多优质应用",
                  style: TextStyle(
                    color: Color(0xFFEAEAEA),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 右侧每一个卡片的基类
  Widget buildDataCard({
    required String name,
    required String tips,
    required String image,
    bool showButton = true,
  }) {
    return buildAeroCard(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 4,
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                image,
                height: 60,
                //抗锯齿
                //isAntiAlias: true,
              ),
              if (showButton) ...{
                IconButton(
                  onPressed: () {},
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedMoreVertical,
                    color: Color(0xFFA5B6D7),
                  ),
                ),
              }
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //工具名称
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFA5B6D7),
                  ),
                ),
                4.verticalSpace,
                //提示信息
                Text(
                  tips,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 136, 151, 179),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Aero 盒子
  Widget buildAeroCard({
    required Widget child,
    EdgeInsets? padding,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: 10.borderRadius,
        color: const Color(0x0AFFFFFF),
      ),
      child: child,
    );
  }

  Widget buildChart() {
    return buildAeroCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "系统状况",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA5B6D7),
            ),
          ),
          Expanded(
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: const NumericAxis(
                isVisible: false,
                decimalPlaces: 0,
              ),
              primaryYAxis: const NumericAxis(
                isVisible: false,
                maximum: 100,
              ),
              series: _getLiveUpdateSeries(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildPCInfo(name: "CPU温度", value: "48℃"),
              buildPCInfo(name: "CPU占用", value: "98%"),
              buildPCInfo(name: "风扇", value: "1186R"),
              buildPCInfo(name: "磁盘", value: "2/8 TB"),
            ],
          ),
        ],
      ),
    );
  }

  //图表数据
  List<SplineSeries<ChartSampleData, num>> _getLiveUpdateSeries() {
    return <SplineSeries<ChartSampleData, num>>[
      SplineSeries<ChartSampleData, num>(
        dataSource: [...chartData1!],
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        animationDuration: 0,
        splineType: SplineType.cardinal,
      ),
      // SplineSeries<ChartSampleData, num>(
      //   dataSource: [...chartData2!],
      //   xValueMapper: (ChartSampleData sales, _) => sales.x as num,
      //   yValueMapper: (ChartSampleData sales, _) => sales.y,
      //   animationDuration: 0,
      // )
    ];
  }
}
