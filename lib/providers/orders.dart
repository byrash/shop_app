import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;

  Orders(this.authToken);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final ordersFireBaseUrl =
        Uri.parse(dotenv.env['FIREBASEURL']! + "/orders.json?auth=$authToken");
    try {
      var resp = await get(ordersFireBaseUrl);
      if (json.decode(resp.body) == null) {
        return;
      }
      final extarctedData = json.decode(resp.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      extarctedData.forEach((orderID, orderData) {
        loadedOrders.add(OrderItem(
          id: orderID,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((cartItem) => CartItem(
                    id: cartItem["id"],
                    title: cartItem["title"],
                    quantity: cartItem["quantity"],
                    price: cartItem["price"],
                  ))
              .toList(),
        ));
      });
      _orders = loadedOrders;
      notifyListeners();
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final ordersFireBaseUrl =
        Uri.parse(dotenv.env['FIREBASEURL']! + "/orders.json?auth=$authToken");
    final ts = DateTime.now();
    try {
      var response = await post(ordersFireBaseUrl,
          body: json.encode({
            "amount": total,
            "dateTime": ts.toIso8601String(),
            "products": cartProducts
                .map((cartItem) => {
                      "id": cartItem.id,
                      "title": cartItem.title,
                      "quantity": cartItem.quantity,
                      "price": cartItem.price,
                    })
                .toList()
          }));
      _orders.insert(
          0,
          OrderItem(
            amount: total,
            dateTime: ts,
            id: json.decode(response.body)['name'],
            products: cartProducts,
          ));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
