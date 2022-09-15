import 'package:flutter/material.dart';

import '../models/category.dart';
import '../router/router.dart';
import '../services/firestore_services.dart';
import '../widgets/carousel.dart';
import '../widgets/list_categoties.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.search),
      builder: (_) => SearchScreen(),
    );
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black54,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.black54,
                ),
                onPressed: () {
                  _searchController.clear();
                },
              ),
              hintText: 'Search...',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
