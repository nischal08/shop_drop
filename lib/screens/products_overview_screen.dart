import 'package:flutter/material.dart';
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
          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavorities),
    );
  }
}
