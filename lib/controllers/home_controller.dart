

import 'package:get/get.dart';

class HomeController extends GetxController {
  String _domicilio ;
  String get domicilio => _domicilio;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    
    print("GET ARGUMENTS: ${Get.arguments}");
    _domicilio = Get.arguments as String;
  
  }


}