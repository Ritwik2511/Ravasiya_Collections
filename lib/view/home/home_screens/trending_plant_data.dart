// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';

import '../../../controller/controller.dart';
import '../../../generated/l10n.dart';
import '../../../utils/constant.dart';
import '../../../utils/pref_data.dart';
import '../../../woocommerce/models/products.dart';
import 'filter_sheet.dart';

class TrendingPlantSCreen extends StatefulWidget {
  const TrendingPlantSCreen({Key? key}) : super(key: key);

  @override
  State<TrendingPlantSCreen> createState() => _TrendingPlantSCreenState();
}

class _TrendingPlantSCreenState extends State<TrendingPlantSCreen>
    with SingleTickerProviderStateMixin {
  HomeScreenController storageController = Get.put(HomeScreenController());
  ProductDataController productController = Get.put(ProductDataController());
  RxList<String> favProductList = <String>[].obs;
  HomeMainScreenController homeMainScreenController =
      Get.put(HomeMainScreenController());

  late AnimationController animationController;
  int dialogSecond = 300;

  void getFavDataList() async {
    favProductList.value = PrefData().getFavouriteList();
  }

  checkInFavouriteList(WooProduct cat) async {
    if (favProductList.contains(cat.id.toString())) {
      favProductList.remove(cat.id.toString());
    } else {
      favProductList.add(cat.id.toString());
    }
  }

  @override
  void initState() {
    animationController = BottomSheet.createAnimationController(this);
    animationController.duration = Duration(milliseconds: dialogSecond);
    animationController.reverseDuration = Duration(milliseconds: dialogSecond);
    Future.delayed(Duration.zero, () async {
      homeScreenController.cleanFetchData();
      getFavDataList();
      homeScreenController.fetchData(homeMainScreenController);
      getFavourit();
    });

    super.initState();
  }

  dispose() {
    animationController.dispose();
    super.dispose();
  }

  getFavourit() {

    if(homeMainScreenController.checkNullOperator()){
      return ;
    }

    productController
        .getAllFavouriteList(homeMainScreenController.wooCommerce1!);
  }

  Widget buildPostsView(HomeScreenController controller) {
    if (controller.bestSellingList.isEmpty) {
      if (controller.loading) {
        return Center(child: getProgressDialog());
      } else if (controller.error) {
        return Center(child: CircularProgressIndicator());
      }
    }

    return Container(
      color: regularWhite,
      child: AnimationLimiter(
        child: GridView.builder(
          primary: false,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: controller.bestSellingList.length < 2 ? 1 : 2,
              mainAxisExtent: 280.h,
              mainAxisSpacing: 20.h,
              crossAxisSpacing: 20.h),
          itemCount: controller.bestSellingList.length +
              (controller.isLastPage ? 0 : 1),
          itemBuilder: (BuildContext context, int index) {
            if (index ==
                controller.bestSellingList.length -
                    controller.nextPageTrigger) {
              // fetchData();
              homeScreenController.fetchData(homeMainScreenController);
            }
            if (index == controller.bestSellingList.length) {
              if (controller.error) {
                return Center(child: CircularProgressIndicator());
              } else {
                return productDataFormateGridViewShimmer();
              }
            }
            WooProduct product = controller.bestSellingList[index];

            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: productDataFormateGridView(context, () {
                    storageController.setSelectedWooProduct(product);
                    storageController.clearProductVariation();

                    sendToPlanDetail(
                      id: "${product.id}",
                        tag: "main${index}${product.images[0].src}",
                        function: () {
                          getFavDataList();
                        },
                        titleTag: "main${index}${product.name}",
                        priceTag: "main${index}price",
                        ratingTag: "main${index}rating");
                  },
                      product,
                      GestureDetector(
                        onTap: () {
                          checkInFavouriteList(product);
                          List<String> strList =
                              favProductList.map((i) => i.toString()).toList();
                          PrefData().setFavouriteList(strList);
                          getFavourit();
                        },
                        child: Obx(
                          () {
                            return getSvgImage(
                                    favProductList
                                            .contains(product.id.toString())
                                        ? "likefillIconnew.svg"
                                        : "likeIconnew.svg",
                                    height: 22.h,
                                    width: 22.h)
                                .marginOnly(top: 10.h, right: 14.h, left: 15.h);
                          },
                        ),
                      ),
                      index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        child: Scaffold(
          backgroundColor: regularWhite,
          body: SafeArea(
              child: Container(
            color: bgColor,
            child: GetBuilder<HomeScreenController>(
              init: HomeScreenController(),
              builder: (homeScreem) => Column(
                children: [
                  GetBuilder<FilterController>(
                    init: FilterController(),
                    builder: (controller) => Container(
                        height: 73.h,
                        width: double.infinity,
                        color: regularWhite,
                        child: simpleAppBar(S.of(context).trendingProduct,
                            space: 89.h, function: () {
                          storageController.clearTrending();
                          Get.back();
                        }, filterFunction: () {
                          showModalBottomSheet(
                            transitionAnimationController: animationController,
                            backgroundColor: regularWhite,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.h))),
                            context: context,
                            builder: (context) {
                              return FilterBottomsheet(
                                Get.put(
                                  FilterController(),
                                ),
                              );
                            },
                          ).then((value) {
                            homeScreenController.filterTranding(controller);
                          });
                        })),
                  ),
                  getVerSpace(8.h),
                  Expanded(
                    child: Container(
                      color: regularWhite,
                      child: buildPostsView(homeScreem),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
        onWillPop: () async {
          storageController.clearTrending();
          Get.back();
          return false;
        },
      ),
    );
  }
}
