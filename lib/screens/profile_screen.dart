import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../router/router.dart';
import '../services/auth_services.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/profile_menu.dart';
import 'adminPanel/ad_home_screen.dart';
import 'screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.profile),
      builder: (_) => ProfileScreen(
        uid: AuthServices().currentUser.uid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Card(
                      elevation: 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                snapshot.data!['photoUrl'],
                                height: 88,
                                width: 88,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!['username'],
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                snapshot.data!['email'],
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProfileMenu(
                          icon: Icons.person_outline_rounded,
                          title: 'My Account',
                          press: () {
                            Navigator.of(context).pushNamed(
                              AppRouter.account,
                              arguments: snapshot.data!['isAdmin'],
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        snapshot.data!['isAdmin']
                            ? ProfileMenu(
                                icon: Icons.admin_panel_settings_outlined,
                                title: 'Go to Admin Panel',
                                press: () {
                                  Navigator.of(context).pushNamed(
                                    AppRouter.admin,
                                  );
                                },
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        ProfileMenu(
                          icon: Icons.logout,
                          title: 'Log out',
                          press: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Log out'),
                                content: const Text('Do you want to log out?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(
                                      'No',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      AuthServices().logout();
                                      Navigator.of(context)
                                          .pushNamed(AppRouter.login);
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(
        currentRoute: AppRouter.profile,
      ),
    );
  }
}
