import 'package:flutter/material.dart';

import '../screens/screens.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    Key? key,
  }) : super(key: key);
  //_selectedRoute = '/home; 
  //static const listRoute ={'/home', '/cart', '/wishlist','/chat', '/profile'};
  //void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedRoute = listRoute[index];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
                //pushName(context, '/home')
                //setState();
                //currentRoute = 'home';
                //onItemTapped();
              },
              icon: 
                Row(
                  children: [
                    const Icon(
                      Icons.home_outlined,
                    ),
                    // Text('Home'),
                  ],
                ),
              ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
              icon: Wrap(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                  ),
                  // Text('Cart'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WishlistScreen(),
                  ),
                );
              },
              icon: Wrap(
                children: [
                  const Icon(
                    Icons.favorite_outline,
                  ),
                  // Text('Wishlist'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WishlistScreen(),
                  ),
                );
              },
              icon: Wrap(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                  ),
                  // Text('Chat'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(
                      // uid: FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ),
                  
                );
              },
              icon: Wrap(
                children: [
                  const Icon(
                    Icons.person_outline,
                  ),
                  // Text('Profile'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}