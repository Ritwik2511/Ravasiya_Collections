// // ignore_for_file: deprecated_member_use
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:ravasiya_collections/controller/controller.dart';
// import 'package:ravasiya_collections/utils/category_cache.dart';
// import 'package:ravasiya_collections/utils/color_category.dart';
// import 'package:ravasiya_collections/utils/constantWidget.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
//
// import '../../../generated/l10n.dart';
// import '../../../routes/app_routes.dart';
// import '../../../utils/constant.dart';
// import '../../../woocommerce/models/woo_get_created_order.dart';
//
// class MyOrders extends StatefulWidget {
//   const MyOrders({Key? key}) : super(key: key);
//
//   @override
//   State<MyOrders> createState() => _MyOrdersState();
// }
//
// class _MyOrdersState extends State<MyOrders> {
//   RefreshController _refreshController =
//       RefreshController(initialRefresh: false);
//   LoginEmptyStateController loginEmptyStateController =
//       Get.put(LoginEmptyStateController());
//   HomeMainScreenController homeMainScreenController =
//       Get.put(HomeMainScreenController());
//   HomeMainScreenController bottomController =
//       Get.find<HomeMainScreenController>();
//
//   // PagingController<int, WooGetCreatedOrder> pagingController =
//   //     PagingController(firstPageKey: 1);
//   OrderConfirmScreenController orderConfirmScreenController =
//       Get.find<OrderConfirmScreenController>();
//
//   RxBool isDispose = false.obs;
//
//   int pageKey = 1;
//
//   @override
//   void initState() {
//     // pagingController.addPageRequestListener((pageKey) {
//     //   this.pageKey = pageKey;
//     // });
//     // fetchPage(pageKey);
//     Future.delayed(Duration(seconds: 2), () {
//       isDispose.value = true;
//     });
//     super.initState();
//   }
//
//   Future<List<WooGetCreatedOrder>> fetchPage() async {
//     try {
//       // if(homeMainScreenController.checkNullOperator()){
//       //   return ;
//       // }
//       final newItems =
//           await homeMainScreenController.api1!.get("orders?per_page=100");
//       List parseRes = newItems;
//       List<WooGetCreatedOrder> postList =
//           parseRes.map((e) => WooGetCreatedOrder.fromJson(e)).toList();
//       print("sdsdsdsd====${postList[0].id}");
//       return postList;
//     } catch (error) {
//       // pagingController.error = error;
//       return [];
//     }
//   }
//
//
//   backClick(BuildContext context) {
//     if (homeMainScreenController.isSetting.value == false) {
//       homeMainScreenController.change(0);
//       homeMainScreenController.tabController!.animateTo(
//         0,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.ease,
//       );
//       Get.offNamed(Routes.homeMainRoute);
//     } else {
//       homeMainScreenController.change(3);
//       homeMainScreenController.tabController!.animateTo(
//         3,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.ease,
//       );
//       Get.offNamed(Routes.homeMainRoute);
//     }
//   }
//
//   int page = 1;
//
//   bool productLastPage = false;
//
//   bool isOrder = true;
//
//   Widget buildPostsView(ProductDataController productDataController) {
//     return FutureBuilder(
//       future: fetchPage(),
//
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               snapshot.error.toString(),
//             ),
//           );
//         }
//         if (snapshot.hasData) {
//           List list = snapshot.data as List<WooGetCreatedOrder>;
//
//           return ListView.separated(
//             padding: EdgeInsets.zero,
//             shrinkWrap: true,
//             separatorBuilder: (context, index) {
//               return Container(
//                 height: 8.h,
//                 color: bgColor,
//               );
//             },
//             // physics: BouncingScrollPhysics(),
//             itemCount: list.length,
//
//             itemBuilder: (context, index) {
//               WooGetCreatedOrder order = list[index];
//               int quantity = 0;
//               for (var element in order.lineItems!) {
//                 quantity = quantity + element.quantity!;
//               }
//               DateTime dateTime = DateTime.parse(order.dateCreated ?? "");
//               String date = DateFormat("dd-MMM-yyyy").format(dateTime);
//               String timr = DateFormat("hh:mm a").format(dateTime);
//               return Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
//                 color: regularWhite,
//                 child: InkWell(
//                   onTap: () {
//                     Get.toNamed(Routes.trackOrderRoute, arguments: order);
//                   },
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           getCustomFont("${S.of(context).orderId} ${order.id}",
//                               16.sp, regularBlack, 1,
//                               fontWeight: FontWeight.w600),
//                           Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(37.h),
//                                 color: Constant.getOrderStatusColor(
//                                         order.status ?? "", context)
//                                     .withOpacity(0.14)),
//                             child: getCustomFont(
//                                     order.status![0].toUpperCase() +
//                                         order.status!.substring(1),
//                                     16.sp,
//                                     Constant.getOrderStatusColor(
//                                         order.status ?? "", context),
//                                     1,
//                                     fontWeight: FontWeight.w600)
//                                 .paddingSymmetric(
//                                     vertical: 5.h, horizontal: 10.h),
//                           ),
//                         ],
//                       ),
//                       getVerSpace(4.h),
//                       Row(
//                         children: [
//                           Container(
//                             height: 10.h,
//                             width: 10.h,
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle, color: buttonColor),
//                           ),
//                           getHorSpace(8.h),
//                           getCustomFont(
//                               "${S.of(context).orderAt} ${timr} | ${date}",
//                               16.sp,
//                               regularBlack,
//                               1,
//                               fontWeight: FontWeight.w400)
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//         return Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           color: Colors.white,
//           alignment: Alignment.center,
//           child: CircularProgressIndicator(
//             color: buttonColor,
//           ),
//         );
//       },
//       // ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     initializeScreenSize(context);
//     return Directionality(
//       textDirection: Constant.getSetDirection(context),
//       child: WillPopScope(
//         onWillPop: () async {
//           if (!isDispose.value) {
//             return false;
//           }
//
//           if (orderConfirmScreenController.navigation) {
//             homeMainScreenController.change(0);
//             homeMainScreenController.tabController!.animateTo(
//               0,
//               duration: Duration(milliseconds: 300),
//               curve: Curves.ease,
//             );
//             Get.toNamed(Routes.homeMainRoute);
//           } else {
//             homeMainScreenController.change(3);
//             homeMainScreenController.tabController!.animateTo(
//               3,
//               duration: Duration(milliseconds: 300),
//               curve: Curves.ease,
//             );
//             Get.offNamed(Routes.homeMainRoute);
//           }
//           return orderConfirmScreenController.navigation
//               ? Future.value(true)
//               : Future.value(false);
//         },
//         child: Scaffold(
//             backgroundColor: regularWhite,
//             body: SafeArea(
//                 child: Container(
//                   color: bgColor,
//                   child: GetBuilder<OrderConfirmScreenController>(
//                     init: OrderConfirmScreenController(),
//                     builder: (myOrderScreenController) => Column(
//                       children: [
//                         Container(
//                           color: regularWhite,
//                           child: getAppBar(S.of(context).myOrder, function: () {
//                             if (!isDispose.value) {
//                               return false;
//                             }
//                             if (orderConfirmScreenController.navigation) {
//                               homeMainScreenController.change(0);
//                               homeMainScreenController.tabController!.animateTo(
//                                 0,
//                                 duration: Duration(milliseconds: 300),
//                                 curve: Curves.ease,
//                               );
//                               Get.toNamed(Routes.homeMainRoute);
//                             } else {
//                               homeMainScreenController.change(3);
//                               homeMainScreenController.tabController!.animateTo(
//                                 3,
//                                 duration: Duration(milliseconds: 300),
//                                 curve: Curves.ease,
//                               );
//                               Get.offNamed(Routes.homeMainRoute);
//                             }
//                           }, space: 105.h),
//                         ),
//                         getVerSpace(12.h),
//                         Expanded(
//                           flex: 1,
//                           child: SizedBox(
//                             width: double.infinity,
//                             height: double.infinity,
//                             child: GetBuilder<ProductDataController>(
//                               init: ProductDataController(),
//                               builder: (controller) => Container(
//                                   color: regularWhite,
//                                   child: buildPostsView(controller)),
//                             ),
//                           ),
//                         ),
//                         getVerSpace(30.h),
//                       ],
//                     ),
//                   ),
//                 ))),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:ravasiya_collections/controller/controller.dart';
import 'package:ravasiya_collections/utils/color_category.dart';
import 'package:ravasiya_collections/utils/constantWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../generated/l10n.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';
import '../../../woocommerce/models/woo_get_created_order.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  LoginEmptyStateController loginEmptyStateController =
      Get.put(LoginEmptyStateController());
  HomeMainScreenController homeMainScreenController =
      Get.put(HomeMainScreenController());
  HomeMainScreenController bottomController =
      Get.find<HomeMainScreenController>();
  PagingController<int, WooGetCreatedOrder> pagingController =
      PagingController(firstPageKey: 1);
  OrderConfirmScreenController orderConfirmScreenController =
      Get.find<OrderConfirmScreenController>();

  RxBool isDispose = false.obs;

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    Future.delayed(Duration(seconds: 2), () {
      isDispose.value = true;
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (homeMainScreenController.checkNullOperator()) {
        return;
      }
      final newItems = await homeMainScreenController.api1!
          .get("orders?per_page=100&page=$pageKey");
      List parseRes = newItems;
      List<WooGetCreatedOrder> postList =
          parseRes.map((e) => WooGetCreatedOrder.fromJson(e)).toList();
      final isLastPage = postList.length < 10;
      if (isLastPage) {
        if (!postList.contains(postList.where((element) =>
            element.customerId ==
            homeMainScreenController.currentCustomer!.id))) {
          if (homeMainScreenController.currentCustomer != null) {
            pagingController.appendLastPage(postList
                .where((element) =>
                    element.customerId ==
                    homeMainScreenController.currentCustomer!.id)
                .toList());
          }
        }
      } else {
        final nextPageKey = pageKey + postList.length;
        if (!postList.contains(postList.where((element) =>
            element.customerId ==
            homeMainScreenController.currentCustomer!.id))) {
          if (homeMainScreenController.currentCustomer != null) {
            pagingController.appendPage(
                postList
                    .where((element) =>
                        element.customerId ==
                        homeMainScreenController.currentCustomer!.id)
                    .toList(),
                nextPageKey);
          }
        }
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  backClick(BuildContext context) {
    if (homeMainScreenController.isSetting.value == false) {
      homeMainScreenController.change(0);
      homeMainScreenController.tabController!.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      Get.offNamed(Routes.homeMainRoute);
    } else {
      homeMainScreenController.change(3);
      homeMainScreenController.tabController!.animateTo(
        3,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      Get.offNamed(Routes.homeMainRoute);
    }
  }

  int page = 1;

  bool productLastPage = false;

  bool isOrder = true;

  Widget buildPostsView(ProductDataController productDataController) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () => Future.sync(
        () {
          pagingController.refresh();
          _refreshController.refreshCompleted();
        },
      ),
      child: PagedListView<int, WooGetCreatedOrder>.separated(
        padding: EdgeInsets.zero,
        builderDelegate: PagedChildBuilderDelegate<WooGetCreatedOrder>(
          firstPageProgressIndicatorBuilder: (context) {
            return getLoadingAnimation();
          },
          noItemsFoundIndicatorBuilder: (context) {
            return getEmptyWidget(
                context,
                Constant.emptyOrderLogo,
                S.of(context).noOrdersYet,
                S.of(context).whenYouPlaceAnOrderItWillShowUpHere,
                S.of(context).add,
                homeMainScreenController.currentCustomer == null
                    ? () {
                        loginEmptyStateController.setLoginIsBuynow(true);
                        homeMainScreenController.changeIsLogin(false);
                        Get.toNamed(Routes.loginRoute);
                      }
                    : () {
                        homeMainScreenController.change(0);
                        Get.back();
                      },
                svg: true);
          },
          itemBuilder: (context, order, index) {
            int quantity = 0;
            for (var element in order.lineItems!) {
              quantity = quantity + element.quantity!;
            }
            DateTime dateTime = DateTime.parse(order.dateCreated ?? "");
            String date = DateFormat("dd-MMM-yyyy").format(dateTime);
            String timr = DateFormat("hh:mm a").format(dateTime);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
              color: regularWhite,
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.trackOrderRoute, arguments: order);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCustomFont("${S.of(context).orderId} ${order.id}",
                            16.sp, regularBlack, 1,
                            fontWeight: FontWeight.w600),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(37.h),
                              color: Constant.getOrderStatusColor(
                                      order.status ?? "", context)
                                  .withOpacity(0.14)),
                          child: getCustomFont(
                                  order.status![0].toUpperCase() +
                                      order.status!.substring(1),
                                  16.sp,
                                  Constant.getOrderStatusColor(
                                      order.status ?? "", context),
                                  1,
                                  fontWeight: FontWeight.w600)
                              .paddingSymmetric(
                                  vertical: 5.h, horizontal: 10.h),
                        ),
                      ],
                    ),
                    getVerSpace(4.h),
                    Row(
                      children: [
                        Container(
                          height: 10.h,
                          width: 10.h,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: buttonColor),
                        ),
                        getHorSpace(8.h),
                        getCustomFont(
                            "${S.of(context).orderAt} ${timr} | ${date}",
                            16.sp,
                            regularBlack,
                            1,
                            fontWeight: FontWeight.w400)
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return Container(
            height: 8.h,
            color: bgColor,
          );
        },
        pagingController: pagingController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Directionality(
      textDirection: Constant.getSetDirection(context),
      child: WillPopScope(
        onWillPop: () async {
          if (!isDispose.value) {
            return false;
          }

          if (orderConfirmScreenController.navigation) {
            homeMainScreenController.change(0);
            homeMainScreenController.tabController!.animateTo(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
            Get.toNamed(Routes.homeMainRoute);
          } else {
            homeMainScreenController.change(3);
            homeMainScreenController.tabController!.animateTo(
              3,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
            Get.offNamed(Routes.homeMainRoute);
          }
          return orderConfirmScreenController.navigation
              ? Future.value(true)
              : Future.value(false);
        },
        child: Scaffold(
            backgroundColor: regularWhite,
            body: SafeArea(
              child: Container(
                color: bgColor,
                child: GetBuilder<OrderConfirmScreenController>(
                  init: OrderConfirmScreenController(),
                  builder: (myOrderScreenController) => Column(
                    children: [
                      Container(
                        color: regularWhite,
                        child: getAppBar(S.of(context).myOrder, function: () {
                          if (!isDispose.value) {
                            return false;
                          }
                          if (orderConfirmScreenController.navigation) {
                            homeMainScreenController.change(0);
                            homeMainScreenController.tabController!.animateTo(
                              0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                            Get.toNamed(Routes.homeMainRoute);
                          } else {
                            homeMainScreenController.change(3);
                            homeMainScreenController.tabController!.animateTo(
                              3,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                            Get.offNamed(Routes.homeMainRoute);
                          }
                        }, space: 105.h),
                      ),
                      getVerSpace(12.h),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: GetBuilder<ProductDataController>(
                            init: ProductDataController(),
                            builder: (controller) => Container(
                                color: regularWhite,
                                child: buildPostsView(controller)),
                          ),
                        ),
                      ),
                      getVerSpace(30.h),
                    ],
                  ),
                ),
              ), /*  */
            )),
      ),
    );
  }
}
