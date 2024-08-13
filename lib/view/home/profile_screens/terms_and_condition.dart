// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constant.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';

import '../../../generated/l10n.dart';

class TermCondition extends StatefulWidget {
  const TermCondition({Key? key}) : super(key: key);

  @override
  State<TermCondition> createState() => _TermConditionState();
}

class _TermConditionState extends State<TermCondition> {
  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: SafeArea(
        child: WillPopScope(
            onWillPop: () {
              return Future.value(true);
            },
          child: Scaffold(
            backgroundColor: bgColor,
              body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              color: regularWhite,
              child: getAppBar(S.of(context).termsAndConditions, space: 20.w, function: () {
                Get.back();
              }),
            ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        color: regularWhite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            question(S.of(context).typesOfDataWeCollect),
                            getVerSpace(16.h),
                            answer(
                                S.of(context).loremIpsumIsSimplyDummyTextOfThePrintingAnd),

                          ],
                        ).paddingSymmetric(horizontal: 20.h,vertical: 20.h),
                      ).paddingSymmetric(vertical: 10.h),
                      Container(
                        color: regularWhite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            question(S.of(context).UseOfYourPersonalData),
                            getVerSpace(16.h),
                            answer(
                                S.of(context).loremIpsumIsSimplyDummyTextOfThePrintingAnd),
                          ],
                        ).paddingSymmetric(horizontal: 20.h,vertical: 20.h),
                      ).paddingSymmetric(vertical: 10.h),
                      Container(
                        color: regularWhite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            question(S.of(context).DisclosureOfYourPersonalData),
                            getVerSpace(16.h),
                            answer(
                                S.of(context).loremIpsumIsSimplyDummyTextOfThePrintingAnd),
                          ],
                        ).paddingSymmetric(horizontal: 20.h,vertical: 20.h),
                      ).paddingSymmetric(vertical: 10.h),
                    ],
                  ),
                )
          ])),
        ),
      ),
    );
  }

  question(String s) {
    return Text(
      s,
      style: TextStyle(
          fontSize: 18.sp,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.bold,
          color: Color(0XFF000000)),
    );
  }

  answer(String s) {
    return Text(
      s,
      style: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Gilroy',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          color: Color(0XFF6E758A)),
    );
  }
}
