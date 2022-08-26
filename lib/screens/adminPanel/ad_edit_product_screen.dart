import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/utils.dart';
import '../../services/firestore_services.dart';
import '../../widgets/text_field_input.dart';
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

  Uint8List? _image;

  Map<String, num> slide = {
    'Price': 0,
    'Quantity': 0,
  };

  Map<String, bool> check = {
    'Recommend': false,
    'Popular': false,
  };

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
      price: slide['Price']!.toDouble(),
      quantity: slide['Quantity']!.toInt(),
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
        backgroundColor: Colors.black,
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
            slide['Price'] = snapshot.data!['price'];
            slide['Quantity'] = snapshot.data!['quantity'];
            check['Recommend'] = snapshot.data!['isRecommended'];
            check['Popular'] = snapshot.data!['isPopular'];
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
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: _image != null
                                ? Image(
                                    image: MemoryImage(_image!),
                                  )
                                : Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      snapshot.data!['imageUrl'],
                                    ),
                                  ),
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
                      _buildSlider('Price', slide['Price']!),
                      const SizedBox(height: 10),
                      _buildSlider('Quantity', slide['Quantity']!),
                      const SizedBox(height: 10),
                      _buildCheckbox('Recommend', check['Recommend']),
                      const SizedBox(height: 10),
                      _buildCheckbox('Popular', check['Popular']),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: updateProduct,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
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

  Widget _buildCheckbox(String title, bool? isChecked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 125,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Checkbox(
          value: isChecked,
          checkColor: Colors.black,
          activeColor: Colors.black12,
          onChanged: (value) => setState(() {
            check[title] = value!;
          }),
        ),
      ],
    );
  }

  Widget _buildSlider(String title, num val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 75,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Expanded(
          child: Slider(
            value: val.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: slide[title]!.round().toString(),
            activeColor: Colors.black,
            inactiveColor: Colors.black12,
            onChanged: (value) => setState(() {
              slide[title] = value;
            }),
          ),
        ),
      ],
    );
  }
}
