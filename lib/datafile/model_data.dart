// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:ravasiya_collections/model/onboarding_slider.dart';

import '../generated/l10n.dart';
import '../model/language_model.dart';

class Data {


  static List<LanguageData> getLanguage() {
    return [
      LanguageData("English", "en", 1),
      LanguageData("Arabic", "ar", 2),
      LanguageData("spanish", "es", 3),
      LanguageData("german", "de", 4),
      LanguageData("italian", "it", 5),
      LanguageData("french", "fr", 6),
      LanguageData("russian", "ru", 7),
      LanguageData("ukrain", "uk", 8),
      LanguageData("polish", "pl", 9),
      LanguageData("hungarian", "hu", 10),
      LanguageData("hebrew", "he", 11),
      LanguageData("dutch", "nl", 12),
    ];
  }
  static List<Sliders> getSliderPages(BuildContext context) {
    return [
      Sliders(
          image: "onboarding1st_new.png",
          richTitle1st: "",
          richTitle2nd: "",
          richTitle3rd: ""),
      Sliders(
          image: 'onboarding2nd_new.png',
          richTitle1st: "",
          richTitle2nd: "",
          richTitle3rd: ""),
      Sliders(
        image: 'onboarding3rd_new.png',
        richTitle1st: "",
        richTitle2nd: "",
        richTitle3rd: "",)
    ];
  }
}
//
//   static List<Sliders> getSliderPages(BuildContext context) {
//     return [
//       Sliders(
//           image: 'onboarding1st_new.png',
//           richTitle1st: S.of(context).weProvideHighQuality,
//           richTitle2nd: S.of(context).plants,
//           richTitle3rd: S.of(context).forYou),
//       Sliders(
//           image: 'onboarding2nd_new.png',
//           richTitle1st: S.of(context).your,
//           richTitle2nd: S.of(context).satisfaction,
//           richTitle3rd: S.of(context).isOurNumberOnePriority),
//       Sliders(
//           image: 'onboarding3rd_new.png',
//           richTitle1st: S.of(context).letsShopYour,
//           richTitle2nd: S.of(context).favourite,
//           richTitle3rd: S.of(context).plantsWithUs),
//     ];
//   }
// }
