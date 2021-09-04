import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeContextPath = "/orders";
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Text("An error occured !!");
          } else {
            return Consumer<Orders>(builder: (context, ordersData, child) {
              return ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (context, index) {
                  return OrderItem(order: ordersData.orders[index]);
                },
              );
            });
          }
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
