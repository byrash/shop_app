import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class Product with ChangeNotifier {
  final String id;
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

  Future<void> toggleFavoriteStatus(String? authToken, String? userId) async {
    isFavorite = !isFavorite;
    final productsFavFireBasePatchUrl = Uri.parse(dotenv.env['FIREBASEURL']! +
        "/userFavorites/$userId/$id.json?auth=$authToken");
    try {
      await put(productsFavFireBasePatchUrl,
          body: json.encode(
            isFavorite,
          ));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
