import 'package:flutter/material.dart';

import '../router/router.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.search),
      builder: (_) => const SearchScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Search'),
    );
  }
}
