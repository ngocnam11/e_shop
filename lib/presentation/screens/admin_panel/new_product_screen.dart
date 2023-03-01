import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/utils.dart';
import '../../../services/auth_services.dart';
import '../../../services/firestore_services.dart';
import '../../router/app_router.dart';
import '../../widgets/my_chip_list.dart';
import '../../widgets/text_field_input.dart';

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.adminNewProduct),
      builder: (_) => const NewProductScreen(),
    );
  }

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final TextEditingController colorController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();

  final FocusNode _colorFocusNode = FocusNode();
  final FocusNode _sizeFocusNode = FocusNode();

  Uint8List? _image;
  List<String> _colors = [];
  List<String> _sizes = [];

  void selectImage(BuildContext context) async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void addNewProduct() async {
    String res = await FireStoreServices().addProduct(
      uid: AuthServices().currentUser.uid,
      name: nameController.text,
      category: categoryController.text,
      price: double.parse(priceController.text),
      quantity: int.parse(quantityController.text),
      file: _image!,
      description: descriptionController.text,
      colors: _colors,
      sizes: _sizes,
    );

    if (!mounted) return;

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      showSnackBar(context, 'Your Product has been uploaded!');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Product'),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Ink(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    selectImage(context);
                  },
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Add an Image',
                        style: theme.headlineMedium!.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: _image != null
                    ? Image.memory(
                        _image!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/placeholder.jpg',
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 20),
              Text(
                'Product Information',
                style: theme.headlineMedium,
              ),
              const SizedBox(height: 20),
              TextFieldInput(
                controller: nameController,
                labelText: 'Product Name',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                controller: descriptionController,
                labelText: 'Product Description',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                controller: categoryController,
                labelText: 'Product Category',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                controller: priceController,
                labelText: 'Product Price',
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                controller: quantityController,
                labelText: 'Product Quantity',
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                controller: colorController,
                focusNode: _colorFocusNode,
                labelText: 'Product Color',
                textInputType: TextInputType.text,
                onFieldSubmitted: (String color) {
                  if (color.isNotEmpty) {
                    setState(() {
                      _colors.add(color);
                      colorController.clear();
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
                controller: sizeController,
                focusNode: _sizeFocusNode,
                labelText: 'Product Size',
                textInputType: TextInputType.text,
                onFieldSubmitted: (String size) {
                  if (size.isNotEmpty) {
                    setState(() {
                      _sizes.add(size);
                      sizeController.clear();
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
                  onPressed: addNewProduct,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
