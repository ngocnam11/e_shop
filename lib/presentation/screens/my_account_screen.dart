import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/utils.dart';
import '../../data/models/user.dart';
import '../../services/auth_services.dart';
import '../../services/firestore_services.dart';
import '../router/app_router.dart';
import '../widgets/custom_network_image.dart';
import '../widgets/text_field_input.dart';

enum MyAccountMenu { address, changePassword, deleteAccount }

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.account),
      builder: (_) => const MyAccountScreen(),
    );
  }

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();

  Uint8List? _image;

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> getInitUserInfo() async {
    final user = await FireStoreServices().getUserByUid(
      uid: AuthServices().currentUser.uid,
    );
    _usernameController.text = user.username;
    _phoneNumController.text = user.phoneNum;
  }

  void updateProfile() async {
    String resUpdate = await FireStoreServices().updateProfile(
      username: _usernameController.text,
      file: _image,
      phoneNum: _phoneNumController.text,
    );

    if (!mounted) return;

    if (resUpdate != 'success') {
      showSnackBar(context, resUpdate);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.profile,
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    getInitUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        actions: <Widget>[
          PopupMenuButton<MyAccountMenu>(
            onSelected: (value) async {
              switch (value) {
                case MyAccountMenu.address:
                  Navigator.of(context).pushNamed(AppRouter.address);
                  break;
                case MyAccountMenu.changePassword:
                  Navigator.of(context).pushNamed(AppRouter.changePassword);
                  break;
                case MyAccountMenu.deleteAccount:
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MyAccountMenu>(
                  value: MyAccountMenu.address,
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.location_on_outlined),
                      SizedBox(width: 4),
                      Text('My Address'),
                    ],
                  ),
                ),
                PopupMenuItem<MyAccountMenu>(
                  value: MyAccountMenu.changePassword,
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.lock_outline_rounded),
                      SizedBox(width: 4),
                      Text('Change Password'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<MyAccountMenu>(
                  value: MyAccountMenu.deleteAccount,
                  child: Row(
                    children: const <Widget>[
                      Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text('Delete Account'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<UserModel>(
        future: FireStoreServices().getUserByUid(
          uid: AuthServices().currentUser.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: <Widget>[
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _image != null
                            ? Image.memory(
                                _image!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : CustomNetworkImage(
                                src: snapshot.data!.photoUrl,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                isCurrentUserAvatar: true,
                              ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: FittedBox(
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      snapshot.data!.email,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'User Name',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 4),
                      TextFieldInput(
                        controller: _usernameController,
                        hintText: 'Enter your username',
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Phone Number',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 4),
                      TextFieldInput(
                        controller: _phoneNumController,
                        hintText: 'Enter your Phone Number',
                        textInputType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300],
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              onPressed: updateProfile,
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18),
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
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
