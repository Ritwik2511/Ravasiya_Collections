import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/pref_data.dart';
import 'package:ravasiya_collections/woocommerce/models/products.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/controller.dart';
import '../generated/l10n.dart';
import '../model/my_cart_data.dart';
import '../woocommerce/models/product_variation.dart';

Widget getAssetImage(String image,
    {double? width,
    double? height,
    Color? color,
    BoxFit boxFit = BoxFit.contain}) {
  return Image.asset(
    Constant.assetImagePath + image,
    color: color,
    width: width,
    height: height,
    fit: boxFit,
  );
}

Widget getSvgImage(String image,
    {double? width,
    double? height,
    Color? color,
    BoxFit boxFit = BoxFit.contain}) {
  return SvgPicture.asset(
    Constant.assetImagePath + image,
    // ignore: deprecated_member_use
    color: color,
    width: width,
    height: height,
    fit: boxFit,
    matchTextDirection: true,
  );
}

Widget getVerSpace(double verSpace) {
  return SizedBox(
    height: verSpace,
  );
}

Widget getHorSpace(double horSpace) {
  return SizedBox(
    width: horSpace,
  );
}

Widget getCustomFont(String text, double fontSize, Color fontColor, int maxLine,
    {String fontFamily = Constant.fontsFamily,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    txtHeight}) {
  return Text(
    text,
    overflow: overflow,
    style: TextStyle(
      decoration: decoration,
      fontSize: fontSize,
      color: fontColor,
      fontFamily: fontFamily,
      height: txtHeight ?? 1.5.h,
      fontWeight: fontWeight,
    ),
    maxLines: maxLine,
    softWrap: true,
    textAlign: textAlign,
  );
}

Widget getMultilineCustomFont(String text, double fontSize, Color fontColor,
    {TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    txtHeight = 1.5}) {
  return Text(
    text,
    style: TextStyle(
      decoration: decoration,
      fontSize: fontSize,
      fontStyle: FontStyle.normal,
      color: fontColor,
      fontFamily: Constant.fontsFamily,
      height: txtHeight,
      fontWeight: fontWeight,
    ),
    textAlign: textAlign,
  );
}

Widget getCustomButton(String text, VoidCallback function,
    {bool? child,
    double? buttonheight,
    double? buttonwidth,
    double? fontSize,
    FontWeight? weight,
    Color? color,
    bool isProgress = false,
    ButtonStyle? decoration}) {
  return ElevatedButton(
    onPressed: function,
    child: Center(
        child: isProgress
            ? getProgressDialog()
            : child == true
                ? SizedBox(
                    height: 25.h,
                    width: 25.h,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                        fontSize: fontSize ?? 18.sp,
                        color: color ?? Color(0XFFFFFFFF),
                        fontFamily: Constant.fontsFamily,
                        fontWeight: weight ?? FontWeight.w700),
                  )),
    style: decoration ??
        ButtonStyle(
            elevation: MaterialStatePropertyAll(0),
            backgroundColor: MaterialStatePropertyAll(buttonColor),
            maximumSize: MaterialStatePropertyAll(
              Size(buttonwidth ?? double.infinity, buttonheight ?? 54.h),
            ),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.h)))),
  );
}

Widget getDisableButton(String text, VoidCallback function,
    {double? buttonheight,
    double? buttonwidth,
    double? fontSize,
    FontWeight? weight,
    Color? color,
    bool isProgress = false,
    ButtonStyle? decoration}) {
  return ElevatedButton(
    onPressed: function,
    child: Center(
        child: isProgress
            ? getProgressDialog()
            : Text(
                text,
                style: TextStyle(
                    fontSize: fontSize ?? 18.sp,
                    color: darkGray,
                    fontFamily: Constant.fontsFamily,
                    fontWeight: weight ?? FontWeight.w700),
              )),
    style: decoration ??
        ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(lightColor),
            elevation: MaterialStatePropertyAll(0),
            maximumSize: MaterialStatePropertyAll(
              Size(buttonwidth ?? double.infinity, buttonheight ?? 56.h),
            ),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.h)))),
  );
}

Widget getCouponButton(String text, VoidCallback function,
    {double? buttonheight,
    double? buttonwidth,
    double? fontSize,
    FontWeight? weight,
    Color? color,
    bool isProgress = false,
    ButtonStyle? decoration}) {
  return ElevatedButton(
    onPressed: function,
    child: Center(
        child: isProgress
            ? getProgressDialog()
            : Row(
                children: [
                  getSvgImage("copy_icon.svg", color: regularWhite),
                  getHorSpace(10.w),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: fontSize ?? 18.sp,
                        color: color ?? Color(0XFFFFFFFF),
                        fontFamily: Constant.fontsFamily,
                        fontWeight: weight ?? FontWeight.w700),
                  ),
                ],
              )
        // Container()
        ),
    style: decoration ??
        ButtonStyle(
            elevation: MaterialStatePropertyAll(0),
            backgroundColor: MaterialStatePropertyAll(buttonColor),
            maximumSize: MaterialStatePropertyAll(
              Size(130.h, buttonheight ?? 56.h),
            ),
            minimumSize: MaterialStatePropertyAll(
              Size(130.h, buttonheight ?? 56.h),
            ),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.h)))),
  );
}

Widget getLoginScreenAppbar(Function close, Function later) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
          onTap: () {
            close();
          },
          child: getAssetImage("appbarclosebutton.png",
              height: 24.h, width: 24.w)),
      GestureDetector(
          onTap: () {
            later();
          },
          child: getCustomFont("Later", 16.sp, Color(0XFF808080), 1,
              fontWeight: FontWeight.w500))
    ],
  );
}

LoginEmptyStateController loginEmptyStateController =
    Get.put(LoginEmptyStateController());

Widget getTextField(String hinttext,
    {FontWeight? fontWeight,
    double? fontsize,
    Color? color,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    String? val,
    bool enable = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxline,
    TextAlignVertical? textAlign,
    bool? isPass,
    bool? isSuffix = false,
    Function? suffixFunction,
    bool read = false,
    int? length,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction textInputAction = TextInputAction.next}) {
  return TextFormField(
    inputFormatters: inputFormatters,
    obscuringCharacter: "*",
    obscureText: isPass ?? false,
    cursorColor: buttonColor,
    controller: controller,
    initialValue: val,
    keyboardType: keyboardType,
    maxLines: maxline ?? 1,
    maxLength: length,
    textAlign: TextAlign.start,
    textAlignVertical: textAlign ?? TextAlignVertical.center,
    textInputAction: textInputAction,
    readOnly: read,
    style: TextStyle(
        color: regularBlack,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        fontFamily: Constant.fontsFamily),
    decoration: InputDecoration(
      counterText: "",
      suffixIcon: isSuffix!
          ? GestureDetector(
              onTap: () {
                suffixFunction!() ?? () {};
              },
              child: isPass!
                  ? getSvgImage("eye_off.svg").marginSymmetric(horizontal: 16.h)
                  : getSvgImage("eye.svg").marginSymmetric(horizontal: 16.h))
          : null,
      suffixIconConstraints: BoxConstraints(
          minHeight: 30.h, maxHeight: 30.h, minWidth: 50.h, maxWidth: 50.h),
      // floatingLabelBehavior:
      //     read ? FloatingLabelBehavior.never : FloatingLabelBehavior.auto,
      labelStyle: TextStyle(
          color: regularBlack,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          fontFamily: Constant.fontsFamily),
      floatingLabelStyle: TextStyle(
          color: regularBlack,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          fontFamily: Constant.fontsFamily),
      label: getCustomFont(hinttext, 16.sp, regularBlack, 1,
          fontWeight: FontWeight.w400),
      hintText: hinttext,
      hintStyle: TextStyle(
          fontSize: 16.sp,
          fontFamily: Constant.fontsFamily,
          color: darkGray,
          fontWeight: FontWeight.w400),
      errorStyle: TextStyle(
          fontSize: 16.sp,
          color: redColor,
          fontFamily: Constant.fontsFamily,
          fontWeight: FontWeight.w400),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: black20, width: 1.h),
        borderRadius: BorderRadius.circular(16.h),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: redColor, width: 1.h),
        borderRadius: BorderRadius.circular(16.h),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: redColor, width: 1.h),
        borderRadius: BorderRadius.circular(16.h),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: black20, width: 1.h),
        borderRadius: BorderRadius.circular(16.h),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: black20, width: 1.h),
        borderRadius: BorderRadius.circular(16.h),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: black20, width: 1.h),
        borderRadius: BorderRadius.circular(16.h),
      ),
      filled: true,
      isDense: true,
      fillColor: Color(0xFFFFFFFF),
      contentPadding: EdgeInsetsDirectional.only(
          start: 16.h, top: 16.h, bottom: 16.h, end: 16.h),
    ),
    validator: validator,
  );
}

