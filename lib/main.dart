import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
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
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (context, authValue, previousProducts) => Products(
                authValue.token, authValue.userId, previousProducts!.items),
            create: (context) => Products(null, null, []),
          ),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
              update: (context, authValue, previousOrders) => Orders(
                    authValue.token,
                  ),
              create: (ctx) => Orders(null)),
        ],
        child: Consumer<Auth>(
          builder: (context, authValue, child) => MaterialApp(
            title: 'Shop',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.purple,
              ).copyWith(
                secondary: Colors.deepOrange,
              ),
              fontFamily: "Lato",
            ),
            home: authValue.isAutheticated
                ? ProductsOverview()
                : const AuthScreen(),
            routes: {
              ProductDetail.routeContextPath: (ctx) => const ProductDetail(),
              CartScreen.routeContextPath: (ctx) => const CartScreen(),
              OrdersScreen.routeContextPath: (ctx) => const OrdersScreen(),
              AuthScreen.routeContextPath: (ctx) => const AuthScreen(),
              UserProductsScreen.routeContextPath: (ctx) =>
                  const UserProductsScreen(),
              EditProductScreen.routeContextPath: (ctx) =>
                  const EditProductScreen(),
            },
          ),
        ));
  }
}
