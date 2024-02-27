import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../model/api_response.dart';
import 'data_convert.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = "3ecd8b1c17f23dfafe5928d9b30bba73";

  static const List<String> cities = [
    "Paris",
    "Lyon",
    "Marseille",
    "Toulouse",
    "Nice",
  ];
  static const String apiUrl =
      "http://api.openweathermap.org/data/2.5/forecast";
}
