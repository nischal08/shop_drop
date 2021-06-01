import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_drop/providers/orders.dart' show Orders;
import 'package:shop_drop/widgets/app_drawer.dart';
import 'package:shop_drop/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
   _ordersFuture=_obtainOrdersFuture();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('Building Orders');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
//..
// Do error handling
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return Consumer<Orders>(
              builder: (context, orderData, child) {
                return ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, index) => OrderItem(
                    orderData.orders[index],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
