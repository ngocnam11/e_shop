import 'dart:typed_data';

import '../../models/product.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts();
  Stream<List<Product>> getCurrentUserProducts();
  Stream<List<Product>> get5Products();
  Stream<List<Product>> getProductsByRecentSearch(List<String> recentSearch);
  Stream<List<Product>> get5ProductsByRecentSearch(List<String> recentSearch);
  Future<void> addProduct({
    required String name,
    required String category,
    required double price,
    required int quantity,
    required Uint8List file,
    required String description,
    required List<String> colors,
    required List<String> sizes,
  });
  Future<Product> getProductById(String id);
  Future<void> updateProduct({
    required String id,
    String? name,
    String? category,
    Uint8List? file,
    double? price,
    int? quantity,
    String? description,
    List<String>? colors,
    List<String>? sizes,
  });
  Future<void> deleteProduct(String id);
}