Widget getGoogleFacebookButton(String image, String text,
    {double? buttonheight,
    double? imageheight,
    double? imagewidth,
    double? width,
    FontWeight? fontweight,
    double? fontsize,
    Color? color}) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      height: buttonheight ?? 60.h,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.withOpacity(0.1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              image: AssetImage("${Constant.assetImagePath}${image}"),
              width: imagewidth ?? 24.w,
              height: imageheight ?? 24.h),
          getHorSpace(width ?? 14.w),
          getCustomFont(text, fontsize ?? 18.sp, color ?? Color(0XFF000000), 1,
              fontWeight: fontweight ?? FontWeight.w500)
        ],
      ),
    ),
  );
}

Widget getRichtext(String firsttext, String secondtext,
    {Function? function,
    Color? firsttextcolor,
    Color? secondtextcolor,
    double? firsttextSize,
    double? secondtextSize,
    FontWeight? firstTextwidth,
    FontWeight? secondTextwidth}) {
  return Center(
    child: RichText(
        text: TextSpan(
            text: firsttext,
            style: TextStyle(
                color: firsttextcolor ?? regularBlack,
                fontSize: firsttextSize ?? 14.sp,
                fontFamily: Constant.fontsFamily,
                fontWeight: firstTextwidth ?? FontWeight.w400),
            children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                function!();
              },
            text: secondtext,
            style: TextStyle(
                color: secondtextcolor ?? buttonColor,
                fontSize: secondtextSize ?? 16.sp,
                fontWeight: secondTextwidth ?? FontWeight.w600,
                fontFamily: Constant.fontsFamily),
          )
        ])),
  );
}

Widget getRichtextNew(String firsttext, String secondtext,
    {Function? function,
    Color? firsttextcolor,
    Color? secondtextcolor,
    double? firsttextSize,
    double? secondtextSize,
    FontWeight? firstTextwidth,
    FontWeight? secondTextwidth,
    TextAlign? align}) {
  return Center(
    child: RichText(
        textAlign: align ?? TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        text: TextSpan(
            text: firsttext,
            style: TextStyle(
                color: firsttextcolor ?? Color(0XFF000000),
                fontSize: firsttextSize ?? 16.sp,
                fontFamily: Constant.fontsFamily,
                fontWeight: firstTextwidth ?? FontWeight.w700),
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    function!();
                  },
                text: secondtext,
                style: TextStyle(
                  color: secondtextcolor ?? Color(0XFF000000),
                  fontSize: firsttextSize ?? 12.sp,
                  fontWeight: firstTextwidth ?? FontWeight.w400,
                  fontFamily: Constant.fontsFamily,
                ),
              )
            ])),
  );
}

Widget getPhoneNumberField(Key key, TextEditingController controller,
    {Function? validationFunction}) {
  return Form(
    key: key,
    child: IntlPhoneField(
      dropdownIconPosition: IconPosition.trailing,
      dropdownIcon: Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Color(0XFF000000),
      ),
      flagsButtonPadding: EdgeInsets.only(left: 16.h),
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1.w)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0XFF76974C), width: 1.w),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0XFFFFFFFF), width: 1.w),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      initialCountryCode: 'IN',
      onChanged: (phone) {},
      validator: (val) {
        validationFunction!();
        return null;
      },
    ),
  );
}

Widget simpleAppBar(String text,
    {Function? function,
    Function? filterFunction,
    Color? color,
    double? space,
    bool iconpermmition = true}) {
  return Container(
    height: 73.h,
    color: color,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () {
                function!();
              },
              child: iconpermmition
                  ? getSvgImage("arrow_square_left.svg",
                      height: 24.h, width: 24.h)
                  : SizedBox()),
          getCustomFont(text, 22.sp, regularBlack, 1,
              fontWeight: FontWeight.w700),
          GestureDetector(
            onTap: () {
              filterFunction!();
            },
            child: getSvgImage("filterIcon.svg"),
          )
        ],
      ),
    ),
  );
}

Widget getAppBar(String text,
    {Function? function,
    Color? color,
    double? space,
    bool iconpermmition = true,
    bool actionIcon = false,
    widget}) {
  return Container(
    height: 73.h,
    color: color,
    width: double.infinity,
    alignment: Alignment.center,
    child: Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: GestureDetector(
              onTap: () {
                function!();
              },
              child: iconpermmition
                  ? Padding(
                      padding: EdgeInsetsDirectional.only(end: 20.h),
                      child: getSvgImage("arrow_square_left.svg",
                          height: 24.h, width: 24.h),
                    )
                  : SizedBox()),
        ),
        getCustomFont(text, 22.sp, regularBlack, 1,
            fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
        actionIcon
            ? Align(
                alignment: Alignment.centerRight,
                child: widget,
              )
            : SizedBox()
      ],
    ).marginSymmetric(horizontal: 20.h),
  );
}

Widget getOTPfield(Key key, {Function? function}) {
  return Form(
    key: key,
    child: OtpTextField(
      showFieldAsBox: true,
      numberOfFields: 6,
      borderRadius: BorderRadius.circular(12.h),
      borderWidth: 0,
      focusedBorderColor: Color(0XFF76974C),
      fieldWidth: 60.h,
      filled: true,
      fillColor: Color(0XFFFFFFFF),
      onSubmit: (value) {
        function!();
      },
    ),
  );
}

Widget getSearchField(String? text, controller,
    {Function? function,
    bool autofocus = false,
    Color? hinttextcolor,
    double? hinttextsize,
    FontWeight? fontweight,
    String? prefixiconimage,
    double? prefixiconimageheight,
    double? prefixiconimagewidth,
    double? suffixiconimageheight,
    double? suffixiconimagewidth,
    String? suffixiconimage,
    Function? suffixfunction,
    ValueChanged<String>? onFieldSubmitted,
    textInputAction,
    bool readOnly = false,
    bool enable = true}) {
  return TextFormField(
      enabled: enable,
      readOnly: readOnly,
      onTap: () {
        function!();
      },
      controller: controller,
      textInputAction: textInputAction ?? TextInputAction.none,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: buttonColor, width: 1.h),
              borderRadius: BorderRadius.circular(16.h)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.h),
              borderSide: BorderSide(color: Colors.transparent, width: 0)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.h),
              borderSide: BorderSide(color: Colors.transparent, width: 0)),
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
          fillColor: Color(0XFFF6F6F6),
          hintText: text,
          hintStyle: TextStyle(
              color: hinttextcolor ?? black40,
              fontSize: hinttextsize ?? 16.sp,
              fontFamily: Constant.fontsFamily,
              fontWeight: fontweight ?? FontWeight.w400),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
                top: 10.h, left: 15.h, bottom: 10.h, right: 15.h),
            child: getSvgImage(
              "searchIcon.svg",
              height: prefixiconimageheight ?? 24.h,
              width: prefixiconimagewidth ?? 24.h,
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.h),
              borderSide: BorderSide(color: Colors.transparent, width: 0))));
}

Widget getTabBar(TabController tabcontroller, PageController pagecontroller,
    List<Widget> tabs) {
  return Container(
    height: 50.h,
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.h),
        color: regularWhite,
        border: Border.all(color: Color(0XFFF1F1F1))),
    child: Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      child: TabBar(
        unselectedLabelColor: Color(0XFF808080),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            fontFamily: Constant.fontsFamily),
        labelColor: regularWhite,
        unselectedLabelStyle: TextStyle(
            color: Color(0XFF808080),
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            fontFamily: Constant.fontsFamily,
            height: 1.5.h),
        indicator: ShapeDecoration(
            color: buttonColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.h))),
        controller: tabcontroller,
        tabs: tabs,
        onTap: (value) {
          pagecontroller.animateToPage(value,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
      ),
    ),
  );
}

