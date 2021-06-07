import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_drop/providers/products.dart';
import 'package:shop_drop/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

   ProductsGrid(this.showFavs) ;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =showFavs? productsData.favItems:productsData.items;
    return GridView.builder(
      // padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2.8,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(
            // products[index].id,
            // products[index].title,
            // products[index].imageUrl,
            ),
      ),
    );
  }
}
