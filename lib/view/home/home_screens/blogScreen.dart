// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ravasiya_collections/routes/app_routes.dart';

import '../../../controller/controller.dart';
import '../../../generated/l10n.dart';
import '../../../utils/color_category.dart';
import '../../../utils/constant.dart';
import '../../../utils/constantWidget.dart';
import '../../../woocommerce/models/posts.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  BlogScreenController blogScreenController = Get.put(BlogScreenController());

  Future<bool> _future = Future<bool>.delayed(
    Duration(milliseconds: 400),
    () {
      return true;
    },
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
          onWillPop: () {
            return Future.value(true);
          },
          child: SafeArea(
            child: Scaffold(
                backgroundColor: bgColor,
                body: GetBuilder<BlogScreenController>(
                  init: BlogScreenController(),
                  builder: (blogScreenController) => Column(
                    children: [
                      Container(
                          height: 73.h,
                          width: double.infinity,
                          color: regularWhite,
                          child: getAppBar(
                            S.of(context).blog,
                            space: 140.h,
                            function: () {
                              Get.back();
                            },
                          )),
                      getVerSpace(20.h),
                      Expanded(
                          child: Container(
                        child: FutureBuilder<bool>(
                          future: _future,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            return blogList();
                          },
                        ),
                      ))
                    ],
                  ),
                )),
          )),
    );
  }

  Widget blogList() {
    return GetBuilder<ProductDataController>(
      init: ProductDataController(),
      builder: (controller) {
        if (controller.postsList.isNotEmpty) {
          return AnimationLimiter(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) {
                return SizedBox(height: 16.h);
              },
              itemCount: controller.postsList.length,
              itemBuilder: (context, index) {
                Posts model = controller.postsList[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.blogDetailRoute, arguments: model);
                  },
                  child: AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: listwalkingfitnessItemWidget(
                            model,
                          ),
                        ),
                      )),
                ).paddingSymmetric(vertical: 0.h);
              },
            ),
          );
        } else {
          return getProgressDialog();
        }
      },
    );
  }

  Widget listwalkingfitnessItemWidget(Posts model) {
    DateTime dateTime = DateTime.parse(model.date.toString());
    String date = DateFormat("dd MMM,yyyy").format(dateTime);
    return
      Container(
          width: double.infinity,
          // height: 245.h,
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(16.h),
          //     border: Border.all(color: black20)
          // ),
        color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 170.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.h),
                  image: DecorationImage(
                      image: NetworkImage(
                        model.embedded!.wpFeaturedmedia![0]!.sourceUrl.toString(),
                      ),
                      fit: BoxFit.fill),
                ),
              ).paddingOnly(top: 12.h, left: 12.h, right: 12.h, bottom: 12.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getCustomFont(
                      model.title!.rendered.toString(), 16.sp, regularBlack, 2,
                      fontWeight: FontWeight.w700,
                      overflow: TextOverflow.ellipsis),
                  getVerSpace(4.h),
                  getCustomFont(date.toString(), 14.sp, regularBlack, 1,
                      fontWeight: FontWeight.w500)
                ],
              ).paddingOnly(left: 12.h, right: 12.h,bottom: 12.h)
            ],
          ),);
    //   Container(
    //   color: regularWhite,
    //   width: double.infinity,
    //   child: Row(
    //     children: [
    //       Container(
    //         height: 118.h,
    //         width: 118.h,
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(16.h),
    //             color: gray,
    //             image: DecorationImage(
    //                 image: NetworkImage(model
    //                     .embedded!.wpFeaturedmedia![0]!.sourceUrl
    //                     .toString()),
    //                 fit: BoxFit.fill)),
    //       ),
    //       getHorSpace(16.h),
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             getMultilineCustomFont(
    //                 model.title!.rendered.toString(), 16.sp, regularBlack,
    //                 fontWeight: FontWeight.w600),
    //             getVerSpace(6.h),
    //             getCustomFont(date, 16.sp, regularBlack, 1,
    //                 fontWeight: FontWeight.w400)
    //           ],
    //         ),
    //       )
    //     ],
    //   ).paddingAll(20.h),
    // ).paddingSymmetric(vertical: 0.h);
  }
}
