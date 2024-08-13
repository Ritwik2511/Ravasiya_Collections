// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ravasiya_collections/utils/color_category.dart';

import '../../../controller/controller.dart';
import '../../../generated/l10n.dart';
import '../../../utils/constant.dart';
import '../../../utils/constantWidget.dart';
import '../../../woocommerce/models/posts.dart';

class BlogDetailScreen extends StatefulWidget {
  const BlogDetailScreen({Key? key}) : super(key: key);

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  BlogDetailScreenController blogDetailScreenController =
      Get.put(BlogDetailScreenController());
  Posts detail = Get.arguments;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(detail.date.toString());
    String date = DateFormat("dd MMM,yyyy").format(dateTime);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Align(
          alignment: Alignment.topCenter,
          child: Scaffold(
            backgroundColor: regularWhite,
            body: GetBuilder<BlogDetailScreenController>(
              init: BlogDetailScreenController(),
              builder: (blogDetailScreenController) => SafeArea(
                child: Container(
                  color: bgColor,
                  child: Column(children: [
                    Container(
                        width: double.infinity,
                        color: regularWhite,
                        child: getAppBar(S.of(context).blog, function: () {
                          Get.back();
                        })),
                    getVerSpace(8.h),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: regularWhite,
                        ),
                        child: Container(
                          child: ListView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getVerSpace(20.h),
                                  getMultilineCustomFont(
                                      detail.title!.rendered.toString(),
                                      20.sp,
                                      regularBlack,
                                      fontWeight: FontWeight.w700,
                                      txtHeight: 1.5.h),
                                  getVerSpace(6.h),
                                  getCustomFont(date, 14.sp, darkGray, 1,
                                      fontWeight: FontWeight.w400),
                                  getVerSpace(17.h),
                                  HtmlWidget(
                                    "${detail.content!.rendered}",
                                    onLoadingBuilder:
                                        (context, element, loadingProgress) {
                                      return getProgressDialog();
                                    },
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 20.h, vertical: 0.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