Widget getPopularDataFormet(String image, Function function, bool initialvalue,
    String plantname, String plantprice,
    {double? imageContainerHeight,
    double? imageContainerWidth,
    double? iconheight,
    double? iconwidth,
    double? pricefontsize,
    FontWeight? pricefontweight,
    double? namefontsize,
    FontWeight? namefontweight,
    double? iconleftpad,
    double? icontoppad,
    double? imageandnamespace,
    double? nameandpricespace}) {
  return Column(
    //crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: imageContainerHeight ?? 114.h,
        width: imageContainerWidth ?? 111.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.h),
            color: bgColor,
            image: DecorationImage(
                image: AssetImage("${Constant.assetImagePath}${image}"),
                fit: BoxFit.fill)),
      ),
      getVerSpace(imageandnamespace ?? 6.h),
      getCustomFont(plantname, namefontsize ?? 14.sp, Color(0XFF000000), 1,
          fontWeight: namefontweight ?? FontWeight.w600, txtHeight: 1.5.h),
      getVerSpace(nameandpricespace ?? 4.h),
      getCustomFont(
          "\$${plantprice}", pricefontsize ?? 14.sp, Color(0XFF000000), 1,
          fontWeight: pricefontweight ?? FontWeight.w500, txtHeight: 1.5.h),
    ],
  );
}

Widget atmospherRules(String image, String atmospherRulse, int percent) {
  return getCustomContainer(60.h, 148.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0XFFE8F0DE),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: getCustomContainer(40.h, 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.h),
                  child: getAssetImage(image),
                )),
          ),
          getHorSpace(9.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getCustomFont(atmospherRulse, 14.sp, regularBlack, 1,
                  fontWeight: FontWeight.w500),
              getCustomFont('${percent}%', 14.sp, buttonColor, 1,
                  fontWeight: FontWeight.w600),
            ],
          )
        ],
      ));
}

Widget getFilterCategory(String emptyList, String nameofList,
    {Function? function}) {
  return Wrap(
    alignment: WrapAlignment.start,
    children: [
      SizedBox(
        height: 60.h,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: emptyList.length,
            itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(8.h),
                  child: GestureDetector(
                    onTap: () {
                      function!();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 13),
                      decoration: BoxDecoration(
                        color: emptyList.contains(nameofList[index])
                            ? Color(0XFF76974C)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: emptyList.contains(nameofList[index])
                                ? Color(0XFF76974C)
                                : Color(0XFFDCDCDC),
                            width: 1),
                      ),
                      height: 40.h,
                      child: Center(
                        child: Text(
                          emptyList[index],
                          style: emptyList.contains(nameofList[index])
                              ? TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFFFFFFFF),
                                  fontFamily: Constant.fontsFamily)
                              : TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0XFF6E758A),
                                  fontFamily: Constant.fontsFamily),
                        ),
                      ),
                    ),
                  ),
                )),
      )
    ],
  );
}

Widget getCustomContainer(double? height, double? width,
    {BoxDecoration? decoration, Widget? child, Color? color}) {
  return Container(
    // height: height,
    width: width,
    color: color,
    decoration: decoration,
    child: child,
  );
}

Widget getadd_remove_button(String? image,
    {Function? function,
    double? height,
    double? width,
    double? padding,
    Color? color}) {
  return GestureDetector(
    onTap: () {
      function!();
    },
    child: getCustomContainer(height ?? 34.h, width ?? 34.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? Color(0XffFFFFFF),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding ?? 7.h),
          child: getSvgImage(image!,
              height: 18.h, width: 18.h, color: buttonColor),
        )),
  );
}

Widget getCartDetailFormate(String productImage, String productName,
    String productPrice, int productQuntity, String size,
    {double? veraround, Widget? column}) {
  return Stack(
    children: [
      Row(
        children: [
          getHorSpace(7.w),
          getCustomContainer(
            95.h,
            95.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.h),
                color: Color(0XFFEFEFEF)),
            child: getAssetImage(productImage, height: 75.h, width: 51.h)
                .paddingSymmetric(horizontal: 22.h),
          ),
          getHorSpace(20.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont(productName, 18.sp, Color(0XFF000000), 1,
                  fontWeight: FontWeight.w600),
              getVerSpace(10.h),
              Row(
                children: [
                  getCustomFont("Size:", 14.sp, Color(0XFF808080), 1,
                      txtHeight: 1.5.h, fontWeight: FontWeight.w500),
                  getHorSpace(2.h),
                  getCustomFont(size, 14.sp, regularBlack, 1,
                      txtHeight: 1.5.h, fontWeight: FontWeight.w500),
                ],
              ),
              getVerSpace(8.h),
              getCustomFont("\$${productPrice}", 15.sp, Color(0XFF000000), 1,
                  fontWeight: FontWeight.w500),
            ],
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(left: 290.w, top: 14.h, bottom: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                      barrierDismissible: false,
                      title: '',
                      content: Padding(
                        padding: EdgeInsets.only(left: 10.h, right: 10.h),
                        child: Column(
                          children: [
                            getCustomFont(
                                "Are you sure you want to delete this from cart?",
                                18.sp,
                                regularBlack,
                                2,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center),
                            Padding(
                              padding: EdgeInsets.only(top: 25.h, bottom: 13.h),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: getCustomButton("No", () {
                                    Get.back();
                                  },
                                          color: Color(0XFF76974C),
                                          decoration: ButtonStyle(
                                              elevation:
                                                  MaterialStatePropertyAll(0.0),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      regularWhite),
                                              maximumSize:
                                                  MaterialStatePropertyAll(
                                                Size(double.infinity, 60.h),
                                              ),
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.h),
                                                      side: BorderSide(
                                                          color:
                                                              buttonColor)))),
                                          buttonheight: 60.h)),
                                  getHorSpace(20.h),
                                  Expanded(
                                      child: getCustomButton("Yes", () {},
                                          buttonheight: 60.h)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                },
                child: getAssetImage("delete.png", height: 20.h, width: 20.w)),
            getVerSpace(32.h),
            Row(
              children: [
                getadd_remove_button("remove_icon.svg",
                    function: () {},
                    color: regularWhite,
                    padding: 5.h,
                    height: 28.h,
                    width: 28.w),
                getHorSpace(20.h),
                getCustomFont("${productQuntity}", 16, Color(0XFF000000), 1,
                    fontWeight: FontWeight.w500),
                getHorSpace(20.h),
                getadd_remove_button("add_icon.svg",
                    function: () {},
                    color: regularWhite,
                    padding: 5.h,
                    height: 28.h,
                    width: 28.w),
              ],
            )
          ],
        ),
      ),
    ],
  );
}

