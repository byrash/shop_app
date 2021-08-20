import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Product>(context, listen: false);
    var cartData = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetail.routeContextPath,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTileBar(
            leading: Consumer<Product>(
              builder: (context, product, child) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_outline),
                onPressed: () {
                  product.toggleFavoriteStatus();
                },
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                cartData.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                    "Added item to cart",
                    textAlign: TextAlign.center,
                  ),
                  duration: const Duration(seconds: 5),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cartData.removeSingleItem(product.id);
                    },
                  ),
                ));
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
