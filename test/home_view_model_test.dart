import 'package:flutter_test/flutter_test.dart';
import 'package:weather_task/model/services/api_call_status.dart';
import 'package:weather_task/model/services/base_client.dart';
import 'package:weather_task/view_model/home_view_model.dart';

// Mock implementation of BaseClient interface
class MockBaseClient implements BaseClient {
  Future<void> safeApiCall(String url, RequestType type, {Map<String, dynamic>? queryParameters, Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
    // Simulate successful API call
    if (onSuccess != null) {
      final responseData = {'weatherDetails': 'mockData'};
      onSuccess(responseData);
    }
  }
}

void main() {
  group('HomeViewModel', () {
    test('getCurrentWeather() should update weatherDetails on successful API call', () async {
      // Arrange
      final viewModel = HomeViewModel();
      final mockBaseClient = MockBaseClient();
      viewModel.baseClient = mockBaseClient;

      // Act
      await viewModel.getCurrentWeather();

      // Assert
      expect(viewModel.weatherDetails, isNotNull);
      // Add more assertions as needed
    });

    test('getCurrentWeather() should set apiCallStatus to error on failed API call', () async {
      // Arrange
      final viewModel = HomeViewModel();
      final mockBaseClient = MockBaseClient();
      viewModel.baseClient = mockBaseClient;

      // Simulate failed API call
      mockBaseClient.safeApiCall('', RequestType.get, onError: (error) {});

      // Act
      await viewModel.getCurrentWeather();

      // Assert
      expect(viewModel.apiCallStatus, ApiCallStatus.error);
      // Add more assertions as needed
    });
  });
}
