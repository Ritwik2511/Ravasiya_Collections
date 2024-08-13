import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/routes/app_routes.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:ravasiya_collections/utils/pref_data.dart';

import 'controller/controller.dart';
import 'datafile/model_data.dart';
import 'model/language_model.dart';

class AppSplashScreen extends StatefulWidget {
  static String tag = '/';
  final String routeName;

  AppSplashScreen({this.routeName = "/"});

  @override
  _AppSplashScreenState createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen>
    with TickerProviderStateMixin {
  AnimationController? scaleController;
  Animation<double>? scaleAnimation;

  bool secondAnim = false;

  HomeMainScreenController putHomeController =
      Get.put(HomeMainScreenController());
  HomeMainScreenController homeFindScreenController =
      Get.find<HomeMainScreenController>();
  ProductDataController productDataController =
      Get.put(ProductDataController());

  List<LanguageData> langList = Data.getLanguage();
  SelectLanguagesScreenController selectLanguagesScreenController1 =
      Get.put(SelectLanguagesScreenController());

  Color boxColor = Colors.transparent;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await Future.delayed(Duration.zero);
    if (ModalRoute.of(context)!.settings.arguments != null) {
      HomeMainScreenController homeController =
          Get.find<HomeMainScreenController>();
      homeController.change(0);
      Get.toNamed(Routes.homeMainRoute);
      return;
    }
    productDataController
        .getCountrieList(homeMainScreenController.wooCommerce1!);

    if (ModalRoute.of(context)!.settings.arguments != null) {
      HomeMainScreenController homeController =
          Get.find<HomeMainScreenController>();
      homeController.change(0);
      Get.toNamed(Routes.homeMainRoute);
    } else {
      bool isSignIn = PrefData.getIsSignIn();

      bool isIntro = PrefData.getIsIntro();

      await Future.delayed(Duration.zero);

      Timer(const Duration(seconds: 2), () {
        if (isIntro) {
          Get.toNamed(Routes.onBoardingRoute);
        } else {
          if (isSignIn) {
            putHomeController.changeIsLogin(false);
            Get.toNamed(Routes.loginRoute);
          } else {
            Get.toNamed(Routes.homeMainRoute);
          }
        }
      });
    }
    // });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: regularWhite,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child:
              getAssetImage(Constant.splashLogo, height: 177.h, width: 179.h),
        ),
        // child: ,
      ),
    );
  }
}
