import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/product_carousel.dart';
import '../widgets/section_title.dart';
import '../widgets/text_field_input.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.home),
      builder: (_) => const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eShop'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRouter.login),
            child: const Text('Logout'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFieldInput(
                controller: searchController,
                hintText: 'Search Products',
                textInputType: TextInputType.text,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 140,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text('Carousel slider'),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SectionTitle(
                title: 'Recommended',
                press: () {},
              ),
            ),
            const SizedBox(height: 4),
            const ProductCarousel(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(
        currentRoute: AppRouter.home,
      ),
    );
  }
}
