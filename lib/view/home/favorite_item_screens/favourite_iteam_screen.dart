// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:ravasiya_collections/utils/pref_data.dart';

import '../../../generated/l10n.dart';
import '../../../model/my_cart_data.dart';
import '../../../utils/constant.dart';
import '../../../woocommerce/models/products.dart';

class FavouriteItemScreen extends StatefulWidget {
  const FavouriteItemScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteItemScreen> createState() => _FavouriteItemScreenState();
}

class _FavouriteItemScreenState extends State<FavouriteItemScreen> {
  ProductDataController productController = Get.put(ProductDataController());
  FilterController controller = Get.put(FilterController());
  CartControllerNew cartControllerNew = Get.put(CartControllerNew());
  HomeMainScreenController homeMainScreenController =
      Get.put(HomeMainScreenController());
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  HomeScreenController storageController = Get.put(HomeScreenController());
  RxInt cartIndex = 0.obs;

  RxList<String> favProductList = <String>[].obs;

  getFavourit() {

    if(homeMainScreenController.checkNullOperator()){
      return [];
    }

    productController
        .getAllFavouriteList(homeMainScreenController.wooCommerce1!);
  }

  void getFavDataList() async {
    favProductList.value = PrefData().getFavouriteList();
  }

  @override
  void initState() {
    super.initState();
    getFavDataList();
  }

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
              body: Column(
                children: [
                  Container(
                    color: regularWhite,
                    child: getAppBar(S.of(context).wishlist, function: () {
                      Get.back();
                    }, space: 131.h),
                  ),
                  getVerSpace(12.h),
                  ObxValue<RxBool>((p0) {
                    if (!p0.value &&
                        productController.favProductList.isNotEmpty) {
                      return Expanded(
                        child: Container(
                          color: regularWhite,
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.h, vertical: 20.h),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 280.h,
                                    mainAxisSpacing: 20.h,
                                    crossAxisSpacing: 20.h),
                            itemCount: productController.favProductList.length,
                            itemBuilder: (BuildContext context, int index) {

                              if(homeMainScreenController.checkNullOperator()){
                                return Container();
                              }

                              return FutureBuilder<WooProduct>(
                                future: homeMainScreenController.wooCommerce1!
                                    .getYouProduct(
                                        id: int.parse(productController
                                            .favProductList[index]),
                                        wooCommerceAPI:
                                            homeMainScreenController.api1!),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    WooProduct product = snapshot.data!;
                                    return productDataFormateGridView(context,
                                        () {
                                      homeScreenController
                                          .setSelectedWooProduct(product);
                                      storageController.clearProductVariation();

                                      sendToPlanDetail(
                                        id: "${product.id}",
                                          tag:
                                              "main${index}${product.images[0].src}",
                                          function: () {
                                            getFavDataList();
                                            getFavourit();
                                          },
                                          titleTag:
                                              "main${index}${product.name}",
                                          priceTag: "main${index}price",
                                          ratingTag: "main${index}rating");


                                    },
                                        product,
                                        GestureDetector(
                                          onTap: () {
                                            productController.favProductList
                                                .remove(product.id.toString());
                                            List<String> strList =
                                                productController.favProductList
                                                    .map((i) => i.toString())
                                                    .toList();
                                            PrefData()
                                                .setFavouriteList(strList);
                                          },
                                          child: Obx(
                                            () {
                                              return getSvgImage(
                                                      productController
                                                              .favProductList
                                                              .contains(product
                                                                  .id
                                                                  .toString())
                                                          ? "likefillIconnew.svg"
                                                          : "likeIconnew.svg",
                                                      height: 22.h,
                                                      width: 22.h)
                                                  .marginOnly(
                                                      top: 10.h,
                                                      right: 14.h,
                                                      left: 15.h);
                                            },
                                          ),
                                        ),
                                        index);
                                  } else {
                                    return productDataFormateGridViewShimmer();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      );
                    } else if (!p0.value &&
                        productController.favProductList.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: getEmptyWidget(
                              context,
                              Constant.wishlistEmptyLogo,
                              S.of(context).noFavouritesYet,
                              S.of(context).exploreMoreAndShortlistSomeProducts,
                              S.of(context).addFavourites, () {
                            homeMainScreenController.change(0);
                            homeMainScreenController.tabController!.animateTo(
                              0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                            Get.back();
                          }).paddingSymmetric(horizontal: 20.h),
                        ),
                      );
                    } else {
                      return Expanded(child: getProgressDialog());
                    }
                  }, productController.isFavouriteLoading)
                ],
              ),
            ),
          )),
    );
  }

  checkAlreadyInCart(WooProduct product) {
    if (cartControllerNew.cartOtherInfoList.isNotEmpty) {
      var selectedId = product.id;

      for (int i = 0; i < cartControllerNew.cartOtherInfoList.length; i++) {
        CartOtherInfo element = cartControllerNew.cartOtherInfoList[i];
        if (element.productId == selectedId) {
          cartIndex.value = i;
          storageController.setCurrentQuantity((element.quantity ?? 1));

          setState(() {
            storageController.setPurchaseValue(true);
          });
          return;
        }
      }
    }
  }
}
