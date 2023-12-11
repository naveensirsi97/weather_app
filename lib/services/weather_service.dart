import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_response_model.dart';

class WeatherService {
  Future<WeatherResponse> getWeatherData({required String city}) async {
    Uri uri = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=fe9c862d031a1ffc04111157bb5a3163');
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      WeatherResponse weatherResponse = WeatherResponse.fromJson(data);
      return weatherResponse;
    }
    throw ('Something went wrong');
  }
}
