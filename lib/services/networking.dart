import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);
  final String url;
  Future getData(context, cityName) async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sorry we are unable get results for $cityName.')));
    }
  }
}
