import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_drop/providers/auth.dart';
import 'package:shop_drop/providers/cart.dart';
import 'package:shop_drop/providers/product.dart';
import 'package:shop_drop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.2,
        ),
      ),
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Hero(
              tag: product.id!,
              child: FadeInImage(
                fit: BoxFit.fitWidth,
                placeholder: AssetImage('assets/images/coming-soon.png'),
                image: NetworkImage(
                  product.imageUrl,
                ),
              ),
            ),
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (_, product, child) => IconButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  product.toggleFavoriteStatus(context,
                      token: authData.token, userID: authData.userId);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
              ),
              // child: Text('Never Changes'),
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(product.id!, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to cart',
                    ),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id!);
                      },
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(
                CupertinoIcons.shopping_cart,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
