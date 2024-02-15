import 'package:get/get.dart';
import 'package:weather_task/model/local/weather_cache.dart';

import '../config/theme/my_theme.dart';
import '../config/translations/localization_service.dart';
import '../model/local/my_shared_pref.dart';
import '../model/services/api_call_status.dart';
import '../model/services/base_client.dart';
import '../model/weather_details_model.dart';
import '../utils/constants.dart';

class HomeViewModel extends GetxController {

  // get the current language code
  var currentLanguage = LocalizationService.getCurrentLocal().languageCode;

  // hold current weather data
  late WeatherDetailsModel weatherDetails;
  late Forecastday forecastday;



  // for update
  final themeId = 'Theme';

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.loading;

  // for app theme
  var isLightTheme = MySharedPref.getThemeIsLight();


  String city = "Amman";

  late BaseClient _baseClient;

  // Setter method for baseClient
  set baseClient(BaseClient client) {
    _baseClient = client;
  }


  /// get home screem data
  Future getCurrentWeather() async {
    await BaseClient.safeApiCall(
      Constants.forecastWeatherApiUrl,
      RequestType.get,
      queryParameters: {
        Constants.key: Constants.mApiKey,
        Constants.q: city,
        Constants.days: 3,
        Constants.lang: currentLanguage,
      },
      onSuccess: (response) {
        weatherDetails = WeatherDetailsModel.fromJson(response.data);
        forecastday = weatherDetails.forecast.forecastday[0];
        apiCallStatus = ApiCallStatus.success;
        WeatherCache.saveCachedWeather(weatherDetails.toJson());
        update();
      },
      onError: (error) async {
        var cachedWeather = await getCachedWeather();
        if (cachedWeather != null) {
          weatherDetails = cachedWeather;
          forecastday = weatherDetails.forecast.forecastday[0];
          apiCallStatus = ApiCallStatus.success; // Mark as success because data is from cache
          update();
        } else {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
        }
      },
    );
    update();
  }


  /// Method to retrieve cached weather data
  Future<WeatherDetailsModel?> getCachedWeather() async {
    Map<String, dynamic>? cachedWeatherJson = await WeatherCache.getCachedWeather(); // Implement this method
    if (cachedWeatherJson != null) {
      return WeatherDetailsModel.fromJson(cachedWeatherJson);
    } else {
      return null;
    }
  }

  /// when the user press on change theme icon
  onChangeThemePressed() {
    MyTheme.changeTheme();
    isLightTheme = MySharedPref.getThemeIsLight();
    update([themeId]);
  }

  /// when the user change city
  onChangeCity(String newCity){
    city = newCity;
    apiCallStatus = ApiCallStatus.loading;
    update([city]);
    getCurrentWeather();
  }

  /// when the user press on change language icon
  onChangeLanguagePressed() async {
    currentLanguage = currentLanguage == 'ar' ? 'en' : 'ar';
    await LocalizationService.updateLanguage(currentLanguage);
    apiCallStatus = ApiCallStatus.loading;
    update();
    await getCurrentWeather();
  }
}
