import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:ravasiya_collections/utils/symbol_position_enums.dart';
import 'package:ravasiya_collections/view/item_category_class/plant_detail_screen.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:lottie/lottie.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/controller.dart';
import '../main.dart';
import '../model/slider_data.dart';
import '../woocommerce/models/customer.dart';

double parseWcPrice(String? price) => (double.tryParse(price ?? "0") ?? 0);
String lottieAnimation = "asset/data.json";
String loadingAnimation = "asset/images/loading_animation.json";
String successAnimation = "asset/success.json";
SymbolPositionType appCurrencySymbolPosition = SymbolPositionType.left;
const String colorVariation = "color";

setStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: regularWhite,
      statusBarIconBrightness:
          Platform.isIOS ? Brightness.light : Brightness.dark,
      statusBarBrightness: Platform.isIOS ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.light));
}

class Constant {
  // static String webUrl =
  //     "https://devsite.clientdemoweb.com/plantshop"; // replace your website url
  // static String consumerKey = "ck_7d1e5e8f0c8c3f951f7387162a531bf87736b078";
  // static String consumerSecret = "cs_b463789c65f10cb4438d2ed336c2afa7459f2938";

  static String webUrl = "https://ravasiya.in";
  static String consumerKey = "ck_257d2e3c86dd934d6ee0753169fbba651dd2385f";
  static String consumerSecret = "cs_1a7214ddf1e8b5cc888738a2c9accd57416d8784";

  static String orderConfirmUrl = '${webUrl}/checkout/order-received/';
  static String contactUsUrl = "${webUrl}/contact-us/";
  static String forgotUrl = "${webUrl}/my-account/lost-password/";
  static String privacyPolicyUrl = "${webUrl}/privacy-policy/";
  static String aboutUsPolicyUrl = "${webUrl}/about-us/";
  static String termsAndConditionUrl = "https://www.google.com/";
  static String assetImagePath = "asset/images/";
  static const String fontsFamily = "SF Pro Display";
  static const double defScreenWidth = 414;
  static const double defScreenHeight = 896;
  static const int randomCategoryId = 27;
  static const bool isEnable = true;

  // Bottombar Icon
  static String homefillIcon = "homefillIcon.svg";
  static String homeIcon = "homeIcon.svg";
  static String categoryFillIcon = "category_fill_icon.svg";
  static String categoryIcon = "category_icon.svg";
  static String cartFillIcon = "cartfillIcon.svg";
  static String cartBgIcon = "cartbagIcon.svg";
  static String profileFillIcon = "profilefillIcon.svg";
  static String profileIcon = "profileIcon.svg";

  //Slider List
  static List<SliderData> getSlider() {
    return [
      SliderData("banner_new_custum_1st.png", Color(0xFF6B5D0F)),
      SliderData("banner_new_custum.png", Color(0xFFFFBA74)),
      SliderData("banner_new_custum_3rd.png", Color(0xFFE94293)),
    ];
  }

  static List<Color> getCouponColor() {
    return [Color(0xFFE5EED7), Color(0xFFFFE9ED), Color(0xFFB2FAE4)];
  }

  Widget animation_function(index, child,
      {Duration? listAnimation,
      Duration? slideduration,
      Duration? slidedelay}) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: listAnimation ?? Duration(milliseconds: 375),
      child: SlideAnimation(
        duration: slideduration ?? Duration(milliseconds: 50),
        delay: slidedelay ?? Duration(milliseconds: 50),
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }

  // Checknox Icon
  static String checkBoxFillIcon = "cheak_button_fill.svg";
  static String checkBoxIcon = "cheak_button.svg";

  // RadioButton Icon
  static String radioFillIcon = "radio_fill.svg";
  static String radioButtonIcon = "radio_button.svg";

  // Empry Screen Logo
  static String noAddressLogo = "no_add_img.svg";
  static String noProductLogo = "no_product.svg";
  static String searchEmptyLogo = "search_empty.png";
  static String cartEmptyLogo = "no_cart_image.svg";
  static String emptyOrderLogo = "no_order_icon.svg";
  static String wishlistEmptyLogo = "no_favourite_item_logo.svg";
  static String emptyCoupanIcon = "coupon_icon.svg";
  static String orderConfirmIcon = "order_confirm.svg";
  static String thankyouIcon = "thank_you_icon.svg";

