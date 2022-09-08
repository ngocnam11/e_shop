import 'package:flutter/material.dart';

import '../models/product.dart';
import '../router/router.dart';
import '../services/firestore_services.dart';
import '../widgets/carousel.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/product_carousel.dart';
import '../widgets/section_title.dart';

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
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.notification);
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  fixedSize: const Size.fromWidth(double.maxFinite),
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.search);
                },
                icon: Row(
                  children: const [
                    SizedBox(
                      width: 12,
                    ),
                    Icon(Icons.search),
                  ],
                ),
                label: const Text('Search Products'),
              ),
            ),
            const SizedBox(height: 16),
            const Carousel(),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SectionTitle(
                title: 'Recommended',
                press: () {},
              ),
            ),
            const SizedBox(height: 4),
            StreamBuilder<List<Product>>(
              stream: FireStoreServices().getProducts(),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ProductCarousel(
                  products: snapshot.data!.toList(),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(
        currentRoute: AppRouter.home,
      ),
    );
  }
}
