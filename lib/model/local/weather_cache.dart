import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/translations/localization_service.dart';
import '../../utils/constants.dart';

class WeatherCache {
  // prevent making instance
  WeatherCache._();

  // get storage
  static late SharedPreferences _sharedPreferences;


  /// init get storage services
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Method to save cached weather data
  static Future<void> saveCachedWeather(Map<String, dynamic> weatherData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.cachedWeatherKey, jsonEncode(weatherData));
  }

  // Method to retrieve cached weather data
  static Future<Map<String, dynamic>?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedWeatherJson = prefs.getString(Constants.cachedWeatherKey);
    if (cachedWeatherJson != null) {
      return jsonDecode(cachedWeatherJson) as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}