  static String splashLogo = "logo.png";
  static String rateUsPng = "rateUs.png";

  static String myCartProcessIconFill = "my_cart_process_fill.svg";
  static String paymentProcessIconFill = "payment_process_fill.svg";
  static String paymentProcessIconUnFill = "payment_process_un_fill.svg";
  static String line = "line_un_fill.svg";
  static String lineFill = "line_fill.svg";

  static String locationIcon = "location_icon.svg";

  // razor pay
  static String razorpayid = 'rzp_test_ok0kwBL8IaZKjs';

  //SSLCommerz Settings
  static const String storeId = 'maant62a8633caf4a3';
  static const String storePassword = 'maant62a8633caf4a3@ssl';
  static const bool sslSandbox = true;

  //Flutterwave Settings
  static String flutterwavePublicKey =
      'FLWPUBK_TEST-4732c2ce170b45e83b30bc30ea5d9385-X';
  static String flutterwaveSecretKey =
      'FLWSECK_TEST-9f5e80c70de84afa41bd6bba7626d897-X';
  static String flutterwaveEncryptionKey = 'FLWSECK_TEST6bc8eaceedfa';
  static String flutterwaveCurrency = 'ZAR';

  //Paypal Key
  static String paypalClientId =
      'ATKxCBB49G3rPw4DG_0vDmygbZeFKubzub7jGWpeUW5jzfElK9qOzqJOfrBTYvS7RuIhoPdWHB4DIdLJ';
  static String paypalClientSecret =
      'EIDqVfraXlxDBMnswmhqP2qYv6rr_KPDgK269T-q1K9tB455OpPL_fc65irFiPBpiVXcoOQwpKqU3PAu';
  static bool sandbox = true;
  static String paypalCurrency = 'USD';

  //Stripe Key
  static String stripPublishKey = "pk_test_kGEVXq7ga94dcLBUZJbdQu9500lLQ5lcyQ";
  static String stripSecretKey = "sk_test_utRGU4wkG19w3o3dCsu4N42b00hRPKIwiJ";

  static bool isDirectionRTL(BuildContext context) {
    return lnCode.value == "ar" || lnCode.value == "he" ? true : false;
  }

  static ui.TextDirection getSetDirection(BuildContext context) {
    return isDirectionRTL(context)
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;
  }

  static Color getOrderStatusColor(String status, BuildContext context) {
    switch (status) {
      case "pending":
        return "#F1A80F".toColor();
      /*

        */
      case "processing":
        return "#B963BE".toColor();
      case "on-hold":
        return "#FBBB00".toColor();
      case "Delivered":
        return "#04B155".toColor();
      case "cancelled":
        return "#FC0A15".toColor();
      case "refunded":
        return "#FBBB00".toColor();
      case "failed":
        return "#FF6565".toColor();
      case "trash":
        return "#FBBB00".toColor();
    }
    return '#58B694'.toColor();
  }

  static String getPaymentImage(String id) {
    switch (id) {
      case "cod":
        return "money.png";
      case "stripe":
        return "stripe.png";
      case "ppcp-gateway":
        return "paypal.png";
      case "razorpay":
        return "razorpay.png";
      case "sslcommerz":
        return "ssl.png";
      case "tbz_rave":
        return "flutterwave_logo.png";
    }
    return "webview_logo.png";
  }

  static String getPaymentString(String id) {
    switch (id) {
      case "cod":
        return "Cash on delivery";
      case "stripe":
        return "Stripe";
      case "ppcp-gateway":
        return "PayPal";
      case "razorpay":
        return "Razorpay";
      case "sslcommerz":
        return "SSLCommerz";
      case "tbz_rave":
        return "Flutterwave";
    }
    return id;
    // return "Webview";
  }
}

bool isValidEmail(
  String? inputString, {
  bool isRequired = false,
}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;
}

Future<String> getCountriesISO(String con) async {
  var countries = await getResponse() as List;
  for (int i = 0; i < countries.length; i++) {
    String name = countries[i]['name'];
    if (name == con) {
      return countries[i]['code'].toString().toUpperCase();
    }
  }
  return "";
}

Future<dynamic> getResponse() async {
  var res = await rootBundle.loadString('asset/country.json');
  return jsonDecode(res);
}

backToPrev(BuildContext context) {
  // Navigator.of(context).pop();
  Get.back();
}

