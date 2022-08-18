import 'package:flutter/material.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/product_carousel.dart';
import '../widgets/section_title.dart';
import '../widgets/text_field_input.dart';
// import 'screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextFieldInput(
              controller: searchController,
              hintText: 'Search Products',
              textInputType: TextInputType.text,
              prefixIcon: const Icon(Icons.search),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text('Carousel slider'),
            ),
            const SizedBox(
              height: 10,
            ),
            SectionTitle(
              title: 'Recommended',
              press: () {},
            ),
            const SizedBox(height: 12),
            const ProductCarousel(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}
