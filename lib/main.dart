import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ravasiya_collections/routes/app_pages.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:ravasiya_collections/utils/pref_data.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'controller/controller.dart';
import 'generated/l10n.dart';




Future<void> init() async {
  Get.lazyPut(() => LoginEmptyStateController());
  Get.lazyPut(() => HomeMainScreenController());
  Get.lazyPut(() => ProductDataController());
  Get.lazyPut(() => HomeScreenController());
}

bool isNetwork = false;

Future<void> main() async {
  await init();
  await GetStorage.init();
  Stripe.publishableKey = Constant.stripPublishKey;
  Stripe.instance.applySettings();
  await PrefData().init();

  isNetwork = await isInternetConnected();
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..userInteractions = true
    ..dismissOnTap = false;
}

RxString lnCode = "en".obs;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
  }

  getValue() async {
    lnCode.value = PrefData().getAppLanguage();
    S.load(Locale(lnCode.value));
    lnCode.refresh();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBar();
    initializeScreenSize(context);
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      // overlayWidget: getProgressDialog(),
      overlayColor: Colors.transparent,
      // overlayOpacity: 0,
      closeOnBackButton: true,
      disableBackButton: true,
      child: GetBuilder(
        init: SelectLanguagesScreenController(),
        builder: (controller) {
          return GetMaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate,
            ],
            locale: Locale(lnCode.value),
            supportedLocales: S.delegate.supportedLocales,
            theme: ThemeData(
                visualDensity: VisualDensity.standard,
                useMaterial3: true,
                dialogBackgroundColor: regularWhite,
                dialogTheme: DialogTheme(
                    backgroundColor: regularWhite,
                    surfaceTintColor: regularWhite),
                dropdownMenuTheme: DropdownMenuThemeData(
                    inputDecorationTheme:
                        InputDecorationTheme(fillColor: regularWhite)),
                elevatedButtonTheme: ElevatedButtonThemeData()),
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            initialRoute: "/",
            onGenerateRoute: (settings) {
              return AppPages.routesFactory(settings);
            },
          );
        },
      ),
    );
  }
}
