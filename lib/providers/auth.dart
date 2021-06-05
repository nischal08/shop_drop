import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;

  late DateTime _expiryDate;

  late String _userId;

  Future<void> signup(String email, String password) async {
    const String _apiKey = "AIzaSyB3_Evfz0eUVER03vuo-k4FOdTgTQjDkEQ";
    const String _url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey";

    Map _mapBody = {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };
    http.Response response = await http.post(
      Uri.parse(_url),
      body: json.encode(
        _mapBody,
      ),
    );
    print(json.decode(response.body));
  }
}
