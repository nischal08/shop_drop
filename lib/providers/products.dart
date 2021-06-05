import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_drop/models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  late String _authToken;
  String get authToken => this._authToken;

  void setAuthToken(String value) {
    _authToken = value;
    print("From Products Controller:  $_authToken");
    notifyListeners();
  }

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  void setItems(List<Product> products) {
    _items = products;
  }

  List<Product> get favItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://shop-drop-85272-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final Map<String, dynamic>? extractedData =
          json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            description: prodData['description'],
            id: prodId,
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            title: prodData['title'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-drop-85272-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      // _items.add(newProduct);
      _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://shop-drop-85272-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      http.patch(
        Uri.parse(
          url,
        ),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        'https://shop-drop-85272-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((prod) => prod.id == productId);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    } else {
      existingProduct = null;
    }
  }

  // Future<void> updateToggleFavorite(String productId,
  //     {bool? isFavorite}) async {
  //   final url =
  //       'https://shop-drop-85272-default-rtdb.firebaseio.com/products/$productId.json';
  //   final existingProductIndex =
  //       _items.indexWhere((prod) => prod.id == productId);
  //   Product? existingProduct = _items[existingProductIndex];
  //   Product? updatedProduct = Product(
  //       id: existingProduct.id,
  //       title: existingProduct.title,
  //       description: existingProduct.description,
  //       price: existingProduct.price,
  //       imageUrl: existingProduct.imageUrl,
  //       isFavorite: isFavorite!);

  //   _items.removeAt(existingProductIndex);
  //   _items.insert(existingProductIndex, updatedProduct);
  //   notifyListeners();

  //   final Map jsonBody = {
  //     'isFavorite': updatedProduct.isFavorite,
  //   };

  //   final response = await http.patch(
  //     Uri.parse(url),
  //     body: json.encode(jsonBody),
  //   );
  //   if (response.statusCode >= 400) {
  //     existingProduct.isFavorite = !existingProduct.isFavorite;
  //     _items.removeAt(existingProductIndex);
  //     _items.insert(existingProductIndex, existingProduct);
  //     notifyListeners();
  //     print(existingProduct.isFavorite);
  //     throw HttpException(existingProduct.isFavorite
  //         ? 'Could not unlike the product. Server Error! Try after few minutes.'
  //         : 'Could not like the product. Server Error! Try after few minutes.');
  //   } else {
  //     existingProduct = null;
  //     updatedProduct = null;
  //   }
  // }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
