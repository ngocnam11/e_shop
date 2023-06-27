import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/product.dart';
import '../../../data/repositories/repositories.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductLoading()) {
    on<LoadProducts>((event, emit) {
      _productRepository.getAllProducts().listen(
            (products) => add(UpdateProducts(products)),
          );
    });
    on<UpdateProducts>((event, emit) {
      emit(ProductLoaded(products: event.products));
    });
  }
}
