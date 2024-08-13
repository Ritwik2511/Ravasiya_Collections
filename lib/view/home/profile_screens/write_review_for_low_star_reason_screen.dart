import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import '../../../utils/color_category.dart';
import '../../../utils/constant.dart';
import '../../../utils/constantWidget.dart';

class WriteReviewForLowStarReason extends StatefulWidget {
  const WriteReviewForLowStarReason({Key? key}) : super(key: key);

  @override
  State<WriteReviewForLowStarReason> createState() =>
      _WriteReviewForLowStarReasonState();
}

class _WriteReviewForLowStarReasonState
    extends State<WriteReviewForLowStarReason> {
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: Scaffold(
        backgroundColor: regularWhite,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: bgColor,
            child: Column(
              children: [
                Container(
                  color: regularWhite,
                  child: getAppBar(S.of(context).writeReview, function: () {
                    // backClick(context);
                    Get.back();
                  }, space: 105.h),
                ),
                getVerSpace(8.h),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 0.h),
                    children: [
                      Container(
                        width: double.infinity,
                        color: regularWhite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomFont(S.of(context).giveFeedback, 28.sp,
                                regularBlack, 1,
                                fontWeight: FontWeight.w700),
                            SizedBox(height: 12.h),
                            getCustomFont(
                                S.of(context).giveYourFeedbackAboutOurApp,
                                16.sp,
                                regularBlack,
                                1,
                                fontWeight: FontWeight.w400),
                            SizedBox(height: 40.h),
                            getCustomFont(
                                S.of(context).areYouSatisfiedWithThisApp,
                                16.sp,
                                regularBlack,
                                1,
                                fontWeight: FontWeight.w400),
                            SizedBox(height: 40.h),
                            getCustomFont(S.of(context).tellUsWhatCanBeImproved,
                                16.sp, regularBlack, 1,
                                fontWeight: FontWeight.w600),
                            SizedBox(height: 20.h),
                            TextFormField(
                              controller: feedbackController,
                              cursorColor: buttonColor,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.h))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                          color: regularBlack, width: 1.h)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                          color: Color(0XFFDFDFDF), width: 1.h)),
                                  hintText: S.of(context).writeYourFeedback,
                                  hintStyle: TextStyle(
                                      color: Color(0XFF6E758A),
                                      fontSize: 16.sp,
                                      fontFamily: Constant.fontsFamily)),
                              maxLines: 5,
                            ),
                          ],
                        ).paddingSymmetric(vertical: 20.h, horizontal: 20.h),
                      ),
                    ],
                  ),
                ),
                getCustomButton(S.of(context).submit, () {
                  sendMail(feedbackController.text);
                }).paddingOnly(bottom: 40.h, left: 20.h, right: 20.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
