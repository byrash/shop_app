import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String id;
  final double price;
  final int quantity;
  final String title;

  const CartItem({
    Key? key,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Are you sure?"),
              content:
                  const Text("Do you want to remove the item from the cart ?"),
              actions: [
                TextButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: FittedBox(
              child: CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      "\$$price",
                    ),
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text("total: \$${price * quantity}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
