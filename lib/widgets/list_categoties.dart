import 'package:flutter/material.dart';

import '../screens/screens.dart';

class ListCategories extends StatelessWidget {
  const ListCategories({
    Key? key,
    required this.categories,
  }) : super(key: key);
  final dynamic categories;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    CategoryScreen(category: categories[index]),
              ),
            );
          },
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image(
                        height: 70,
                        width: 70,
                        image: NetworkImage(categories[index]['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      categories[index]['name'],
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
                const Icon(
                  Icons.navigate_next,
                  size: 40,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: categories.length,
    );
  }
}
