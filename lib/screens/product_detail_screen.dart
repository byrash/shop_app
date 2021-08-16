import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  static String routeContextPath = "/product-detail";
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
    );
  }
}
