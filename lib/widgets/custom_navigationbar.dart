import 'package:flutter/material.dart';

import '../router/router.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  final String currentRoute;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  late String _currentRoute;

  @override
  void initState() {
    _currentRoute = widget.currentRoute;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <CustomNavigationBarItem>[
          CustomNavigationBarItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: 'Home',
            onPressed: () {
              _currentRoute = AppRouter.home;
              Navigator.of(context).pushNamedAndRemoveUntil(
                _currentRoute,
                (route) => false,
              );
            },
            isCurrentPage: _currentRoute == AppRouter.home,
          ),
          CustomNavigationBarItem(
            icon: Icons.shopping_bag_outlined,
            selectedIcon: Icons.shopping_bag_rounded,
            label: 'Cart',
            onPressed: () {
              _currentRoute = AppRouter.cart;
              Navigator.of(context).pushNamed(_currentRoute);
            },
            isCurrentPage: _currentRoute == AppRouter.cart,
          ),
          CustomNavigationBarItem(
            icon: Icons.favorite_outline_rounded,
            selectedIcon: Icons.favorite_rounded,
            label: 'Wishlist',
            onPressed: () {
              _currentRoute = AppRouter.wishlist;
              Navigator.of(context).pushNamed(_currentRoute);
            },
            isCurrentPage: _currentRoute == AppRouter.wishlist,
          ),
          CustomNavigationBarItem(
            icon: Icons.chat_bubble_outline_rounded,
            selectedIcon: Icons.chat_bubble_rounded,
            label: 'Chat',
            onPressed: () {
              _currentRoute = AppRouter.chat;
              Navigator.of(context).pushNamedAndRemoveUntil(
                _currentRoute,
                (route) => false,
              );
            },
            isCurrentPage: _currentRoute == AppRouter.chat,
          ),
          CustomNavigationBarItem(
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: 'Profile',
            onPressed: () {
              _currentRoute = AppRouter.profile;
              Navigator.of(context).pushNamedAndRemoveUntil(
                _currentRoute,
                (route) => false,
              );
            },
            isCurrentPage: _currentRoute == AppRouter.profile,
          ),
        ],
      ),
    );
  }
}

class CustomNavigationBarItem extends StatelessWidget {
  const CustomNavigationBarItem({
    Key? key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onPressed,
    required this.isCurrentPage,
    this.selectedColor = Colors.blue,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool isCurrentPage;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    if (isCurrentPage) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedColor,
            width: 0.5,
          ),
          color: selectedColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              selectedIcon,
              color: selectedColor,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: selectedColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    return InkWell(
      onTap: onPressed,
      child: Tooltip(
        message: label,
        child: Icon(icon),
      ),
    );
  }
}
