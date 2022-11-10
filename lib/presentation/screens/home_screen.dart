import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product.dart';
import '../../logic/cubits/cubits.dart';
import '../../services/firestore_services.dart';
import '../router/app_router.dart';
import '../widgets/carousel.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/product_carousel.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.home),
      builder: (context) {
        context.read<NavigatonBarCubit>().setTab(NavigationTab.home);
        return const HomeScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eShop'),
        actions: <Widget>[
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
          children: <Widget>[
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
              stream: FireStoreServices().get5ProductsByRecentSearch(
                  recentSearch: ['earings', 'Earings']),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SectionTitle(
                title: 'New Arrivals',
                press: () {},
              ),
            ),
            const SizedBox(height: 4),
            StreamBuilder<List<Product>>(
              stream: FireStoreServices().get5Products(),
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
            const SizedBox(height: 12),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
