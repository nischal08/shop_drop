import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url =
        'https://shop-drop-85272-default-rtdb.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            "amount": total,
            "dateTime": timestamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'price': cp.price,
                      'quantity': cp.quantity
                    })
                .toList(),
          },
        ),
      );
      final newProduct = OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      );
      _orders.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchOrders() async {
    try {
      const url =
          'https://shop-drop-85272-default-rtdb.firebaseio.com/orders.json';
      final _response = await http.get(Uri.parse(url));
      final Map<String,dynamic>? _extractedData =
          json.decode(_response.body) as Map<String, dynamic>?;
      final List<OrderItem> _loadedOrders = [];
      if (_extractedData == null) {
        return;
      }
      _extractedData.forEach((orderId, orderData) {
        _loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title']),
                )
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      });
      _orders = _loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
