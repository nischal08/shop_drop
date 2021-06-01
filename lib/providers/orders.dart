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
   
    final response=  await http.post(
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

  Future<void> getOrders() async {
    try {
      const url =
          'https://shop-drop-85272-default-rtdb.firebaseio.com/orders.json';
      final _response = await http.get(Uri.parse(url));
      final _extractedData = json.decode(_response.body);
      List<OrderItem> _loadedData = [];

      _extractedData.forEach((prodId, prodData) {
        final _extractedProduct = prodData['products'];
        final List<CartItem> productList = [];
        _extractedProduct.forEach((prod) {
          productList.add(
            CartItem(
              id: prod['id'],
              title: prod['title'],
              quantity: prod['quantity'],
              price: prod['price'],
            ),
          );
        });
        _loadedData.add(
          OrderItem(
            id: prodId,
            amount: prodData['amount'],
            products: productList,
            dateTime: DateTime.parse(prodData['dateTime']),
          ),
        );
      });
      _orders = _loadedData;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
