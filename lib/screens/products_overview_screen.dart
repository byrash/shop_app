import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';

import '../providers/product.dart';

class ProductsOverview extends StatelessWidget {
  ProductsOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
      ),
      body: ProductsGrid(),
    );
  }
}