Widget getCartDetailFormateNew(
    String productImage,
    String productName,
    String productPrice,
    int productQuntity,
    removeFunction,
    addFunction,
    deletfunction,
    context,
    {double? veraround,
    Widget? column,
    widget}) {
  return Container(
    width: double.infinity,
    color: regularWhite,
    child: Row(
      children: [
        // Container(
        //   height: 95.h,
        //   width: 95.h,
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(16.h),
        //       color: regularWhite,
        //       border: Border.all(color: black20)),
        //   child: Image.network(productImage, height: 75.h, width: 51.h),
        // ),
        Container(
          height: 95.h,
          width: 95.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.h),
              color: regularWhite,
              border: Border.all(color: black20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.h),
            child: CachedNetworkImage(
              imageUrl: productImage,
              fit: BoxFit.fill,
              placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                color: buttonColor,
              )),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        getHorSpace(16.h),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: getCustomFont(productName, 16.sp, Color(0XFF000000), 2,
                    fontWeight: FontWeight.w600),
              ),
              getVerSpace(4.h),
              Container(
                child: getCustomFont(
                    formatStringCurrency(total: productPrice, context: context),
                    15.sp,
                    Color(0XFF000000),
                    1,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis),
              ),
              getVerSpace(4.h),
              widget,
              getVerSpace(4.h),
              Container(
                child: getCustomFont(
                    "${S.of(context).total} ${formatStringCurrency(total: (double.parse(productPrice) * productQuntity).toString(), context: context)}",
                    15.sp,
                    Color(0XFF000000),
                    1,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Directionality(
                        textDirection: Constant.getSetDirection(context) ==
                                TextDirection.ltr
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        child: AlertDialog(
                          contentPadding:
                              EdgeInsets.only(left: 0.h, right: 0.h),
                          insetPadding:
                              EdgeInsets.only(left: 20.h, right: 20.h),
                          content: Container(
                            width: 374.h,
                            child: Padding(
                              padding: EdgeInsets.all(30.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  getMultilineCustomFont(
                                      "Are you sure you want to delete this product from cart?",
                                      18.sp,
                                      regularBlack,
                                      fontWeight: FontWeight.w700,
                                      textAlign: TextAlign.center),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 25.h, bottom: 13.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child:
                                                // ElevatedButton(onPressed: (){}, child: getCustomFont("yes", 16.sp, regularBlack, 1)),

                                                getCustomButton("No", () {
                                          Get.back();
                                        }, buttonheight: 56.h)),
                                        SizedBox(width: 20.h),
                                        Expanded(
                                            child: getCustomButton("Yes", () {
                                          deletfunction();
                                        },
                                                color: buttonColor,
                                                decoration: ButtonStyle(
                                                    elevation:
                                                        MaterialStatePropertyAll(
                                                            0.0),
                                                    surfaceTintColor:
                                                        MaterialStatePropertyAll(
                                                            regularWhite),
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            regularWhite),
                                                    maximumSize:
                                                        MaterialStatePropertyAll(
                                                      Size(double.infinity,
                                                          56.h),
                                                    ),
                                                    shape: MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.h),
                                                            side: BorderSide(
                                                                color:
                                                                    buttonColor)))),
                                                buttonheight: 50.h)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                    height: 40.h,
                    width: 40.h,
                    alignment: Alignment.topCenter,
                    child: getAssetImage("delete.png",
                        height: 20.h, width: 20.h))),
            getVerSpace(18.h),
            GetBuilder<HomeScreenController>(
              init: HomeScreenController(),
              builder: (controller) => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  getadd_remove_button("remove_icon.svg", function: () {
                    removeFunction();
                  }, color: bgColor, padding: 5.h, height: 28.h, width: 28.h),
                  getHorSpace(17.h),
                  getCustomFont(
                      "${productQuntity}", 14.sp, Color(0XFF000000), 1,
                      fontWeight: FontWeight.w400),
                  getHorSpace(17.h),
                  getadd_remove_button("add_icon.svg", function: () {
                    addFunction();
                  }, color: bgColor, padding: 5.h, height: 28.h, width: 28.h),
                ],
              ),
            )
          ],
        ),
      ],
    ).paddingSymmetric(vertical: 20.h, horizontal: 20.h),
  );
}

HomeMainScreenController homeMainScreenController =
    Get.put(HomeMainScreenController());

Widget getCartDetailFormateNewOfCheakoutScreen(
    String productImage,
    String productName,
    String productPrice,
    int productQuntity,
    removeFunction,
    addFunction,
    deletfunction,
    quantity,
    {double? veraround,
    Widget? column,
    widget}) {
  return Stack(
    children: [
      Row(
        children: [
          getHorSpace(7.h),
          getCustomContainer(
            95.h,
            95.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.h), color: regularWhite),
            child: Image.network(productImage, height: 75.h, width: 51.h)
                .paddingSymmetric(horizontal: 22.h),
          ),
          getHorSpace(20.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 240.h,
                child: getCustomFont(productName, 18.sp, Color(0XFF000000), 1,
                    fontWeight: FontWeight.w600),
              ),
              getVerSpace(10.h),
              widget,
              getVerSpace(8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 112.h,
                    child: getCustomFont(
                        "${HtmlUnescape().convert(homeMainScreenController.wooCurrentCurrency!.symbol ?? "")}${productPrice}",
                        15.sp,
                        Color(0XFF000000),
                        1,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis),
                  ),
                  getCustomFont("QTY: ${quantity}", 15.sp, regularBlack, 1)
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget getCartOrderListFormate(String productImage, String productName,
    String size, int productPrice, int productQuntity,
    {double? veraround, Widget? column, double? quntitypadding}) {
  return Row(
    children: [
      getHorSpace(7.w),
      getCustomContainer(
        95.h,
        95.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.h), color: bgColor),
        child: getAssetImage(
          productImage,
        ),
      ),
      getHorSpace(20.w),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCustomFont(productName, 18.sp, Color(0XFF000000), 1,
              fontWeight: FontWeight.w600),
          getVerSpace(10.h),
          Row(
            children: [
              getCustomFont("Size:", 14.sp, Color(0XFF808080), 1,
                  fontWeight: FontWeight.w500),
              getHorSpace(3.h),
              getCustomFont(size, 14.sp, regularBlack, 1,
                  fontWeight: FontWeight.w500),
            ],
          ),
          getVerSpace(10.h),
          getCustomFont("\$${productPrice}", 15.sp, Color(0XFF000000), 1,
              fontWeight: FontWeight.w500),
        ],
      ),
    ],
  );
}

Widget getSuccessConfirmMessegeFormate(String image, String messege,
    String successmessege, String buttonText, Function function,
    {ButtonStyle? Decoration, Color? textColor}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      getAssetImage(image, height: 140.h, width: 140.w),
      getVerSpace(30.h),
      getCustomFont(messege, 28, Color(0XFF000000), 2,
          fontWeight: FontWeight.w700),
      getVerSpace(8.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.h),
        child: getCustomFont(successmessege, 16, Color(0XFF000000), 2,
            fontWeight: FontWeight.w500, textAlign: TextAlign.center),
      ),
      getVerSpace(40.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 75.h),
        child: getCustomButton(buttonText, decoration: Decoration, () {
          function();
        }, color: textColor ?? regularWhite),
      ),
    ],
  );
}

Widget getProfileOption(String image, String name, Function function,
    {double? height, double? width}) {
  return GestureDetector(
    onTap: () {
      function();
    },
    child: Container(
      height: 45.h,
      width: double.infinity,
      color: Color(0XFFFFFFFF),
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              getSvgImage(image,
                  height: height ?? 24.h,
                  width: width ?? 24.h,
                  color: regularBlack),
              getHorSpace(20.h),
              getCustomFont(name, 16.sp, Color(0XFF000000), 1,
                  fontWeight: FontWeight.w500)
            ],
          ),
          getSvgImage("arrow_right.svg", height: 20.h, width: 20.w)
        ],
      ),
    ),
  );
}

Widget getDivider({double? horPadding, Color? color, double? height}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: horPadding ?? 20.h),
    child: Divider(
      color: color ?? gray,
      height: height,
    ),
  );
}

Widget getMyprofileDetailFormate(
    String iconImage, String cetegoryName, String userDetail) {
  return Row(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSvgImage(iconImage,
                height: 24.h, width: 24.h, color: regularBlack),
            getHorSpace(16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCustomFont(cetegoryName, 16.sp, darkGray, 1,
                    fontWeight: FontWeight.w400),
                getVerSpace(7.h),
                getCustomFont(userDetail, 16.sp, regularBlack, 1,
                    fontWeight: FontWeight.w400)
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget getEditProfileOptionFormate(controller, bool suffixIconPosition,
    {String? iconImage,
    double? height,
    int? maxline,
    bool requredImage = false,
    String? hint,
    String? userdetail,
    onchange,
    bool read = false}) {
  return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: getTextField(hint.toString(),
          fontsize: 16.sp, controller: controller, read: read));
}

Widget getSearchHistry(String histry) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getCustomFont(histry, 16.sp, Color(0XFF000000), 1,
            fontWeight: FontWeight.w500),
        GestureDetector(
            onTap: () {},
            child: getAssetImage("circular_close_icon.png",
                height: 24.h, width: 24.w))
      ],
    ),
  );
}

