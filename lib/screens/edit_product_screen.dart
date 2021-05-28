import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_drop/providers/cart.dart';
import 'package:shop_drop/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final _priceFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // _priceFocusNode.dispose();
    _imageUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Products _productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                // onFieldSubmitted: (_) =>
                //     FocusScope.of(context).requestFocus(_priceFocusNode),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                // focusNode: _priceFocusNode,
              ),
              TextFormField(
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.next,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _productsData.imgUrl == null
                        ? Text("Enter a URL")
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          _productsData.setProductImageUrl(
                            url: _imageUrlController.text,
                          );
                        },
                        onFieldSubmitted: (value) {
                          _imageUrlController.clear();
                          
                        },
                        controller: _imageUrlController,
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
