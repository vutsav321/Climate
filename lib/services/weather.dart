import 'package:climate/services/networking.dart';

const apiKey = '4449716300491f36ae7d57b94f5ef9d2';
const openWeatherMap = 'https://api.openweathermap.org/data/2.5/weather';

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
