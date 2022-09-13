import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/utils.dart';
import '../../services/firestore_services.dart';
import '../../widgets/text_field_input.dart';
import '../../widgets/custom_network_image.dart';
import 'ad_product_screen.dart';

class AdEditProductScreen extends StatefulWidget {
  const AdEditProductScreen({Key? key, required this.id}) : super(key: key);
  final id;

  @override
  State<AdEditProductScreen> createState() => _AdEditProductScreenState();
}

class _AdEditProductScreenState extends State<AdEditProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  Uint8List? _image;

  void selectImage(BuildContext context) async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void updateProduct() async {
    String rep = await FireStoreServices().updateProduct(
      id: widget.id,
      uid: FirebaseAuth.instance.currentUser!.uid,
      name: _nameController.text,
      category: _categoryController.text,
      file: _image!,
      price: double.parse(_priceController.text),
      quantity: int.parse(_categoryController.text),
      description: _descriptionController.text,
      colors: [],
      size: [],
    );

    if (!mounted) return;

    if (rep != 'success') {
      showSnackBar(context, rep);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AdProductScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('products')
            .doc(widget.id.toString())
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            _nameController.text = snapshot.data!['name'];
            _categoryController.text = snapshot.data!['category'];
            _descriptionController.text = snapshot.data!['description'];
            _priceController.text = snapshot.data!['price'].floor().toString();
            _quantityController.text =
                snapshot.data!['quantity'].floor().toString();
            return ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _image != null
                              ? Image.memory(
                                  _image!,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                )
                              : CustomNetworkImage(
                                  src: snapshot.data!['imageUrl'],
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () async {
                              selectImage(context);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Product Information',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const SizedBox(height: 10),
                      TextFieldInput(
                        controller: _nameController,
                        hintText: 'Product Name',
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),
                      TextFieldInput(
                        controller: _descriptionController,
                        hintText: 'Product Description',
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),
                      TextFieldInput(
                        controller: _categoryController,
                        hintText: 'Product Category',
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),
                      TextFieldInput(
                        controller: _priceController,
                        hintText: 'Price',
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      TextFieldInput(
                        controller: _quantityController,
                        hintText: 'Quantity',
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: updateProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Update',
                              style: theme.headline5!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
    );
  }
}
