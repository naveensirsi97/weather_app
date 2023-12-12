import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/model/weather_response_model.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWeather(context);
  }

  Future fetchWeather(BuildContext context, {String city = 'Bhiwani'}) async {
    try {
      Provider.of<WeatherProvider>(context, listen: false).weatherResponse =
          null;
      setState(() {});
      WeatherResponse response =
          await WeatherService().getWeatherData(city: city);
      Provider.of<WeatherProvider>(context, listen: false).weatherResponse =
          response;
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, bottom: 8, top: 24),
          child: Consumer<WeatherProvider>(
            builder: (context, weatherProvider, _) {
              final WeatherResponse? weatherResponse =
                  weatherProvider.weatherResponse;

              return ListView(
                children: [
                  Column(
                    children: [
                      if (weatherProvider.loading)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      searchBox(context),
                      const SizedBox(height: 20),
                      getBox(
                        height: 100,
                        icon: WeatherIcons.day_cloudy,
                        text:
                            '${weatherResponse?.name ?? '-'}, ${weatherResponse?.sys?.country ?? '-'}',
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/day.png',
                        //height: 300,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBox(
                            icon: WeatherIcons.thermometer,
                            height: 120,
                            width: 110,
                            text:
                                ' ${kelvinToCelsius(weatherResponse?.main?.temp ?? 0).toStringAsFixed(0)}',
                            degree: " \u2103",
                          ),
                          getBox(
                            icon: WeatherIcons.humidity,
                            height: 120,
                            width: 110,
                            text: '${weatherResponse?.main?.humidity ?? 0}',
                            degree: " %",
                          ),
                          getBox(
                            icon: WeatherIcons.day_light_wind,
                            height: 120,
                            width: 110,
                            text: '${weatherResponse?.wind?.speed ?? 0}',
                            degree: " m",
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text("Data Provided By OpenWeatherMap.org"),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getBox({
    required double height,
    required text,
    required icon,
    double? width,
    String? degree,
  }) {
    return Container(
      height: height,
      width: width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, top: 8.0, right: 8.0, bottom: 0.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                Text(
                  degree ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        controller: textEditingController,
        onSubmitted: (String value) {
          fetchWeather(context, city: value);
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.black54),
          hintText: "Search city",
          fillColor: Colors.black54,
        ),
      ),
    );
  }
}
