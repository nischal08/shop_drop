import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_drop/models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  late String? _authToken;
  late String? _userID;
  String get userId => this._userID!;

  String get authToken => this._authToken!;

  void setAuthToken(String? value) {
    _authToken = value;
    print("From Products Controller:  $_authToken");
    notifyListeners();
  }

  void setUserId(String? userId) {
    _userID = userId;
    print("From Products Controller:  $_userID");
    notifyListeners();
  }

   List<Product> _items=[];
  List<Product> get items {
    return [..._items];
  }

  void setItems(List<Product> products) {
    _items = products;
  }

  List<Product> get favItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    var url =
        'https://shop-drop-85272-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final Map<String, dynamic>? extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 400) {
        print("FetchAndSet function: Server error!!!!!!");
      }
      if (extractedData == null) {
        return;
      }

      url =
          'https://shop-drop-85272-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      print(url);
      final favoriteResponse = await http.get(
        Uri.parse(url),
      );

      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            description: prodData['description'],
            id: prodId,
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            title: prodData['title'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
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
          'creatorId': userId
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

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
