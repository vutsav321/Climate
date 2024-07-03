import 'package:flutter/material.dart';
import 'package:climate/constants.dart';
import 'package:climate/services/weather.dart';
import 'searching_screen.dart';

class WeatherScreen extends StatefulWidget {
  WeatherScreen({required this.weatherData});

  final weatherData;

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherModel weatherModel = WeatherModel();
  int temperature = 0;
  String weatherIcon = 'Error';
  String cityName = 'null';
  String message = 'null';
  int humidity = 0;
  double windSpeed = 0;

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      message = weatherModel.getMessage(temperature);
      humidity = weatherData['main']['humidity'];
      windSpeed = weatherData['wind']['speed'];
      cityName = weatherData['name'];
    });
  }

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: isloading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              isloading = true;
                            });
                            var weatherData = await WeatherModel()
                                .getCityWeather(cityName, context);
                            setState(() {
                              isloading = false;
                            });
                            updateUI(weatherData);
                          },
                          icon: Icon(
                            Icons.refresh,
                            size: 30.0,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.search,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '$temperature°c ',
                          style: kTempTextStyle,
                        ),
                        width >= 650
                            ? Text(
                                weatherIcon,
                                style: kConditionTextStyle,
                              )
                            : Container(),
                      ],
                    ),
                    width < 650
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                weatherIcon,
                                style: kConditionTextStyle,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.water_drop,
                                ),
                                Text(
                                  'Humidity: \n$humidity%',
                                  style: kOtherConditionTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.air),
                                Text(
                                  'Wind Speed: \n$windSpeed m/s',
                                  style: kOtherConditionTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "$message in $cityName!",
                          textAlign: TextAlign.center,
                          style: kMessageTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// print(temperature);
// print(condition);
// print(cityName);
