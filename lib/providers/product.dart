import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  void toggleFavoriteStatus(context,{String? token}) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shop-drop-85272-default-rtdb.firebaseio.com/products/$id.json?auth=$token';

    try {
      final response = await http.patch(Uri.parse(url),
          body: json.encode(
            {"isFavorite": isFavorite},
          ));

      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorite
                  ? "Server error!!! Couldn't unlike !!!Try Again Later"
                  : "Server error!!! Couldn't like !!!Try Again Later",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } catch (error) {
       _setFavValue(oldStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Server error!!!",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
