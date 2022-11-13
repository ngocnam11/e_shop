import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user.dart';
import '../../logic/blocs/blocs.dart';
import '../../logic/cubits/cubits.dart';
import '../../services/auth_services.dart';
import '../../services/firestore_services.dart';
import '../router/app_router.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/custom_network_image.dart';
import '../widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.profile),
      builder: (context) {
        context.read<NavigatonBarCubit>().setTab(NavigationTab.profile);
        return const ProfileScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
        ],
      ),
      body: FutureBuilder<UserModel>(
        future: FireStoreServices().getUserByUid(
          uid: AuthServices().currentUser.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Card(
                      elevation: 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CustomNetworkImage(
                                src: snapshot.data!.photoUrl,
                                height: 88,
                                width: 88,
                                fit: BoxFit.cover,
                                isCurrentUserAvatar: true,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data!.username,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  snapshot.data!.email,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ProfileMenu(
                          icon: Icons.person_outline_rounded,
                          title: 'My Account',
                          press: () => Navigator.of(context)
                              .pushNamed(AppRouter.account),
                        ),
                        const SizedBox(height: 10),
                        ProfileMenu(
                          icon: Icons.local_mall_outlined,
                          title: 'My Orders',
                          press: () => Navigator.of(context)
                              .pushNamed(AppRouter.myOrders),
                        ),
                        const SizedBox(height: 10),
                        if (snapshot.data!.isAdmin)
                          Column(
                            children: <Widget>[
                              ProfileMenu(
                                icon: Icons.admin_panel_settings_outlined,
                                title: 'Go to Admin Panel',
                                press: () => Navigator.of(context)
                                    .pushNamed(AppRouter.admin),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ProfileMenu(
                          icon: Icons.logout,
                          title: 'Log Out',
                          press: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Log out'),
                              titleTextStyle:
                                  Theme.of(context).textTheme.headline3,
                              content: const Text('Do you want to log out?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<AppBloc>()
                                        .add(AppLogoutRequested());
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      AppRouter.login,
                                      (route) => false,
                                    );
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
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
          return const SizedBox();
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
