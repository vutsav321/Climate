import 'package:shared_preferences/shared_preferences.dart';

class CityPersistence {
  static const String lastSearchedCityKey = 'lastSearchedCity';

  Future<void> saveLastSearchedCity(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastSearchedCityKey, city);
  }

  Future<String?> getLastSearchedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastSearchedCityKey);
  }
}
