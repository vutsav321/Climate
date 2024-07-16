import 'package:climate/services/networking.dart';
import 'package:climate/api_key.dart';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName, context) async {
    NetworkHelper networkHelper =
        NetworkHelper('$openWeatherMap?q=$cityName&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData(context, cityName);
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌦️';
    } else if (condition < 400) {
      return '🌧️';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🍃';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for 🩳 and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
