import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_task/utils/extensions.dart';
import 'package:weather_task/view/home/widgets/home_shimmer.dart';

import '../../components/api_error_widget.dart';
import '../../components/custom_icon_button.dart';
import '../../components/my_widgets_animator.dart';
import '../../config/translations/strings_enum.dart';
import '../../utils/constants.dart';
import '../../view_model/home_view_model.dart';
import 'widgets/forecast_hour_item.dart';
import 'widgets/sun_rise_set_item.dart';
import 'widgets/weather_details_card.dart';
import 'widgets/weather_row_data.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final HomeViewModel homeViewModel = Get.put(HomeViewModel());

  @override
  void initState() {
    homeViewModel.getCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconButton(
                    onPressed: () => homeViewModel.onChangeThemePressed(),
                    icon: GetBuilder<HomeViewModel>(
                      id: homeViewModel.themeId,
                      builder: (_) => Icon(
                        homeViewModel.isLightTheme
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        color: theme.iconTheme.color,
                      ),
                    ),
                    borderColor: theme.dividerColor,
                  ),
                  8.horizontalSpace,
                  CustomIconButton(
                    onPressed: () => homeViewModel.onChangeLanguagePressed(),
                    icon: Icon(
                      Icons.language,
                      color: theme.iconTheme.color,
                    ),
                    borderColor: theme.dividerColor,
                  ),
                ],
              ).animate().fade().slideX(
                duration: 300.ms,
                begin: -1,
                curve: Curves.easeInSine,
              ),
            ),
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: CSCPicker(
                onCountryChanged: (value) {},
                onStateChanged:(value) {},
                onCityChanged:(value) {
                  if(value!=null) homeViewModel.onChangeCity(value);
                },
              ),
            ),


            24.verticalSpace,
            SizedBox(
              child: GetBuilder<HomeViewModel>(
                  builder: (homeViewModel) {
                    return MyWidgetsAnimator(
                        apiCallStatus: homeViewModel.apiCallStatus,
                        loadingWidget: () => const HomeShimmer(),
                        errorWidget: () => ApiErrorWidget(
                          retryAction: () => homeViewModel.getCurrentWeather(),
                        ),
                        successWidget: () {
                          return Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: theme.canvasColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.r),
                                topRight: Radius.circular(30.r),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Center(
                                  child: WeatherDetailsCard(
                                    weatherDetails: homeViewModel.weatherDetails,
                                    forecastDay: homeViewModel.weatherDetails.forecast.forecastday[0],
                                  ),
                                ),
                                16.verticalSpace,


                                SizedBox(
                                  height: 100.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: homeViewModel.forecastday.hour.length,
                                    itemBuilder: (context, index) => ForecastHourItem(
                                      hour: homeViewModel.forecastday.hour[index],
                                    ),
                                  ),
                                ),
                                16.verticalSpace,
                                Container(
                                  padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 10.h),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      WeatherRowData(
                                        text: Strings.humidity.tr,
                                        value: '${homeViewModel.forecastday.day.avghumidity.toInt()}%',
                                      ),
                                      5.verticalSpace,
                                      WeatherRowData(
                                        text: Strings.realFeel.tr,
                                        value: '${homeViewModel.forecastday.day.avgtempC.toInt()}°',
                                      ),
                                      5.verticalSpace,
                                      WeatherRowData(
                                        text: Strings.uv.tr,
                                        value: '${homeViewModel.forecastday.day.uv.toInt()}',
                                      ),
                                      5.verticalSpace,
                                      WeatherRowData(
                                        text: Strings.chanceOfRain.tr,
                                        value: '${homeViewModel.forecastday.day.dailyChanceOfRain}%',
                                      ),
                                    ],
                                  ),
                                ),
                                10.horizontalSpace,
                                16.verticalSpace,

                                Container(
                                  width: double.infinity,

                                  margin: EdgeInsets.symmetric(horizontal: 5.w,),

                                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            homeViewModel.weatherDetails.current.windDir.getWindDir(),
                                            style: theme.textTheme.displayMedium?.copyWith(
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          15.verticalSpace,
                                          Text(
                                            '${homeViewModel.forecastday.day.maxwindKph} ${Strings.kmh.tr}',
                                            style: theme.textTheme.displayMedium?.copyWith(
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      RotationTransition(
                                        //Transform.rotate(
                                        //angle: homeViewModel.weatherDetails.current.windDegree * pi / 180,
                                        turns: AlwaysStoppedAnimation(homeViewModel.weatherDetails.current.windDegree / 360),
                                        child: Icon(Icons.north, size: 30, color: theme.iconTheme.color),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  }
              ),
            ),


            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}