Widget getNotificationFormate(
    int notificationNumber, String messege, String time) {
  return Container(
    color: regularWhite,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getSvgImage("notification_green.svg", height: 24.h, width: 24.h),
        getHorSpace(20.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont(
                  "Notification ${notificationNumber}", 16.sp, regularBlack, 1,
                  fontWeight: FontWeight.w700),
              getVerSpace(10.h),
              getMultilineCustomFont(messege, 16.sp, regularBlack,
                  fontWeight: FontWeight.w500, txtHeight: 1.5.h),
            ],
          ),
        ),
        getCustomFont("${time} ago", 14.sp, subTitleColor, 1,
            fontWeight: FontWeight.w500),
      ],
    ).paddingSymmetric(horizontal: 20.h, vertical: 20.h),
  ).paddingSymmetric(vertical: 10.h);
}

Widget getViewCartButton(String text, String total, String buttonText,
    Function lastButtonFunction, Function buttonFunction) {
  return GestureDetector(
    onTap: () {
      buttonFunction();
    },
    child: Align(
      alignment: Alignment.bottomCenter,
      child: getCustomContainer(60.h, double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.h), color: buttonColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  getSvgImage("cart_icon.svg"),
                  getHorSpace(8.h),
                  getCustomFont(text, 16.sp, regularWhite, 1,
                      fontWeight: FontWeight.w700),
                  getHorSpace(20.h),
                  getCustomFont("\$${total}", 16.sp, regularWhite, 1,
                      fontWeight: FontWeight.w400),
                ],
              ),
              GestureDetector(
                onTap: () {
                  lastButtonFunction();
                },
                child: Row(
                  children: [
                    getCustomFont(buttonText, 16.sp, regularWhite, 1,
                        fontWeight: FontWeight.w700),
                    getHorSpace(8.h),
                    getSvgImage("arrow_right_white.svg",
                        height: 18.h, width: 18.h)
                  ],
                ),
              )
            ],
          ).paddingSymmetric(horizontal: 20.h)),
    ).paddingOnly(left: 20.h, right: 20.h, bottom: 30.h),
  );
}

Widget getEmptyWidget(BuildContext context, String image, String title,
    String description, String btnTxt, Function function,
    {bool withButton = true, bool svg = true}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: [
      svg
          ? getSvgImage(image, height: 140.h, width: 140.h)
          : getAssetImage(Constant.searchEmptyLogo,
              height: 140.h, width: 140.h),
      getVerSpace(30.h),
      getCustomFont(title, 22.sp, regularBlack, 1,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
          txtHeight: 1.5.h),
      getVerSpace(8.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 61.h),
        child: getMultilineCustomFont(description, 16.sp, regularBlack,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
            txtHeight: 1.5.h),
      ),
      getVerSpace(32.h),
      withButton
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 98.h),
              child: getCustomButton(
                btnTxt,
                () {
                  function();
                },
                // buttonheight: 56.h,
                decoration: ButtonStyle(
                    elevation: MaterialStatePropertyAll(0),
                    backgroundColor: MaterialStatePropertyAll(buttonColor),
                    maximumSize: MaterialStatePropertyAll(
                      Size(double.infinity, 56.h),
                    ),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.h),
                        side: BorderSide(color: buttonColor)))),
                color: regularWhite,
              ),
            )
          : Container()
    ],
  );
}

getProgressDialog() {
  return Container(
      color: Colors.transparent,
      child: Center(
          child: Theme(
              data: ThemeData(
                  cupertinoOverrideTheme:
                      const CupertinoThemeData(brightness: Brightness.dark)),
              child: CupertinoActivityIndicator(
                color: buttonColor,
              ))));
}

Widget animation_function(index, child,
    {Duration? listAnimation, Duration? slideduration, Duration? slidedelay}) {
  return AnimationConfiguration.staggeredList(
    position: index,
    duration: listAnimation ?? Duration(milliseconds: 500),
    child: SlideAnimation(
      duration: slideduration ?? Duration(milliseconds: 50),
      delay: slidedelay ?? Duration(milliseconds: 50),
      child: FadeInAnimation(
        child: child,
      ),
    ),
  );
}

Widget getNetworkImage(
    BuildContext context, String image, double width, double height,
    {Color? color,
    BoxFit boxFit = BoxFit.scaleDown,
    bool listen = true,
    double sizePlaceHolder = 50,
    EdgeInsets edgeInset = EdgeInsets.zero}) {
  return Center(
    child: CachedNetworkImage(
      placeholderFadeInDuration: Duration.zero,
      imageUrl: image,
      cacheKey: image,
      useOldImageOnUrlChange: false,
      height: height,
      width: width,
      fit: boxFit,
    ),
  );
}

