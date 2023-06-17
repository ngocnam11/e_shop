import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_shop/logic/blocs/checkout/checkout_bloc.dart';

import '../../data/models/cart.dart';
import '../../data/models/product.dart';
import '../../logic/blocs/cart/cart_bloc.dart';
import '../../services/firestore_services.dart';
import 'custom_network_image.dart';

class ItemInCart extends StatefulWidget {
  const ItemInCart({super.key, required this.product});

  final CartItem product;

  @override
  State<ItemInCart> createState() => _ItemInCartState();
}

class _ItemInCartState extends State<ItemInCart> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<Product>(
          future:
              FireStoreServices().getProductById(id: widget.product.productId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return const Text('Something went wrong');
            }
            return Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CustomNetworkImage(
                    src: snapshot.data!.imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              snapshot.data!.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                              if (isChecked == true) {
                                context
                                    .read<CheckoutBloc>()
                                    .add(AddProductToCheckout(widget.product));
                              } else {
                                context
                                    .read<CheckoutBloc>()
                                    .add(EmptyCheckout());
                              }
                            },
                          ),
                          const SizedBox(
                            height: 32,
                            width: 32,
                          ),
                        ],
                      ),
                      Text(
                        '${widget.product.color}, ${widget.product.size}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '\$${widget.product.price}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  if (isChecked) {
                                    context
                                        .read<CartBloc>()
                                        .add(RemoveProduct(widget.product));
                                    context.read<CheckoutBloc>().add(
                                        RemoveProductFromCheckout(widget.product
                                            .copyWith(quantity: 1)));
                                  } else {
                                    context
                                        .read<CartBloc>()
                                        .add(RemoveProduct(widget.product));
                                  }
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text(
                                widget.product.quantity.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (isChecked) {
                                    context
                                        .read<CartBloc>()
                                        .add(AddProduct(widget.product));
                                    context.read<CheckoutBloc>().add(
                                        AddProductToCheckout(widget.product
                                            .copyWith(quantity: 1)));
                                  } else {
                                    context
                                        .read<CartBloc>()
                                        .add(AddProduct(widget.product));
                                  }
                                },
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
