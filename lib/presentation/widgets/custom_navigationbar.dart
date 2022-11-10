import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../logic/cubits/cubits.dart';
import '../router/app_router.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 6,
          ),
        ],
        color: Colors.white,
      ),
      child: BlocConsumer<NavigatonBarCubit, NavigationTab>(
        listener: (context, state) {
          switch (state) {
            case NavigationTab.home:
              Navigator.of(context).pushNamedAndRemoveUntil(
                NavigationTab.home.tab,
                (route) => false,
              );
              break;
            case NavigationTab.cart:
              Navigator.of(context).pushNamed(NavigationTab.cart.tab);
              break;
            case NavigationTab.wishlist:
              Navigator.of(context).pushNamedAndRemoveUntil(
                NavigationTab.wishlist.tab,
                (route) => false,
              );
              break;
            case NavigationTab.chat:
              Navigator.of(context).pushNamedAndRemoveUntil(
                NavigationTab.chat.tab,
                (route) => false,
              );
              break;
            case NavigationTab.profile:
              Navigator.of(context).pushNamedAndRemoveUntil(
                NavigationTab.profile.tab,
                (route) => false,
              );
              break;
          }
        },
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <CustomNavigationBarItem>[
              CustomNavigationBarItem(
                tab: NavigationTab.home,
                isCurrentPage: state.tab == AppRouter.home,
              ),
              CustomNavigationBarItem(
                tab: NavigationTab.cart,
                isCurrentPage: state.tab == AppRouter.cart,
              ),
              CustomNavigationBarItem(
                tab: NavigationTab.wishlist,
                isCurrentPage: state.tab == AppRouter.wishlist,
              ),
              CustomNavigationBarItem(
                tab: NavigationTab.chat,
                isCurrentPage: state.tab == AppRouter.chat,
              ),
              CustomNavigationBarItem(
                tab: NavigationTab.profile,
                isCurrentPage: state.tab == AppRouter.profile,
              ),
            ],
          );
        },
      ),
    );
  }
}

class CustomNavigationBarItem extends StatelessWidget {
  const CustomNavigationBarItem({
    super.key,
    required this.tab,
    required this.isCurrentPage,
    this.selectedColor = Colors.blue,
  });

  final NavigationTab tab;
  final bool isCurrentPage;
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
          color: selectedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              tab.selectedIcon,
              color: selectedColor,
            ),
            const SizedBox(width: 5),
            Text(
              toBeginningOfSentenceCase(tab.name)!,
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
      onTap: () => context.read<NavigatonBarCubit>().setTab(tab),
      child: Tooltip(
        message: toBeginningOfSentenceCase(tab.name),
        child: Icon(tab.icon),
      ),
    );
  }
}
