import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../config/utils.dart';
import '../services/firestore_services.dart';
import '../widgets/text_field_input.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key, required this.uid, required this.isAdmin})
      : super(key: key);
  final String uid;
  final bool isAdmin;

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneNumController;

  @override
  void initState() {
    initializeAndSetTextEditingControllerValue();
    super.initState();
  }

  @override
  void dispose() {
    disposeTextEditingController();
    super.dispose();
  }

  void initializeAndSetTextEditingControllerValue() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumController = TextEditingController();

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .snapshots()
        .listen((snapshot) {
      _usernameController.text = snapshot.data()!['username'];
      _emailController.text = snapshot.data()!['email'];
      _phoneNumController.text = snapshot.data()!['phoneNum'];
    });
  }

  void disposeTextEditingController() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumController.dispose();
  }

  Uint8List? _image;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void updateProfile() async {
    String resUpdate = await FireStoreServices().updateProfile(
      uid: widget.uid,
      email: _emailController.text,
      username: _usernameController.text,
      file: _image!,
      phoneNum: _phoneNumController.text,
      isAdmin: widget.isAdmin,
    );

    if (resUpdate != 'success') {
      showSnackBar(context, resUpdate);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                  snapshot.data!['photoUrl'],
                                ),
                              ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white),
                            ),
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 40),
                    TextFieldInput(
                      controller: _usernameController,
                      hintText: 'Enter your username',
                      labelText: 'Username',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 24),
                    TextFieldInput(
                      controller: _emailController,
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      textInputType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 24),
                    TextFieldInput(
                      controller: _phoneNumController,
                      hintText: 'Enter your Phone Number',
                      labelText: 'Phone Number',
                      textInputType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue[300],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          onPressed: updateProfile,
                          child: Text(
                            'Save',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
          },
        ),
      ),
    );
  }
}