import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_boni_admin/models/product_model.dart';

class FirestoreHelper {
  static const String _collectionAdmin = 'Admins';
  // ignore: unused_field
  static const String _collectionProduct = 'Products';
  static const String _collectionCategory = 'Categories';
  // ignore: unused_field
  static const String _collectionUser = 'Users';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategorise() =>
      _db.collection(_collectionCategory).orderBy('name').snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(_collectionProduct).snapshots();

  static Future<void> addNewProduct(ProductModel productModel) {
    final docFef = _db.collection(_collectionProduct).doc();
    productModel.id = docFef.id;
    return docFef.set(productModel.ToMap());
  }

  static void deleteCategory() {
    _db.collection(_collectionCategory).doc().delete();
  }

  static Future<bool> checkAdmin(String email) async {
    final snapshot = await _db
        .collection(_collectionAdmin)
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
