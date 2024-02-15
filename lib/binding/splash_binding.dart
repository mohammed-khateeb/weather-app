import 'package:get/get.dart';

import '../view_model/splash_view_model.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
