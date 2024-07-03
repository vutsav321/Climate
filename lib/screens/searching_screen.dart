import 'package:climate/screens/weather_screen.dart';
import 'package:climate/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:climate/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String cityName = '';

class _SearchScreenState extends State<SearchScreen> {
  bool isloading = false;
  var weatherData = null;
  String? _lastSearchedCity;

  @override
  void initState() {
    super.initState();
    _loadLastSearchedCity();
  }

  Future<void> _loadLastSearchedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastSearchedCity = prefs.getString('lastSearchedCity');
    });
  }

  Future<void> _saveLastSearchedCity(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSearchedCity', city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: isloading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 20),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        decoration: kTextFieldInputDecoration,
                        onChanged: (value) {
                          cityName = value;
                        },
                      ),
                    ),
                    if (_lastSearchedCity != null)
                      Text('Last searched city: $_lastSearchedCity'),
                    IconButton(
                      iconSize: 100,
                      onPressed: () async {
                        if (cityName.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please enter a city name.'),
                          ));
                          return;
                        }
                        if (weatherData == null) {
                          setState(() {
                            isloading = true;
                          });
                        }
                        if (cityName.isNotEmpty) {
                          _saveLastSearchedCity(cityName);
                          setState(() {
                            _lastSearchedCity = cityName;
                          });
                        }
                        weatherData = await WeatherModel()
                            .getCityWeather(cityName, context);
                        setState(() {
                          isloading = false;
                          cityName = '';
                        });
                        if (weatherData == null) {
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherScreen(
                              weatherData: weatherData,
                            ),
                          ),
                        );
                      },
                      icon: const Text(
                        'Get Weather',
                        style: kButtonTextStyle,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
