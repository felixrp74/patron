import 'package:get/get.dart';
import 'package:patron/ui/ui.dart';

class MapController extends GetxController{


  mostrarDetalle(domicilio) {
    print("-------------DOMICILIO----------: $domicilio");
    Get.to(HomeUI(), arguments: domicilio);
  }


}