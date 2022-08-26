import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/utils.dart';
import '../../services/firestore_services.dart';
import '../../widgets/text_field_input.dart';
import 'ad_product_screen.dart';

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({Key? key}) : super(key: key);

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

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

  void addNewProduct() async {
    String res = await FireStoreServices().addProduct(
      uid: FirebaseAuth.instance.currentUser!.uid,
      id: int.parse(idController.text),
      name: nameController.text,
      category: categoryController.text,
      price: slide['Price']!.toDouble(),
      quantity: slide['Quantity']!.toInt(),
      file: _image!,
      description: descriptionController.text,
      colors: [],
      size: [],
    );
    if (res != 'success') {
      showSnackBar(context, res);
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
        title: const Text('Add a Product'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: Colors.black,
                    child: InkWell(
                      onTap: () async {
                        selectImage(context);
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.add_circle,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Add an Image',
                            style:
                                theme.headline4!.copyWith(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: _image != null
                        ? Image(
                            image: MemoryImage(_image!),
                          )
                        : const Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80',
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Product Information',
                  style: Theme.of(context).textTheme.headline4,
                ),
                TextFieldInput(
                  controller: idController,
                  hintText: 'Product ID',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: nameController,
                  hintText: 'Product Name',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: descriptionController,
                  hintText: 'Product Description',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: categoryController,
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
                    onPressed: addNewProduct,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Save',
                        style: theme.headline5!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
