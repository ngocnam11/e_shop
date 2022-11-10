import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/category.dart';
import 'base_category_repository.dart';

class CategoryRepository extends BaseCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  CategoryRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Category>> getCategories() {
    return _firebaseFirestore.collection('categories').snapshots().map((snap) =>
        snap.docs.map((doc) => Category.fromJson(doc.data())).toList());
  }
}
