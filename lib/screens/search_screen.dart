import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/text_field_input.dart';
import 'screens.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TextFieldInput(
                controller: searchController,
                hintText: 'Search Products',
                textInputType: TextInputType.text,
                prefixIcon: const Icon(Icons.search),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'categoryyyyy',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemCount: 6,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('Carousel slider'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 500,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CategoryScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 8),
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text('Image'),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'New in',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.navigate_next,
                              size: 40,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: 5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
