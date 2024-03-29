import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import '../router/app_router.dart';
import '../widgets/custom_network_image.dart';

class SelectOptionsScreen extends StatefulWidget {
  const SelectOptionsScreen({super.key, required this.options});

  static Route route({required Map<String, dynamic> options}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.selectOptions),
      builder: (_) => SelectOptionsScreen(options: options),
      fullscreenDialog: true,
    );
  }

  final Map<String, dynamic> options;

  @override
  State<SelectOptionsScreen> createState() => _SelectOptionsScreenState();
}

class _SelectOptionsScreenState extends State<SelectOptionsScreen> {
  late String sellerName;
  late Product product;

  String _selectedColor = '';
  String _selectedSize = '';

  void getInitValue() {
    sellerName = widget.options['sellerName'];
    product = widget.options['product'];
    if (product.colors.isNotEmpty) {
      _selectedColor = product.colors.first;
    }
    if (product.sizes.isNotEmpty) {
      _selectedSize = product.sizes.first;
    }
  }

  @override
  void initState() {
    super.initState();
    getInitValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Option'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          Container(
            height: 126,
            padding: const EdgeInsets.only(
              left: 8,
              bottom: 8,
              top: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CustomNetworkImage(
                    src: product.imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(fontWeight: FontWeight.normal),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Provider: ',
                          style: Theme.of(context).textTheme.titleLarge,
                          children: <TextSpan>[
                            TextSpan(
                              text: sellerName,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${product.price}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (product.colors.isNotEmpty && product.sizes.isEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: 'Color: ',
                    style: Theme.of(context).textTheme.titleLarge,
                    children: <TextSpan>[
                      TextSpan(
                        text: _selectedColor,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                colorSelection(colorList: product.colors),
              ],
            ),
          if (product.sizes.isNotEmpty && product.colors.isEmpty)
            Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: 'Size: ',
                    style: Theme.of(context).textTheme.titleLarge,
                    children: <TextSpan>[
                      TextSpan(
                        text: _selectedSize,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                sizeSelection(sizeList: product.sizes),
              ],
            ),
          if (product.colors.isNotEmpty && product.sizes.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: 'Color: ',
                    style: Theme.of(context).textTheme.titleLarge,
                    children: <TextSpan>[
                      TextSpan(
                        text: _selectedColor,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                colorSelection(colorList: product.colors),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    text: 'Size: ',
                    style: Theme.of(context).textTheme.titleLarge,
                    children: <TextSpan>[
                      TextSpan(
                        text: _selectedSize,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                sizeSelection(sizeList: product.sizes),
              ],
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'color': _selectedColor,
              'size': _selectedSize,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent.shade100,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('Continue'),
        ),
      ),
    );
  }

  GridView colorSelection({required List<String> colorList}) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: colorList.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3,
      ),
      itemBuilder: (context, index) {
        return Ink(
          decoration: BoxDecoration(
            border: _selectedColor == colorList[index]
                ? Border.all(color: Colors.blue)
                : null,
            borderRadius: BorderRadius.circular(8),
            color: _selectedColor == colorList[index]
                ? Colors.blue.withOpacity(0.2)
                : Colors.black12,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                _selectedColor = colorList[index];
              });
            },
            child: Center(
              child: Text(
                colorList[index],
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        );
      },
    );
  }

  GridView sizeSelection({required List<String> sizeList}) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: sizeList.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 4,
      ),
      itemBuilder: (context, index) {
        return Ink(
          decoration: BoxDecoration(
            border: _selectedSize == sizeList[index]
                ? Border.all(color: Colors.blue)
                : null,
            borderRadius: BorderRadius.circular(8),
            color: _selectedSize == sizeList[index]
                ? Colors.blue.withOpacity(0.2)
                : Colors.black12,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                _selectedSize = sizeList[index];
              });
            },
            child: Center(
              child: Text(
                sizeList[index],
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        );
      },
    );
  }
}
