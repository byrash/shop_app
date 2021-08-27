import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        title: 'Shop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple,
          ).copyWith(
            secondary: Colors.deepOrange,
          ),
          fontFamily: "Lato",
        ),
        home: ProductsOverview(),
        routes: {
          ProductDetail.routeContextPath: (ctx) => const ProductDetail(),
          CartScreen.routeContextPath: (ctx) => const CartScreen(),
          OrdersScreen.routeContextPath: (ctx) => const OrdersScreen(),
          UserProductsScreen.routeContextPath: (ctx) =>
              const UserProductsScreen(),
          EditProductScreen.routeContextPath: (ctx) =>
              const EditProductScreen(),
        },
      ),
    );
  }
}
