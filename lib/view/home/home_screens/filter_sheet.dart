import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';

import '../../../controller/controller.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../utils/constant.dart';

// ignore_for_file: must_be_immutable
class FilterBottomsheet extends StatelessWidget {
  FilterBottomsheet(this.controller);

  FilterController controller;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.h),
            color: regularWhite,
          ),
          width: double.maxFinite,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 20.h,
              top: 10.h,
              right: 20.h,
              bottom: 14.h,
            ),
            decoration: BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 4.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                    color: '#1A12121D'.toColor(),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 22.h,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      getCustomFont(S.of(context).sortBy, 20.h, regularBlack, 1,
                          fontWeight: FontWeight.w700),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 30.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                                color: lightColor, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: getSvgImage("close.svg",
                                height: 14.h, width: 14.h),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.changeSort("New Added");
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 24.h, bottom: 16.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: getCustomFont(
                          S.of(context).newAdded, 16.h, regularBlack, 1,
                          fontWeight: controller.sortItem.value == "New Added"
                              ? FontWeight.w600
                              : FontWeight.w400),
                    ),
                  ),
                ),
                getDivider(color: dividerColor, horPadding: 0),
                InkWell(
                  onTap: () {
                    controller.changeSort("Lowest Price");
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: getCustomFont(
                          S.of(context).lowestPrice, 16.h, regularBlack, 1,
                          fontWeight:
                              controller.sortItem.value == "Lowest Price"
                                  ? FontWeight.w600
                                  : FontWeight.w400),
                    ),
                  ),
                ),
                // getVerSpace(16.h),
                getDivider(color: dividerColor, horPadding: 0),
                InkWell(
                  onTap: () {
                    controller.changeSort("Highest Price");
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: getCustomFont(
                          S.of(context).highestPrice, 16.h, regularBlack, 1,
                          fontWeight:
                              controller.sortItem.value == "Highest Price"
                                  ? FontWeight.w600
                                  : FontWeight.w400),
                    ),
                  ),
                ),
                getVerSpace(16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
