import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_drop/providers/cart.dart';
import 'package:shop_drop/screens/cart_screen.dart';
import 'package:shop_drop/widgets/app_drawer.dart';
import 'package:shop_drop/widgets/badge.dart';
import 'package:shop_drop/widgets/products_grid.dart';

enum FilterOptions {
  Favourities,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorities = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ShopDrop",
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favourities) {
                _showOnlyFavorities = true;
              } else {
                _showOnlyFavorities = false;
              }
              setState(() {});
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Only Favorities'),
                value: FilterOptions.Favourities,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch!,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorities),
    );
  }
}
