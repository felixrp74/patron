import 'package:get/get.dart';
import 'package:patron/ui/ui.dart';
import 'package:patron/ui/auth/auth.dart';
 
class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [ 
    // GetPage(name: '/', page: () => SplashUI()),
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: '/signin', page: () => SignInUI()),
    GetPage(name: '/signup', page: () => SignUpUI()),
    GetPage(name: '/home', page: () => HomeUI()),
    GetPage(name: '/settings', page: () => SettingsUI()),
    GetPage(name: '/reset-password', page: () => ResetPasswordUI()),
    GetPage(name: '/update-profile', page: () => UpdateProfileUI()),
    
    //implmentacion CRUD
    // GetPage(name: '/create-repartidor', page: () => RepartidorUI()),
  ];
}