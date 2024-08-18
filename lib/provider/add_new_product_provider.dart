import 'package:ecom_boni_admin/db/firestore_helper.dart';
import 'package:ecom_boni_admin/models/product_model.dart';
import 'package:flutter/foundation.dart';

class AddNewProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  Future<void> insertNewProduct(ProductModel productModel) =>
      FirestoreHelper.addNewProduct(productModel);

  void getAllProducts() => FirestoreHelper.getAllProducts().listen((snapshort) {
        productList = List.generate(snapshort.docs.length,
            (index) => ProductModel.fromMap(snapshort.docs[index].data()));
        notifyListeners();
      });
}