// Widget addToCartButton(
//     {required WooProduct product,
//     required WooProductVariation? variationModel,
//     required RxInt currentQuantity,
//     required var cartOtherInfoList,
//     required Function changeCoupon,
//     required Function(CartOtherInfo) addInfo,
//     required Function(WooProduct) updateProduct,
//     required Function removeFromCart,
//     required HomeScreenController controller}) {
//   return FutureBuilder<List<int>>(
//     future: PrefData.getCartIdList(),
//     builder: (context, snapshot) {
//       bool i = false;
//       if (snapshot.data != null) {
//         i = snapshot.data!.contains(product.id);
//       }
//       if (product.variations.isNotEmpty) {
//         return (!i)
//             ? getCustomButton(
//                 "Add to Cart",
//                 () async {
//                   if (controller.variationModel != null) {
//                     if (cartOtherInfoList.isEmpty) {
//                       changeCoupon();
//                     }
//                     if (!i) {
//                       final snackBar = SnackBar(
//                         content: Text('Added to cart'),
//                         duration: Duration(seconds: 2),
//                       );
//                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                       addInfo(CartOtherInfo(
//                           variationId:
//                               (variationModel != null) ? variationModel.id : 0,
//                           variationList: (variationModel != null)
//                               ? variationModel.attributes
//                               : [],
//                           productId: product.id,
//                           quantity: currentQuantity.value,
//                           stockStatus: product.stockStatus,
//                           type: product.type,
//                           productName: product.name,
//                           productImage: product.images[0].src,
//                           productPrice: (variationModel != null)
//                               ? (parseWcPrice(variationModel.salePrice) <= 0)
//                                   ? parseWcPrice(variationModel.regularPrice)
//                                   : parseWcPrice(variationModel.salePrice)
//                               : (parseWcPrice(product.salePrice) <= 0)
//                                   ? parseWcPrice(product.regularPrice)
//                                   : parseWcPrice(product.salePrice),
//                           taxClass: product.taxClass));
//                       context.loaderOverlay.hide();
//
//                       updateProduct(product);
//                     } else {
//                       for (int i = 0; i < cartOtherInfoList.length; i++) {
//                         CartOtherInfo element = cartOtherInfoList[i];
//
//                         if (element.productId == product.id) {
//                           element.variationList = (variationModel != null)
//                               ? variationModel.attributes
//                               : [];
//                           element.variationId =
//                               (variationModel != null) ? variationModel.id : 0;
//                           element.productPrice = (variationModel != null)
//                               ? (parseWcPrice(variationModel.salePrice) <= 0)
//                                   ? parseWcPrice(variationModel.regularPrice)
//                                   : parseWcPrice(variationModel.salePrice)
//                               : (parseWcPrice(product.salePrice) <= 0)
//                                   ? parseWcPrice(product.regularPrice)
//                                   : parseWcPrice(product.salePrice);
//                         }
//                       }
//                     }
//                   } else {
//                     showCustomToast("Please Wait..");
//                   }
//                 },
//                 color: buttonColor,
//                 buttonheight: 58.h,
//                 decoration: ButtonStyle(
//                     overlayColor: MaterialStatePropertyAll(lightGreen),
//                     surfaceTintColor: MaterialStatePropertyAll(Colors.white),
//                     backgroundColor: MaterialStatePropertyAll(regularWhite),
//                     maximumSize: MaterialStatePropertyAll(
//                       Size(double.infinity, 58.h),
//                     ),
//                     shape: MaterialStatePropertyAll(RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.h),
//                         side: BorderSide(color: buttonColor, width: 1.5)))),
//               )
//             : getCustomButton("View Cart", () async {
//                 if (controller.variationModel != null) {
//                   removeFromCart();
//                 } else {
//                   showCustomToast("Please Wait..");
//                 }
//               }, buttonheight: 58.h);
//       } else {
//         return (!i)
//             ? getCustomButton(
//                 "Add to Cart",
//                 () async {
//                   if (cartOtherInfoList.isEmpty) {
//                     changeCoupon();
//                   }
//                   if (!i) {
//                     context.loaderOverlay.show();
//                     final snackBar = SnackBar(
//                       content: Text('Added to cart'),
//                       duration: Duration(seconds: 2),
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                     addInfo(CartOtherInfo(
//                         variationId:
//                             (variationModel != null) ? variationModel.id : 0,
//                         variationList: (variationModel != null)
//                             ? variationModel.attributes
//                             : [],
//                         productId: product.id,
//                         quantity: currentQuantity.value,
//                         stockStatus: product.stockStatus,
//                         type: product.type,
//                         productName: product.name,
//                         productImage: product.images[0].src,
//                         productPrice: (variationModel != null)
//                             ? (parseWcPrice(variationModel.salePrice) <= 0)
//                                 ? parseWcPrice(variationModel.regularPrice)
//                                 : parseWcPrice(variationModel.salePrice)
//                             : (parseWcPrice(product.salePrice) <= 0)
//                                 ? parseWcPrice(product.regularPrice)
//                                 : parseWcPrice(product.salePrice),
//                         taxClass: product.taxClass));
//                     context.loaderOverlay.hide();
//
//                     updateProduct(product);
//                   } else {
//                     for (int i = 0; i < cartOtherInfoList.length; i++) {
//                       CartOtherInfo element = cartOtherInfoList[i];
//
//                       if (element.productId == product.id) {
//                         element.variationList = (variationModel != null)
//                             ? variationModel.attributes
//                             : [];
//                         element.variationId =
//                             (variationModel != null) ? variationModel.id : 0;
//                         element.productPrice = (variationModel != null)
//                             ? (parseWcPrice(variationModel.salePrice) <= 0)
//                                 ? parseWcPrice(variationModel.regularPrice)
//                                 : parseWcPrice(variationModel.salePrice)
//                             : (parseWcPrice(product.salePrice) <= 0)
//                                 ? parseWcPrice(product.regularPrice)
//                                 : parseWcPrice(product.salePrice);
//                       }
//                     }
//                   }
//                 },
//                 color: buttonColor,
//                 buttonheight: 58.h,
//                 decoration: ButtonStyle(
//                     overlayColor: MaterialStatePropertyAll(lightGreen),
//                     surfaceTintColor: MaterialStatePropertyAll(Colors.white),
//                     backgroundColor: MaterialStatePropertyAll(regularWhite),
//                     maximumSize: MaterialStatePropertyAll(
//                       Size(double.infinity, 58.h),
//                     ),
//                     shape: MaterialStatePropertyAll(RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16.h),
//                         side: BorderSide(color: buttonColor)))),
//               )
//             : getCustomButton("View Cart", () async {
//                 removeFromCart();
//               }, buttonheight: 58.h);
//       }
//     },
//   );
// }

checkIsCartAlreadyAdded(int id) async {
  List<int> list = await PrefData.getCartIdList();

  return list.contains(id);
}

Widget getCheckCartWidget({
  required WooProduct product,
  required WooProductVariation? variationModel,
  required RxInt currentQuantity,
  required var cartOtherInfoList,
  required Function changeCoupon,
  required Function(CartOtherInfo) addInfo,
  required Function(WooProduct) updateProduct,
}) {
  return FutureBuilder<List<int>>(
    future: PrefData.getCartIdList(),
    builder: (context, snapshot) {
      bool i = false;
      if (snapshot.data != null) {
        i = snapshot.data!.contains(product.id);
      }
      return (!i)
          ? GestureDetector(
              onTap: () async {
                if (cartOtherInfoList.isEmpty) {
                  changeCoupon();
                }
                if (!i) {
                  context.loaderOverlay.show(showOverlay:  getProgressDialog());
                  final snackBar = SnackBar(
                    content: Text('Added to cart'),
                    duration: Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  addInfo(CartOtherInfo(
                      variationId:
                          (variationModel != null) ? variationModel.id : 0,
                      variationList: (variationModel != null)
                          ? variationModel.attributes
                          : [],
                      productId: product.id,
                      quantity: currentQuantity.value,
                      stockStatus: product.stockStatus,
                      type: product.type,
                      productName: product.name,
                      productImage: product.images[0].src,
                      productPrice: (variationModel != null)
                          ? (parseWcPrice(variationModel.salePrice) <= 0)
                              ? parseWcPrice(variationModel.regularPrice)
                              : parseWcPrice(variationModel.salePrice)
                          : (parseWcPrice(product.salePrice) <= 0)
                              ? parseWcPrice(product.regularPrice)
                              : parseWcPrice(product.salePrice),
                      taxClass: product.taxClass));
                  context.loaderOverlay.hide();

                  updateProduct(product);
                } else {
                  for (int i = 0; i < cartOtherInfoList.length; i++) {
                    CartOtherInfo element = cartOtherInfoList[i];

                    if (element.productId == product.id) {
                      element.variationList = (variationModel != null)
                          ? variationModel.attributes
                          : [];
                      element.variationId =
                          (variationModel != null) ? variationModel.id : 0;
                      element.productPrice = (variationModel != null)
                          ? (parseWcPrice(variationModel.salePrice) <= 0)
                              ? parseWcPrice(variationModel.regularPrice)
                              : parseWcPrice(variationModel.salePrice)
                          : (parseWcPrice(product.salePrice) <= 0)
                              ? parseWcPrice(product.regularPrice)
                              : parseWcPrice(product.salePrice);
                    }
                  }
                }
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 36.h,
                  width: 36.h,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(6.h)),
                  child: getSvgImage("add_icon_white.svg",
                          height: 24.h, width: 24.h)
                      .paddingAll(6.h),
                ),
              ).paddingOnly(bottom: 16.h, right: 16.h),
            )
          : GestureDetector(
              onTap: () {},
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 36.h,
                  width: 36.h,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(6.h)),
                  child: getSvgImage("tick_icon.svg", height: 24.h, width: 24.h)
                      .paddingAll(6.h),
                ),
              ).paddingOnly(bottom: 16.h, right: 16.h),
            );
    },
  );
}

