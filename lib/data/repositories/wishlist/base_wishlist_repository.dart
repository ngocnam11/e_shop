import '../../models/product.dart';
import '../../models/wishlist.dart';

abstract class BaseWishlistRepository {
  Stream<Wishlist> getWishlist();
  Future<void> addProductToWishlist(Product product);
  Future<void> removeProductFromWishlist(Product product);
}
