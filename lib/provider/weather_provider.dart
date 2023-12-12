import 'package:flutter/foundation.dart';
import 'package:weather_app/model/weather_response_model.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherResponse? _weatherResponse;
  bool _loading = false;

  WeatherResponse? get weatherResponse => _weatherResponse;
  bool get loading => _loading;

  set weatherResponse(WeatherResponse? value) {
    _weatherResponse = value;
    notifyListeners();
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
