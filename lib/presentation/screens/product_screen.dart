import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/utils.dart';
import '../../data/models/cart.dart';
import '../../data/models/product.dart';
import '../../data/models/user.dart';
import '../../logic/blocs/cart/cart_bloc.dart';
import '../../services/firestore_services.dart';
import '../router/app_router.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_network_image.dart';
import 'conversation_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.product});

  static Route route({required Product product}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.product),
      builder: (_) => ProductScreen(product: product),
    );
  }

  final Product product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<void> getInitValue() async {
    final user =
        await FireStoreServices().getUserByUid(uid: widget.product.uid);
    _sellerName = user.username;
    if (widget.product.colors.isNotEmpty) {
      _color = widget.product.colors.first;
    }
    if (widget.product.sizes.isNotEmpty) {
      _size = widget.product.sizes.first;
    }
  }

  late String _sellerName;
  String _color = '';
  String _size = '';

  @override
  void initState() {
    super.initState();
    getInitValue().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 1,
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
        actions: <Widget>[
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
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              child: CustomNetworkImage(
                src: widget.product.imageUrl,
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.product.name,
                    style: theme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<UserModel>(
                    future: FireStoreServices()
                        .getUserByUid(uid: widget.product.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        debugPrint(snapshot.error.toString());
                        return const Text('Something went wrong');
                      }
                      return Text(
                        snapshot.data!.username,
                        style: theme.headlineMedium,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.star, color: Colors.yellow),
                      const Icon(Icons.star, color: Colors.yellow),
                      const Icon(Icons.star, color: Colors.yellow),
                      const Icon(Icons.star, color: Colors.yellow),
                      const Icon(Icons.star, color: Colors.yellow),
                      Text(
                        '10',
                        style: theme.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${widget.product.price}',
                    style: theme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  if (widget.product.colors.isNotEmpty ||
                      widget.product.sizes.isNotEmpty)
                    Ink(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.selectOptions,
                            arguments: {
                              'sellerName': _sellerName,
                              'product': widget.product,
                            },
                          ).then((value) {
                            final options = value as Map<String, dynamic>?;
                            if (options != null) {
                              setState(() {
                                _color = options['color'];
                                _size = options['size'];
                              });
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const SizedBox(width: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CustomNetworkImage(
                                    src: widget.product.imageUrl,
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        if (widget.product.colors.isNotEmpty &&
                                            widget.product.sizes.isEmpty)
                                          Text(
                                            'Color',
                                            style: theme.headlineMedium!.copyWith(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        if (widget.product.sizes.isNotEmpty &&
                                            widget.product.colors.isEmpty)
                                          Text(
                                            'Size',
                                            style: theme.headlineMedium!.copyWith(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        if (widget.product.colors.isNotEmpty &&
                                            widget.product.sizes.isNotEmpty)
                                          Text(
                                            'Color, Size',
                                            style: theme.headlineMedium!.copyWith(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        if (widget.product.colors.isNotEmpty &&
                                            widget.product.sizes.isEmpty)
                                          Text(
                                            _color,
                                            style: theme.headlineMedium,
                                          ),
                                        if (widget.product.sizes.isNotEmpty &&
                                            widget.product.colors.isEmpty)
                                          Text(
                                            _size,
                                            style: theme.headlineMedium,
                                          ),
                                        if (widget.product.colors.isNotEmpty &&
                                            widget.product.sizes.isNotEmpty)
                                          Text(
                                            '$_color / $_size',
                                            style: theme.headlineMedium,
                                          ),
                                      ],
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
                    style: theme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.product.description,
                    style: theme.titleLarge,
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
          children: <Widget>[
            const SizedBox(width: 24),
            FutureBuilder<UserModel>(
              future: FireStoreServices().getUserByUid(uid: widget.product.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return const Text('Something went wrong');
                }
                return OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ConversationScreen(
                          user: snapshot.data!,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Chat'),
                );
              },
            ),
            const SizedBox(width: 32),
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CartLoaded) {
                    return CustomButton(
                      svg: 'assets/svgs/shopping_bag.svg',
                      press: () {
                        context.read<CartBloc>().add(
                              AddProduct(
                                CartItem(
                                  id: 'ci${widget.product.id}',
                                  productId: widget.product.id,
                                  color: widget.product.colors.isEmpty
                                      ? 'n'
                                      : widget.product.colors[0],
                                  size: widget.product.sizes.isEmpty
                                      ? 'n'
                                      : widget.product.sizes[0],
                                  quantity: 1,
                                  price: widget.product.price,
                                  sellerId: widget.product.uid,
                                ),
                              ),
                            );
                            showSnackBar(context, 'Added to your cart');
                      },
                      textColor: Colors.white,
                      primaryColor: Colors.deepOrange[400]!,
                      svgColor: Colors.white,
                      title: 'Add to Cart',
                    );
                  } else {
                    return const Text('Something went wrong');
                  }
                },
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
