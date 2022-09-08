import 'package:e_shop/widgets/carousel.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../router/router.dart';
import '../services/firestore_services.dart';
import '../widgets/list_categoties.dart';
import '../widgets/text_field_input.dart';

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
    final TextEditingController searchController = TextEditingController();
    List<String> category = [
      'All',
      'Men',
      'Women',
      'Kids',
      'Young Adults',
      'Phone',
      'Laptop',
      'Book'
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: TextFieldInput(
                controller: searchController,
                hintText: 'Search Products',
                textInputType: TextInputType.text,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        category[index],
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: category.length,
              ),
            ),
            const SizedBox(height: 16),
            const Carousel(),
            const SizedBox(height: 16),
            StreamBuilder<List<Category>>(
              stream: FireStoreServices().getCategories(),
              builder: (context, AsyncSnapshot<List<Category>> snapshot) {
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListCategories(
                  categories: snapshot.data!.toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
