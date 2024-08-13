

import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class RatingController extends GetxController
     {

       int five = 0;
       int four = 0;
       int three = 0;
       int two = 0;
       int one = 0;


       setData(var argument){
         five = argument[0]!.where((element) => element.rating == 5).length;
         four = argument[0]!.where((element) => element.rating == 4).length;
         three = argument[0]!.where((element) => element.rating == 3).length;
         two = argument[0]!.where((element) => element.rating == 2).length;
         one = argument[0]!.where((element) => element.rating == 1).length;
         update();
       }
}