import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_drop/providers/auth.dart';
import 'package:shop_drop/providers/cart.dart';
import 'package:shop_drop/providers/orders.dart';
import 'package:shop_drop/screens/auth_screen.dart';
import 'package:shop_drop/screens/cart_screen.dart';
import 'package:shop_drop/screens/edit_product_screen.dart';

import 'package:shop_drop/screens/orders_screen.dart';
import 'package:shop_drop/screens/product_detail_screen.dart';
import 'package:shop_drop/screens/products_overview_screen.dart';
import 'package:shop_drop/screens/splash_screen.dart';
import 'package:shop_drop/screens/user_products_screen.dart';
import 'providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (____) => Products(),
          update: (context, auth, previousProducts) {
            return Products()
              ..setAuthToken(auth.token == null ? "" : auth.token)
              ..setItems(previousProducts!.items)
              ..setUserId(auth.userId == null ? "" : auth.userId);
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previous) {
            return Orders()
              ..setAuthToken(auth.token == null ? "" : auth.token)
              ..setOrderItems(previous!.orders)
              ..userId = auth.userId;
          },
          create: (ctx) => Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'ShopDrop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
