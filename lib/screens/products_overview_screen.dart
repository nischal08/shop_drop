import 'package:flutter/material.dart';
import 'package:shop_drop/widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ShopDrop",
        ),
      ),
      body: ProductsGrid(),
    );
  }
}
