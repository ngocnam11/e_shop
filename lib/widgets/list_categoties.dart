import 'package:flutter/material.dart';

import '../screens/screens.dart';
import 'custom_network_image.dart';

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
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemBuilder: (context, index) {
        return Ink(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryScreen(category: categories[index]),
                ),
              );
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CustomNetworkImage(
                      src: categories[index].imageUrl,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    categories[index].name,
                    style: Theme.of(context).textTheme.headline3,
                  ),
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
