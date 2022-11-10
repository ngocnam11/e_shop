import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation/router/app_router.dart';

enum NavigationTab { home, cart, wishlist, chat, profile }

extension NavigationTabX on NavigationTab {
  String get tab {
    switch (this) {
      case NavigationTab.home:
        return AppRouter.home;
      case NavigationTab.cart:
        return AppRouter.cart;
      case NavigationTab.wishlist:
        return AppRouter.wishlist;
      case NavigationTab.chat:
        return AppRouter.chat;
      case NavigationTab.profile:
        return AppRouter.profile;
    }
  }

  IconData get icon {
    switch (this) {
      case NavigationTab.home:
        return Icons.home_outlined;
      case NavigationTab.cart:
        return Icons.shopping_bag_outlined;
      case NavigationTab.wishlist:
        return Icons.favorite_outline_rounded;
      case NavigationTab.chat:
        return Icons.chat_bubble_outline_rounded;
      case NavigationTab.profile:
        return Icons.person_outline_rounded;
    }
  }

  IconData get selectedIcon {
    switch (this) {
      case NavigationTab.home:
        return Icons.home_rounded;
      case NavigationTab.cart:
        return Icons.shopping_bag_rounded;
      case NavigationTab.wishlist:
        return Icons.favorite_rounded;
      case NavigationTab.chat:
        return Icons.chat_bubble_rounded;
      case NavigationTab.profile:
        return Icons.person_rounded;
    }
  }
}

class NavigatonBarCubit extends Cubit<NavigationTab> {
  NavigatonBarCubit() : super(NavigationTab.home);

  void setTab(NavigationTab tab) => emit(tab);
}