Widget productDataFormateInListView(
    context,
    function1,
    WooProduct product,
    favoriteIconFWidget,
    int index,
    String name,
    HomeMainScreenController homeMainScreenController) {
  return GestureDetector(
      onTap: () {
        function1();
      },
      child: Container(
          width: 200.h,
          height: 280.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.h),
              border: Border.all(color: black20),
              color: regularWhite),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 14.h),
                    child: Center(
                      child: product.images.isEmpty
                          ? getAssetImage("no_image_banner.png",
                              height: 146.h, width: 153.h)
                          : Hero(
                              tag: "${name}${index}${product.images[0].src}",
                              transitionOnUserGestures: true,
                              child: CachedNetworkImage(
                                  imageUrl: product.images[0].src,
                                  height: 146.h,
                                  width: 153.h,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            margin: EdgeInsetsDirectional.only(
                                                top: 14.h,
                                                start: 20.h,
                                                end: 20.h),
                                            decoration: getButtonDecoration(
                                                gray,
                                                withCorners: true,
                                                corner: 12.h),
                                            height: 146.h,
                                            width: double.infinity,
                                          )),
                                  errorWidget: (context, url, error) =>
                                      getAssetImage("no_image_banner.png")),
                            ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      product.onSale
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsetsDirectional.only(
                                    top: 10.h, start: 14.h),
                                padding: EdgeInsetsDirectional.symmetric(
                                    vertical: 2.h, horizontal: 8.h),
                                decoration: BoxDecoration(
                                    color: buttonColor,
                                    borderRadius: BorderRadius.circular(12.h)),
                                child: getCustomFont(
                                    "SALE", 12.sp, Colors.white, 1,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center),
                              ))
                          : 0.h.horizontalSpace,
                      // favoriteIconFWidget
                    ],
                  ),
                  Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: favoriteIconFWidget)
                ],
              ),
              // getVerSpace(7.h),

              Spacer(),
              product.averageRating == "0.00"
                  ? getVerSpace(12.h)
                  : Hero(
                      tag: "${name}${index}rating",
                      transitionOnUserGestures: true,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getSvgImage("gray_star_icon.svg",
                              height: 12.h, width: 12.h),
                          getHorSpace(4.h),
                          getCustomFont(
                              "${product.averageRating}(${product.ratingCount.toString()})",
                              12.sp,
                              regularBlack,
                              1,
                              fontWeight: FontWeight.w400),
                        ],
                      ).paddingSymmetric(horizontal: 12.h),
                    ),
              getVerSpace(6.h),
              Container(
                height: product.name.length > 22 ? 41.h : 21.h,
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: "${name}${index}${product.name}",
                    child: getCustomFont(
                            "${product.name}", 14.sp, regularBlack, 2,
                            fontWeight: FontWeight.w600, txtHeight: 1.5.h)
                        .paddingSymmetric(
                      horizontal: 12.h,
                    ),
                  ),
                ),
              ),

              // getVerSpace(6.h),
              product.onSale
                  ? Row(
                      children: [
                        Text(
                          (product.salePrice.isNotEmpty)
                              ? formatStringCurrency(
                                  total: product.regularPrice, context: context)
                              : formatStringCurrency(
                                  total: product.regularPrice,
                                  context: context),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontFamily: Constant.fontsFamily),
                        ),
                        getHorSpace(6.h),
                        (product.salePrice.isNotEmpty)
                            ? getCustomFont(
                                "${100 * (double.parse(product.regularPrice) - double.parse(product.salePrice)) ~/ double.parse(product.regularPrice)}% OFF",
                                14.sp,
                                buttonColor,
                                1,
                                fontWeight: FontWeight.w500)
                            : SizedBox(),
                      ],
                    ).paddingSymmetric(horizontal: 12.h)
                  : getVerSpace(0.h),
              product.onSale ? getVerSpace(0.h) : getVerSpace(4.h),
              Hero(
                tag: "${name}${index}price",
                transitionOnUserGestures: true,
                child: homeMainScreenController.checkNullOperator()
                    ? Container()
                    : FutureBuilder<List<WooProductVariation>>(
                        future: homeMainScreenController.wooCommerce1!
                            .getProductVariations(
                                homeMainScreenController.api1!,
                                productId: product.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (product.variations.isEmpty) {
                              return Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: 12.h, bottom: 5.h),
                                child: Container(
                                    height: 24.h,
                                    child: getCustomFont(
                                        formatStringCurrency(
                                            total: product.onSale
                                                ? product.salePrice
                                                : product.price,
                                            context: context),
                                        16.sp,
                                        regularBlack,
                                        1,
                                        fontWeight: FontWeight.w600)),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: 12.h, bottom: 5.h),
                                child: Container(
                                    height: 24.h,
                                    child: getCustomFont(
                                        "${formatStringCurrency(total: snapshot.data!.last.price, context: context)} - ${formatStringCurrency(total: snapshot.data!.first.price, context: context)}",
                                        16.sp,
                                        regularBlack,
                                        1,
                                        fontWeight: FontWeight.w600)),
                              );
                            }
                          } else {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: 12.h, bottom: 5.h),
                              child: Container(
                                  height: 24.h,
                                  child: getCustomFont(
                                      formatStringCurrency(
                                          total: product.onSale
                                              ? product.salePrice
                                              : product.price,
                                          context: context),
                                      16.sp,
                                      regularBlack,
                                      1,
                                      fontWeight: FontWeight.w600)),
                            );
                          }
                        },
                      ),
              )
            ],
          )));
}

CartControllerNew cartControllerNew = Get.put(CartControllerNew());

Widget productDataFormateGridViewShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    enabled: true,
    child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.h),
          border: Border.all(color: black20),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              child: Container(
                margin: EdgeInsetsDirectional.only(top: 14.h),
                height: 138.h,
                width: 153.h,
                color: Colors.white,
              ),
              alignment: AlignmentDirectional.topCenter,
            ),
            Spacer(),
            Container(
              height: 17.h,
              width: 102.h,
              color: Colors.white,
            ).paddingSymmetric(horizontal: 12.h),
            getVerSpace(4.h),
            Container(
              height: 24.h,
              width: 52.h,
              color: Colors.white,
            ).paddingSymmetric(horizontal: 12.h),
            getVerSpace(5.h),
          ],
        )),
  );
}

Widget productDataFormateGridView(
    context,
    function1,
    WooProduct product,
    favoriteIconFWidget,
    // addButtonWidget,
    int index) {
  return GestureDetector(
      onTap: () {
        function1();
      },
      child: Container(
          height: 280.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.h),
              border: Border.all(color: black20),
              color: regularWhite),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: product.images.isEmpty
                            ? getAssetImage("no_image_banner.png",
                                    height: 146.h, width: 153.h)
                                .paddingOnly(top: 14.h, left: 20.h, right: 20.h)
                            : Hero(
                                tag: 'main${index}${product.images[0].src}',
                                child: CachedNetworkImage(
                                    imageUrl: product.images[0].src,
                                    height: 146.h,
                                    width: 153.h,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Center(
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              decoration: getButtonDecoration(
                                                  gray,
                                                  withCorners: true,
                                                  corner: 12.h),
                                              height: 146.h,
                                              width: double.infinity,
                                            ).paddingOnly(
                                                top: 14.h,
                                                left: 20.h,
                                                right: 20.h),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        getAssetImage(
                                            "no_image_banner.png")).paddingOnly(
                                    top: 14.h),
                              ),
                      ),
                      product.onSale
                          ? Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Container(
                                margin: EdgeInsetsDirectional.only(
                                    top: 10.h, start: 14.h),
                                padding: EdgeInsetsDirectional.symmetric(
                                    vertical: 2.h, horizontal: 8.h),
                                decoration: BoxDecoration(
                                    color: buttonColor,
                                    borderRadius: BorderRadius.circular(12.h)),
                                child: getCustomFont(
                                    "SALE", 12.sp, Colors.white, 1,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center),
                              ))
                          : 0.h.horizontalSpace,
                    ],
                  ),
                  // getVerSpace(7.h),
                  Spacer(),
                  product.averageRating == "0.00"
                      ? getVerSpace(13.h)
                      : Hero(
                          tag: "main${index}rating",
                          transitionOnUserGestures: true,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              getSvgImage("gray_star_icon.svg",
                                  height: 12.h, width: 12.h),
                              getHorSpace(4.h),
                              getCustomFont(
                                  "${product.averageRating}(${product.ratingCount.toString()})",
                                  12.sp,
                                  regularBlack,
                                  1,
                                  fontWeight: FontWeight.w400),
                            ],
                          ).paddingSymmetric(horizontal: 12.h),
                        ),
                  getVerSpace(6.h),
                  //
                  Container(
                    height: product.name.length > 30 ? 42.h : 21.h,
                    child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: "main${index}${product.name}",
                          child: getMultilineCustomFont(
                                  "${product.name}", 14.sp, regularBlack,
                                  fontWeight: FontWeight.w600, txtHeight: 1.5.h)
                              .paddingOnly(
                            left: 12.h,
                            right: 12.h,
                          ),
                        )),
                  ),

                  // getVerSpace(6.h),
                  product.onSale
                      ? Row(
                          children: [
                            Text(
                              (product.salePrice.isNotEmpty)
                                  ? formatStringCurrency(
                                      total: product.regularPrice,
                                      context: context)
                                  : formatStringCurrency(
                                      total: product.regularPrice,
                                      context: context),
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: Constant.fontsFamily),
                            ),
                            getHorSpace(6.h),
                            (product.salePrice.isNotEmpty)
                                ? getCustomFont(
                                    (homeScreenController.variationModel ==
                                            null)
                                        ? "${100 * (double.parse(product.regularPrice) - double.parse(product.salePrice)) ~/ double.parse(product.regularPrice)}% OFF"
                                        : getCurrency(context) +
                                                homeScreenController
                                                    .variationModel!
                                                    .regularPrice ??
                                            "",
                                    14.sp,
                                    buttonColor,
                                    1,
                                    fontWeight: FontWeight.w700)
                                : SizedBox(),
                          ],
                        ).paddingSymmetric(horizontal: 12.h)
                      : getVerSpace(0.h),
                  product.onSale ? getVerSpace(0.h) : getVerSpace(7.h),

                  Container(
                      padding:
                          EdgeInsetsDirectional.only(start: 12.h, bottom: 5.h),
                      height: 24.h,
                      child: Hero(
                        tag: "main${index}price",
                        transitionOnUserGestures: true,
                        child: getCustomFont(
                            formatStringCurrency(
                                total: product.onSale
                                    ? product.salePrice
                                    : product.price,
                                context: context),
                            16.sp,
                            regularBlack,
                            1,
                            fontWeight: FontWeight.w600),
                      ))
                ],
              ),
              Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: favoriteIconFWidget)
            ],
          )));
}

