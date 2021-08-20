import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeContextPath = "/edit-product";
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var product = Product(
    id: "",
    title: "",
    description: "",
    price: 0,
    imageUrl: "",
  );

  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty) {
        return;
      }
      if (!_imageUrlController.text.startsWith("http") ||
          !_imageUrlController.text.startsWith("https")) {
        return;
      }
      if (!_imageUrlController.text.endsWith(".png") ||
          !_imageUrlController.text.endsWith(".jpg") ||
          !_imageUrlController.text.endsWith(".jpeg")) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlController.removeListener(_updateImageUrl);
  }

  void _saveForm() {
    final isFormValid = _form.currentState!.validate();
    if (!isFormValid) {
      return;
    }
    _form.currentState!.save();
    print(product.title);
    print(product.price);
    print(product.description);
    print(product.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
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
                decoration: const InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please provide a title.";
                  }
                  return null;
                },
                onSaved: (newValue) => {
                  product = Product(
                    id: product.id,
                    title: newValue!,
                    description: product.description,
                    price: product.price,
                    imageUrl: product.imageUrl,
                  )
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a price.";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number.";
                  }
                  if (double.parse(value) <= 0) {
                    return "Please enter a  number. great than zero";
                  }
                  return null;
                },
                onSaved: (newValue) => {
                  product = Product(
                    id: product.id,
                    title: product.title,
                    description: product.description,
                    price: double.parse(newValue!),
                    imageUrl: product.imageUrl,
                  )
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please provide some description.";
                  }
                  if (value.length < 10) {
                    return "Please provide atleast 10 chars description.";
                  }
                  return null;
                },
                onSaved: (newValue) => {
                  product = Product(
                    id: product.id,
                    title: product.title,
                    description: newValue!,
                    price: product.price,
                    imageUrl: product.imageUrl,
                  )
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? const Text("Enter a URL")
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "Image URL"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imgUrlFocusNode,
                      onFieldSubmitted: (value) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please provide an image URL.";
                        }
                        if (!value.startsWith("http") ||
                            !value.startsWith("https")) {
                          return "Please provide a valid image URL.";
                        }
                        if (!value.endsWith(".png") ||
                            !value.endsWith(".jpg") ||
                            !value.endsWith(".jpeg")) {
                          return "Please provide a valid image URL.";
                        }
                        return null;
                      },
                      onSaved: (newValue) => {
                        product = Product(
                          id: product.id,
                          title: product.title,
                          description: product.description,
                          price: product.price,
                          imageUrl: newValue!,
                        )
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
