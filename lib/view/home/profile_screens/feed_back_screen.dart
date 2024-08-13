import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import '../../../generated/l10n.dart';
import '../../../utils/constant.dart';
import '../../../woocommerce/models/customer.dart';

class FeedBack extends StatefulWidget {
  FeedBack({Key? key}) : super(key: key);

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: Scaffold(
        backgroundColor: regularWhite,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Container(
            color: bgColor,
            child: Column(
              children: [
                Container(
                  color: regularWhite,
                  child: getAppBar(S.of(context).feedback, function: () {
                    Get.back();
                  }, space: 105.h),
                ),
                getVerSpace(8.h),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: regularWhite,
                    child: ListView(
                      primary: true,
                      shrinkWrap: false,
                      padding: EdgeInsets.symmetric(horizontal: 0.h),
                      children: [
                        Column(
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
                            SizedBox(height: 20.h),
                            getCustomFont(S.of(context).tellUsWhatCanBeImproved,
                                16.sp, regularBlack, 1,
                                fontWeight: FontWeight.w600),
                            SizedBox(height: 20.h),
                            TextFormField(
                              controller: feedbackController,
                              textInputAction: TextInputAction.done,
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
                                          color: Color(0XFFDFDFDF),
                                          width: 1.h)),
                                  hintText: S.of(context).writeYourFeedback,
                                  hintStyle: TextStyle(
                                      color: Color(0XFF6E758A),
                                      fontSize: 16.sp,
                                      fontFamily: Constant.fontsFamily)),
                              maxLines: 5,
                            ),
                          ],
                        ).paddingSymmetric(vertical: 20.h, horizontal: 20.h),
                      ],
                    ),
                  ),
                ),
                getCustomButton(S.of(context).submit, () {
                  sendMail();
                }).paddingOnly(bottom: 40.h, left: 20.h, right: 20.h)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendMail() async {
    WooCustomer? wooCustomer = homeMainScreenController.currentCustomer;
    final Email email = Email(
      body: feedbackController.text,
      subject: 'Gift Shop',
      recipients: [wooCustomer!.email!],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  ratingbar() {
    return RatingBar(
      initialRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 42,
      glow: false,
      ratingWidget: RatingWidget(
        full: getSvgImage("fidbackfillicon.svg"),
        half: getSvgImage("fidbackemptyicon.svg"),
        empty: getSvgImage("fidbackemptyicon.svg"),
      ),
      itemPadding: EdgeInsets.symmetric(horizontal: 10),
      onRatingUpdate: (rating) {},
    );
  }
}
