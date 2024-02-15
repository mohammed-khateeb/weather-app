import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_task/model/local/weather_cache.dart';
import 'package:weather_task/routes/app_pages.dart';
import 'binding/splash_binding.dart';
import 'config/theme/my_theme.dart';
import 'config/translations/localization_service.dart';
import 'model/local/my_shared_pref.dart';

void main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();

  // init shared preference
  await MySharedPref.init();
  await WeatherCache.init();
  
  // init date format language
  await initializeDateFormatting(
    LocalizationService.getCurrentLocal().languageCode
  );

  runApp(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        return GetMaterialApp(
          title: 'Weather Task',
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          builder: (context,widget) {
            return Theme(
              data: MyTheme.getThemeData(
                isLight: MySharedPref.getThemeIsLight()
              ),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              ),
            );
          },
          initialBinding: SplashBinding(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          locale: MySharedPref.getCurrentLocal(),
          translations: LocalizationService.getInstance(),
        );
      },
    ),
  );
}
