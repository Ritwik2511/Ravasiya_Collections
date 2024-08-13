import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ravasiya_collections/AppSplashScreen.dart';
import 'package:ravasiya_collections/view/home/cart_screens/add_billing_address.dart';
import 'package:ravasiya_collections/view/home/cart_screens/cart_screen.dart';
import 'package:ravasiya_collections/view/home/cart_screens/coupan_screen.dart';
import 'package:ravasiya_collections/view/home/cart_screens/order_complete_screen.dart';
import 'package:ravasiya_collections/view/home/home_main_screen.dart';
import 'package:ravasiya_collections/view/home/home_screens/blog_detail_screen.dart';
import 'package:ravasiya_collections/view/home/home_screens/plant_type_screen.dart';
import 'package:ravasiya_collections/view/home/home_screens/popularPlant.dart';
import 'package:ravasiya_collections/view/home/home_screens/rating_screen.dart';
import 'package:ravasiya_collections/view/home/home_screens/search_screen.dart';
import 'package:ravasiya_collections/view/home/home_screens/trending_plant_data.dart';
import 'package:ravasiya_collections/view/home/profile_screens/edit_address_screen.dart';
import 'package:ravasiya_collections/view/home/profile_screens/edit_profile_screen.dart';
import 'package:ravasiya_collections/view/home/profile_screens/feed_back_screen.dart';
import 'package:ravasiya_collections/view/home/profile_screens/help_center_screen.dart';
import 'package:ravasiya_collections/view/home/profile_screens/my_address_screen.dart';
import 'package:ravasiya_collections/view/home/profile_screens/my_orders.dart';
import 'package:ravasiya_collections/view/home/profile_screens/my_profile_screen.dart';
import 'package:ravasiya_collections/view/home/profile_screens/privacy_policy.dart';
import 'package:ravasiya_collections/view/home/profile_screens/terms_and_condition.dart';
import 'package:ravasiya_collections/view/home/profile_screens/track_order_screen.dart';
import 'package:ravasiya_collections/view/item_category_class/all_related_product_screen.dart';
import 'package:ravasiya_collections/view/item_category_class/category_product.dart';
import 'package:ravasiya_collections/view/item_category_class/image_zoom_screen.dart';
import 'package:ravasiya_collections/view/item_category_class/plant_detail_screen.dart';
import 'package:ravasiya_collections/view/item_category_class/upasell_product_screen.dart';
import 'package:ravasiya_collections/view/login/reset_password.dart';
import 'package:ravasiya_collections/view/onboarding/onboarding_screen.dart';
import 'package:ravasiya_collections/view/sign_up/sign_up_empty_screen.dart';

import '../view/home/cart_screens/My_cart_before_payment.dart';
import '../view/home/favorite_item_screens/favourite_iteam_screen.dart';
import '../view/home/home_screens/blogScreen.dart';
import '../view/home/home_screens/main_category_open_screen.dart';
import '../view/home/profile_screens/review_order.dart';
import '../view/home/profile_screens/security_screen.dart';
import '../view/home/profile_screens/write_review_for_low_star_reason_screen.dart';
import '../view/login/login_empty_state.dart';
import '../view/sign_up/verification_success_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initialRoute = Routes.homeRoute;
  static Map<String, WidgetBuilder> routes = {
    Routes.homeRoute: (context) =>  AppSplashScreen(),
  };

  static routesFactory(settings) {
    switch (settings.name) {
      case Routes.homeRoute:
        return getPage(AppSplashScreen(), settings);
      case Routes.onBoardingRoute:
        return getPage(OnboardingScreen(), settings);
      case Routes.loginRoute:
        return getPage(LoginEmptyState(), settings);
      case Routes.homeMainRoute:
        return getPage(HomeMainScreen(), settings);
      case Routes.signUpRoute:
        return getPage(SignUpEmptyState(), settings);
      case Routes.addBillingAddressRoute:
        return getPage(AddBillingAddress(), settings);
      case Routes.cartScreenRoute:
        return getPage(CartScreen(), settings);
      case Routes.couponRoute:
        return getPage(CoupanScreen(), settings);
      case Routes.cartBeforePaymentRoute:
        return getPage(MyCartScreenAfterPayment(), settings);
      case Routes.orderConfirmRoute:
        return getPage(OrderConfirmScreen(), settings);
      case Routes.favouriteRoute:
        return getPage(FavouriteItemScreen(), settings);
      case Routes.blogDetailRoute:
        return getPage(BlogDetailScreen(), settings);
      case Routes.blogScreenRoute:
        return getPage(BlogScreen(), settings);
      case Routes.mainCategoryScreenRoute:
        return getPage(MainCategoryScreen(), settings);
      case Routes.categoryScreenRoute:
        return getPage(CategoriesScreen(), settings);
      case Routes.popularPlantRoute:
        return getPage(PopularPlantScreen(), settings);
      case Routes.ratingDataRoute:
        return getPage(RatingDataScreen(), settings);
      case Routes.searchScreenRoute:
        return getPage(SearchScreen(), settings);
      case Routes.trendingPlantRoute:
        return getPage(TrendingPlantSCreen(), settings);
      case Routes.editAddressRoute:
        return getPage(EditAddressScreen(), settings);
      case Routes.editProfileRoute:
        return getPage(EditProfileScreen(), settings);
      case Routes.helpCenterRoute:
        return getPage(HelpCenterScreen(), settings);
      case Routes.myAddressRoute:
        return getPage(MyAddress(), settings);
      case Routes.myOrderRoute:
        return getPage(MyOrders(), settings);
      case Routes.myProfileRoute:
        return getPage(MyProfile(), settings);
      case Routes.privacyRoute:
        return getPage(PrivacyPolicy(), settings);
      case Routes.reviewOrderRoute:
        return getPage(ReviewOrder(), settings);
      case Routes.securityRoute:
        return getPage(SecurityScreen(), settings);
      case Routes.termConditionRoute:
        return getPage(TermCondition(), settings);
      case Routes.trackOrderRoute:
        return getPage(TrackOrder(), settings);
      case Routes.relatedRoute:
        return getPage(AllRelatedProductScreen(), settings);
      case Routes.categoryProdyctRoute:
        return getPage(CategoryProduct(), settings);
      case Routes.zoomImageRoute:
        return getPage(ZoomImageScreen(), settings);
      case Routes.upsellProductRoute:
        return getPage(UpsellProductScreen(), settings);
      case Routes.resetPasswordRoute:
        return getPage(ResetPassword(), settings);
      case Routes.feedBackRoute:
        return getPage(FeedBack(), settings);

      case Routes.plantDetailRoute:
        return getPage(PlantDetail(), settings);
      case Routes.splashRoute:
        return getPage(AppSplashScreen(), settings);
      case Routes.myWebViewRoute:
        return getPage(MyWebView(), settings);

      case Routes.verificationSuccessRoute:
        return getPage(VerificationSuccessScreen(), settings);
      case Routes.writeReviewForLowStarRoute:
        return getPage(WriteReviewForLowStarReason(), settings);
      default:
        return null;
    }
  }

  static getPage(var child, var settings) {
    var type = PageTransitionType.rightToLeft;

    return PageTransition(
      child: child,
      type: type,
      settings: settings,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 300),
    );
  }
}
