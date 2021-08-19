import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static String routeContextPath = "/user-products";
  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                UserProductItem(
                    title: productsData.items[index].title,
                    imgUrl: productsData.items[index].imageUrl),
                const Divider(),
              ],
            );
          },
          itemCount: productsData.items.length,
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
