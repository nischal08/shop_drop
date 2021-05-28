import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_drop/providers/product.dart';
import 'package:shop_drop/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imgUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  @override
  void initState() {
    _imgUrlFocusNode.addListener(_updateImgUrl);
    super.initState();
  }

  @override
  void dispose() {
    // _priceFocusNode.dispose();
    _imgUrlFocusNode.removeListener(_updateImgUrl);
    _imageUrlController.dispose();
    _imgUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImgUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https') ||
          !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('jpeg')) {
        return;
      }

      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(
              Icons.save,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onSaved: (newValue) {
                  _editedProduct = Product(
                      id: null,
                      title: newValue!,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                onSaved: (newValue) {
                  _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(newValue!),
                      imageUrl: _editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
              ),
              TextFormField(
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.next,
                onSaved: (newValue) {
                  _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: newValue!,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Should be atleast 10 characters long.';
                  }
                  return null;
                },
                // onFieldSubmitted: (_) =>//No need of this function for focus node
                //     FocusScope.of(context).requestFocus(_descFocusNode),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
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
                    child: _imageUrlController.text.isEmpty
                        ? Center(
                            child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Enter a URL"),
                          ))
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                            // fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {
                        if (_imageUrlController.text.isEmpty ||
                            !_imageUrlController.text.startsWith('http') &&
                                !_imageUrlController.text.startsWith('https') ||
                            !_imageUrlController.text.endsWith('.png') &&
                                !_imageUrlController.text.endsWith('jpg') &&
                                !_imageUrlController.text.endsWith('jpeg')) {
                          return;
                        }
                        setState(() {});
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: null,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: newValue!,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL';
                        }

                        if (!value.endsWith('.png') &&
                            !value.endsWith('jpg') &&
                            !value.endsWith('jpeg')) {
                          return 'Please enter a valid Image URL';
                        }
                        return null;
                      },
                      controller: _imageUrlController,
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imgUrlFocusNode,
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
