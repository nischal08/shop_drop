import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_drop/providers/products.dart';

import 'package:shop_drop/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  const UserProductItem({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final scaffoldMessanger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (e) {
                  scaffoldMessanger.showSnackBar(SnackBar(
                    content: Text(
                      'Deleting failed!',
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
