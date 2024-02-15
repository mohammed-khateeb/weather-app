import 'package:get/get.dart';
import '../../view/home/home_view.dart';
import '../../binding/splash_binding.dart';
import '../../view/splash/splash_view.dart';
import '../binding/home_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

  ];
}
