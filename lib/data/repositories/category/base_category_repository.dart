import '../../models/category.dart';

abstract class BaseCategoryRepository {
  Stream<List<Category>> getCategories();
}
