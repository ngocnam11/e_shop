import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  //routename = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
        ],
      ),

      body:
          // FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          //   future: FirebaseFirestore.instance
          //       .collection('users')
          //       .doc(widget.uid)
          //       .get(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //     if (snapshot.hasData) {
          // return
          Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
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
                        Container(
                          margin: const EdgeInsets.all(12),
                          height: 88,
                          width: 88,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(''),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Khanh Vu',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'email cua Khanh Vu',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 64),
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
                        icon: Icons.account_circle_outlined,
                        title: 'My Account',
                        press: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => MyAccountScreen(
                          //       uid: FirebaseAuth.instance.currentUser!.uid,
                          //       isAdmin: snapshot.data!['isAdmin'],
                          //     ),
                          //   ),
                          // );
                        },
                      ),
                      const SizedBox(height: 10),
                      // snapshot.data!['isAdmin']
                      // ?
                      ProfileMenu(
                        icon: Icons.admin_panel_settings_outlined,
                        title: 'Go to Admin Panel',
                        press: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: ((context) =>
                          //         const AdHomeScreen()),
                          //   ),
                          // );
                        },
                      ),
                      // : const SizedBox(),
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
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // AuthServices().logout();
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         const LoginScreen(),
                                    //   ),
                                    // );
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
          ],
        ),
      ),
      // }
      // return const SizedBox();
      // },
      // ),
      bottomNavigationBar: const CustomNavigationBar(
        currentRoute: AppRouter.profile,
      ),
    );
  }
}
