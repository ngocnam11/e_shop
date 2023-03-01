import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/utils.dart';
import '../../../data/models/product.dart';
import '../../../services/firestore_services.dart';
import '../../router/app_router.dart';
import '../../widgets/custom_network_image.dart';
import '../../widgets/my_chip_list.dart';
import '../../widgets/text_field_input.dart';

class AdEditProductScreen extends StatefulWidget {
  const AdEditProductScreen({super.key, required this.id});
  final String id;

  static Route route({required String id}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.adminEditProduct),
      builder: (_) => AdEditProductScreen(id: id),
    );
  }

  @override
  State<AdEditProductScreen> createState() => _AdEditProductScreenState();
}

class _AdEditProductScreenState extends State<AdEditProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  final FocusNode _colorFocusNode = FocusNode();
  final FocusNode _sizeFocusNode = FocusNode();

  Uint8List? _image;
  List<String> _colors = [];
  List<String> _sizes = [];

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> getInitProductInfo() async {
    final product = await FireStoreServices().getProductById(id: widget.id);
    _nameController.text = product.name;
    _categoryController.text = product.category;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _quantityController.text = product.quantity.toString();
    _colors = product.colors;
    _sizes = product.sizes;
  }

  void updateProduct() async {
    String rep = await FireStoreServices().updateProduct(
      id: widget.id,
      name: _nameController.text,
      category: _categoryController.text,
      file: _image,
      price: double.parse(_priceController.text),
      quantity: int.parse(_quantityController.text),
      description: _descriptionController.text,
      colors: _colors,
      sizes: _sizes,
    );

    if (!mounted) return;

    if (rep != 'success') {
      showSnackBar(context, rep);
    } else {
      showSnackBar(context, 'Update Product successfully');
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    getInitProductInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: FutureBuilder<Product>(
        future: FireStoreServices().getProductById(id: widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData) {
            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: selectImage,
                      child: Center(
                        child: _image != null
                            ? Image.memory(
                                _image!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              )
                            : CustomNetworkImage(
                                src: snapshot.data!.imageUrl,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Product Information',
                      style: theme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    TextFieldInput(
                      controller: _nameController,
                      labelText: 'Product Name',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      controller: _descriptionController,
                      labelText: 'Product Description',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      controller: _categoryController,
                      labelText: 'Product Category',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      controller: _priceController,
                      labelText: 'Product Price',
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      controller: _quantityController,
                      labelText: 'Product Quantity',
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      controller: _colorController,
                      focusNode: _colorFocusNode,
                      labelText: 'Product Color',
                      textInputType: TextInputType.text,
                      onFieldSubmitted: (String color) {
                        if (color.isNotEmpty) {
                          setState(() {
                            _colors.add(color);
                            _colorController.clear();
                          });
                        }
                        _colorFocusNode.requestFocus();
                      },
                      validator: (colors) => (colors?.length ?? 0) < 2
                          ? 'Please add at least 2 colors'
                          : null,
                      onSaved: (colors) {
                        _colors = colors!;
                      },
                    ),
                    MyChipList(
                      values: _colors,
                      chipBuilder: (String color) {
                        return Chip(
                          label: Text(color),
                          onDeleted: () {
                            setState(() {
                              _colors.remove(color);
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      controller: _sizeController,
                      focusNode: _sizeFocusNode,
                      labelText: 'Product Size',
                      textInputType: TextInputType.text,
                      onFieldSubmitted: (String size) {
                        if (size.isNotEmpty) {
                          setState(() {
                            _sizes.add(size);
                            _sizeController.clear();
                          });
                        }
                        _sizeFocusNode.requestFocus();
                      },
                      validator: (sizes) => (sizes?.length ?? 0) < 2
                          ? 'Please add at least 2 colors'
                          : null,
                      onSaved: (sizes) {
                        _sizes = sizes!;
                      },
                    ),
                    MyChipList(
                      values: _sizes,
                      chipBuilder: (String size) {
                        return Chip(
                          label: Text(size),
                          onDeleted: () {
                            setState(() {
                              _sizes.remove(size);
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: updateProduct,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Update'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
