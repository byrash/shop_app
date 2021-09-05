import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'product.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Products with ChangeNotifier {
  final authToken;

  final List<Product> _items;

  Products(this.authToken, this._items);

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final productsFireBaseProductsUrl = Uri.parse(
          dotenv.env['FIREBASEURL']! + "/products.json?auth=$authToken");
      var resp = await http.get(productsFireBaseProductsUrl);
      if (json.decode(resp.body) == null) {
        return;
      }
      var bodyData = json.decode(resp.body) as Map<String, dynamic>;
      _items.clear();
      bodyData.forEach((key, value) {
        _items.add(Product(
          id: key,
          title: value["title"],
          description: value["description"],
          price: value["price"],
          isFavorite: value["isFavorite"],
          imageUrl: value["imageUrl"],
        ));
      });
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final productsFireBaseProductsUrl = Uri.parse(
          dotenv.env['FIREBASEURL']! + "/products.json?auth=$authToken");
      final resp = await http.post(productsFireBaseProductsUrl,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "isFavorite": product.isFavorite,
          }));
      final newProduct = Product(
        id: json.decode(resp.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final productsFireBasePatchUrl = Uri.parse(
          dotenv.env['FIREBASEURL']! + "/products/$id.json?auth=$authToken");
      try {
        await http.patch(productsFireBasePatchUrl,
            body: json.encode({
              "title": newProduct.title,
              "description": newProduct.description,
              "price": newProduct.price,
              "imageUrl": newProduct.imageUrl,
            }));
      } catch (error) {
        print(error);
        rethrow;
      }
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> deleteProduct(String id) async {
    final productsFireBasePatchUrl = Uri.parse(
        dotenv.env['FIREBASEURL']! + "/products/$id.json?auth=$authToken");
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        await http.delete(productsFireBasePatchUrl);
      } catch (error) {
        print(error);
        rethrow;
      }
      _items.removeAt(prodIndex);
      notifyListeners();
    }
  }
}
