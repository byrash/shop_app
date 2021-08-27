import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverview extends StatefulWidget {
  ProductsOverview({Key? key}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool _showOnlyFavs = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<Products>(context, listen: false).fetchAndSetProducts().then(
      (value) {
        setState(() {
          _isLoading = false;
        });
      },
    );
    // Provider.of<Products>(context).fetchAndSetProducts(); //This wont
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _showOnlyFavs = true;
                } else {
                  _showOnlyFavs = false;
                }
              });
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  child: Text("Only favourites"),
                  value: FilterOptions.favorites,
                ),
                const PopupMenuItem(
                  child: Text("Show all"),
                  value: FilterOptions.all,
                ),
              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (context, cart, buttonAsChild) => Badge(
              child: buttonAsChild!,
              value: cart.itemCount,
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeContextPath);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductsGrid(
              key: UniqueKey(),
              showOnlyFavs: _showOnlyFavs,
            ),
    );
  }
}
