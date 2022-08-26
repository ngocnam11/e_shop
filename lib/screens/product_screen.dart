import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/custom_button.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.product),
      builder: (_) => const ProductScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 1,
        // backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        actions: [
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: const Text('product carousel'),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product name',
                    style: theme.headline3,
                  ),
                  const SizedBox(height: 12),
                  Text('Shop', style: theme.headline4),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star),
                      const Icon(Icons.star),
                      const Icon(Icons.star),
                      const Icon(Icons.star),
                      const Icon(Icons.star),
                      Text(
                        '10',
                        style: theme.headline4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$100',
                    style: theme.headline3,
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {},
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
                                child: const Text('Image'),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'options (color, size)',
                                    style: theme.headline3,
                                  ),
                                  Text(
                                    'options selected',
                                    style: theme.headline4,
                                  ),
                                ],
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
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Description',
                    style: theme.headline3,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'loooooooooooooooooooooooooooooooooooooooooooong description ',
                    style: theme.headline6,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Row(
          children: [
            const SizedBox(width: 24),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRouter.chat);
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Chat'),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: CustomButton(
                svg: 'assets/svgs/shopping_bag.svg',
                press: () {},
                textColor: Colors.white,
                primaryColor: Colors.deepOrange[400]!,
                svgColor: Colors.white,
                title: 'Add to Cart',
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