getDelayFunction(Function function) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    // make pop action to next cycle
    function();
  });
}

initializeScreenSize(BuildContext context,
    {double width = 414, double height = 896}) {
  ScreenUtil.init(context, designSize: Size(width, height), minTextAdapt: true);
}

String formatStringCurrency(
    {required String? total, required BuildContext context}) {
  double tmpVal = 0;
  if (total != null && total != "") {
    tmpVal = parseWcPrice(total);
  }
  return moneyFormatter(tmpVal, context);
  return "\$${tmpVal.toStringAsFixed(2)}";
}

String moneyFormatter(double amount, BuildContext context) {
  return getCurrency(context) + amount.toStringAsFixed(2);
  // MoneyFormatter fmf = MoneyFormatter(
  //   amount: amount,
  //   settings: MoneyFormatterSettings(
  //     symbol: getCurrency(context),
  //   ),
  // );
  // if (appCurrencySymbolPosition == SymbolPositionType.left) {
  //   return fmf.output.symbolOnLeft;
  // } else if (appCurrencySymbolPosition == SymbolPositionType.right) {
  //   return fmf.output.symbolOnRight;
  // }
  // return fmf.output.symbolOnLeft;
}

getCurrency(BuildContext context) {
  HomeMainScreenController homeMainScreenController =
      Get.put(HomeMainScreenController());
  var unescape = HtmlUnescape();
  String currency = "";
  if (homeMainScreenController.wooCurrentCurrency != null) {
    currency = homeMainScreenController.wooCurrentCurrency!.symbol ?? "";
  }
  return unescape.convert(currency);
}

void showCustomToast(String texts) {
  Fluttertoast.showToast(
      msg: texts,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 12.sp);
}

bool isShowDialog = false;
bool isSignup = false;
bool isLogin = false;

showCloseDialog(BuildContext context) async {
  if (!isShowDialog) {
    isShowDialog = true;
    Get.dialog(
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  height: 100.h,
                  width: 100.h,
                  padding: EdgeInsets.all(20.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10.h)),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                      ]),
                ),
              ),
            ),
            barrierDismissible: true)
        .then((value) {
      isShowDialog = false;
    });
  }
}

Widget getCircleImageProfile(BuildContext context, String imgName, double size,
    {bool fileImage = false}) {
  if (fileImage) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          child: (fileImage)
              ? material.Image.file(File(imgName))
              : Image.network(imgName)),
    );
  } else {
    return getCircleProfileImage(context, imgName, size);
  }
}

launchURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch ';
  }
}

Widget getCircleProfileImage(
    BuildContext context, String imgName, double size) {
  return SizedBox(
    width: size,
    height: size,
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(size / 2)),
        child: (imgName.isNotEmpty)
            ? material.Image.network(imgName,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover)
            : getAssetImage("dummy_profile.png")),
  );
}

Future<void> sendMail(String text) async {
  WooCustomer? wooCustomer = homeMainScreenController.currentCustomer;
  final Email email = Email(
    body: text,
    subject: 'Gift Shop',
    recipients: [wooCustomer!.email!],
    isHTML: false,
  );
  await FlutterEmailSender.send(email);
}

sendToPlanDetail({
  String? id,
  Function? function,
  String? startPrice,
  String? endPrice,
  String? tag,
  String? titleTag,
  String? priceTag,
  String? ratingTag,
}) {
  Get.to(PlantDetail(),
          arguments: Tuple7<String?, String?, String?, String?, String?,
                  String?, String?>(
              id, startPrice, endPrice, tag, titleTag, priceTag, ratingTag))!
      .then((value) {
    if (function != null) {
      function();
    }
  });
}

Future<bool> isInternetConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    // Device is connected to the internet

    bool i = Get.isRegistered<HomeMainScreenController>();
    if (i) {
      isNetwork = true;
      HomeMainScreenController putHomeController = Get.find();
      if (putHomeController.wooCommerce1 == null) {
        putHomeController.setData();
        putHomeController.update();
      }
    }

    return true;
  } else {
    // Device is not connected to the internet
    return false;
  }
}

getLoadingAnimation() {
  return Center(
    child: Lottie.asset(loadingAnimation, height: 130.h, width: 130.h),
  );
}

getSuccessAnimation() {
  return Center(
    child: Lottie.asset(successAnimation, height: 190.h, width: 190.h),
  );
}
