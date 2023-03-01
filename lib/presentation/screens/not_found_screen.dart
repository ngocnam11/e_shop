import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../router/app_router.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/not_found'),
      builder: (_) => const NotFoundScreen(),
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "404",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Page Not Found!',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: SvgPicture.asset(
                'assets/svgs/404_error.svg',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'We\'re sorry, the page you requested could not be found. Please go back to the homepage!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.home,
            (route) => false,
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blueAccent.shade100,
          ),
          child: const Text('GO HOME'),
        ),
      ),
    );
  }
}