Widget productDataFormateGridView1(context, function1, WooProduct product,
    favoriteIconFWidget, addButtonWidget, int index) {
  return GestureDetector(
      onTap: () {
        function1();
      },
      child: Container(
          height: 280.h,
          width: 200.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.h),
              border: Border.all(color: black20),
              color: regularWhite),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(top: 14.h),
                          child: Hero(
                            tag: 'main${index}${product.images[0].src}',
                            child: CachedNetworkImage(
                                    imageUrl: product.images[0].src,
                                    height: 146.h,
                                    width: 153.h,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Center(
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              decoration: getButtonDecoration(
                                                  gray,
                                                  withCorners: true,
                                                  corner: 12.h),
                                              height: 146.h,
                                              width: double.infinity,
                                            ).paddingOnly(
                                                top: 14.h,
                                                left: 20.h,
                                                right: 20.h),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        getAssetImage("no_image_banner.png"))
                                .paddingOnly(top: 14.h),
                          ),
                        ),
                      ),
                      product.onSale
                          ? Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Container(
                                margin: EdgeInsetsDirectional.only(
                                    top: 10.h, start: 14.h),
                                padding: EdgeInsetsDirectional.symmetric(
                                    vertical: 2.h, horizontal: 8.h),
                                decoration: BoxDecoration(
                                    color: buttonColor,
                                    borderRadius: BorderRadius.circular(12.h)),
                                child: getCustomFont(
                                    "SALE", 12.sp, Colors.white, 1,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center),
                              ))
                          : 0.h.horizontalSpace,
                    ],
                  ),
                  // getVerSpace(7.h),
                  Spacer(),
                  product.averageRating == "0.00"
                      ? getVerSpace(13.h)
                      : Hero(
                          tag: "main${index}rating",
                          transitionOnUserGestures: true,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              getSvgImage("gray_star_icon.svg",
                                  height: 12.h, width: 12.h),
                              getHorSpace(4.h),
                              getCustomFont(
                                  "${product.averageRating}(${product.ratingCount.toString()})",
                                  12.sp,
                                  regularBlack,
                                  1,
                                  fontWeight: FontWeight.w400),
                            ],
                          ).paddingSymmetric(horizontal: 12.h),
                        ),
                  getVerSpace(6.h),
                  //
                  Container(
                    height: product.name.length > 30 ? 42.h : 21.h,
                    child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: "main${index}${product.name}",
                          child: getMultilineCustomFont(
                                  "${product.name}", 14.sp, regularBlack,
                                  fontWeight: FontWeight.w600, txtHeight: 1.5.h)
                              .paddingOnly(
                            left: 12.h,
                            right: 12.h,
                          ),
                        )),
                  ),

                  // getVerSpace(6.h),
                  product.onSale
                      ? Row(
                          children: [
                            Text(
                              (product.salePrice.isNotEmpty)
                                  ? formatStringCurrency(
                                      total: product.regularPrice,
                                      context: context)
                                  : formatStringCurrency(
                                      total: product.regularPrice,
                                      context: context),
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: Constant.fontsFamily),
                            ),
                            getHorSpace(6.h),
                            (product.salePrice.isNotEmpty)
                                ? getCustomFont(
                                    (homeScreenController.variationModel ==
                                            null)
                                        ? "${100 * (double.parse(product.regularPrice) - double.parse(product.salePrice)) ~/ double.parse(product.regularPrice)}% OFF"
                                        : getCurrency(context) +
                                                homeScreenController
                                                    .variationModel!
                                                    .regularPrice ??
                                            "",
                                    14.sp,
                                    buttonColor,
                                    1,
                                    fontWeight: FontWeight.w700)
                                : SizedBox(),
                          ],
                        ).paddingSymmetric(horizontal: 12.h)
                      : getVerSpace(0.h),
                  product.onSale ? getVerSpace(0.h) : getVerSpace(7.h),

                  Container(
                      padding:
                          EdgeInsetsDirectional.only(start: 12.h, bottom: 5.h),
                      height: 24.h,
                      child: Hero(
                        tag: "main${index}price",
                        transitionOnUserGestures: true,
                        child: getCustomFont(
                            formatStringCurrency(
                                total: product.onSale
                                    ? product.salePrice
                                    : product.price,
                                context: context),
                            16.sp,
                            regularBlack,
                            1,
                            fontWeight: FontWeight.w600),
                      ))
                ],
              ),
              Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: favoriteIconFWidget)
            ],
          )));
}

List<WooProductVariation> listVariation = [];
HomeScreenController homeScreenController = Get.find<HomeScreenController>();
RxList<Attribute> selectedAttributes = <Attribute>[].obs;

void changeVariationValue() {
  homeScreenController.changeVariation(listVariation[listVariation
      .indexOf(WooProductVariation(attributes: selectedAttributes))]);
}

Widget getCheckCartWidgetWithoutVariation({
  required WooProduct product,
  required RxInt currentQuantity,
  required var cartOtherInfoList,
  required Function changeCoupon,
  required Function(CartOtherInfo) addInfo,
  required Function(WooProduct) updateProduct,
}) {
  return FutureBuilder<List<int>>(
    future: PrefData.getCartIdList(),
    builder: (context, snapshot) {
      bool i = false;
      if (snapshot.data != null) {
        i = snapshot.data!.contains(product.id);
      }
      return (!i)
          ? GestureDetector(
              onTap: () async {
                if (cartOtherInfoList.isEmpty) {
                  changeCoupon();
                }
                if (!i) {
                  context.loaderOverlay.show(showOverlay: getProgressDialog());
                  final snackBar = SnackBar(
                    content: Text('Added to cart'),
                    duration: Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  addInfo(CartOtherInfo(
                      variationId: 0,
                      variationList: [],
                      productId: product.id,
                      quantity: currentQuantity.value,
                      stockStatus: product.stockStatus,
                      type: product.type,
                      productName: product.name,
                      productImage: product.images[0].src,
                      productPrice: product.onSale
                          ? parseWcPrice(product.salePrice)
                          : parseWcPrice(product.regularPrice),
                      taxClass: product.taxClass));
                  context.loaderOverlay.hide();

                  updateProduct(product);
                } else {
                  for (int i = 0; i < cartOtherInfoList.length; i++) {
                    CartOtherInfo element = cartOtherInfoList[i];

                    if (element.productId == product.id) {
                      [];
                      element.variationId = 0;
                      element.productPrice = product.onSale
                          ? parseWcPrice(product.salePrice)
                          : parseWcPrice(product.regularPrice);
                    }
                  }
                }
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 36.h,
                  width: 36.h,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(6.h)),
                  child: getSvgImage("add_icon_white.svg",
                          height: 24.h, width: 24.h)
                      .paddingAll(6.h),
                ),
              ).paddingOnly(bottom: 16.h, right: 16.h),
            )
          : GestureDetector(
              onTap: () {},
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 36.h,
                  width: 36.h,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(6.h)),
                  child: getSvgImage("tick_icon.svg", height: 24.h, width: 24.h)
                      .paddingAll(6.h),
                ),
              ).paddingOnly(bottom: 16.h, right: 16.h),
            );
    },
  );
}

ShapeDecoration getButtonDecoration(Color bgColor,
    {withBorder = false,
    Color borderColor = Colors.transparent,
    bool withCorners = true,
    double corner = 0,
    double cornerSmoothing = 1.1,
    List<BoxShadow> shadow = const []}) {
  return ShapeDecoration(
      color: bgColor,
      shadows: shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.h)));
}
