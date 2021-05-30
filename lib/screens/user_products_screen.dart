import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_drop/providers/products.dart';
import 'package:shop_drop/screens/edit_product_screen.dart';
import 'package:shop_drop/widgets/app_drawer.dart';
import 'package:shop_drop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(context) async {
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final producData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, index) => Column(
              children: [
                UserProductItem(
                  id: producData.items[index].id!,
                  title: producData.items[index].title,
                  imageUrl: producData.items[index].imageUrl,
                ),
                Divider(),
              ],
            ),
            itemCount: producData.items.length,
          ),
        ),
      ),
    );
  }
}
