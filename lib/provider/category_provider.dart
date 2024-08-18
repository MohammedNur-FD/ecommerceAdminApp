import 'package:ecom_boni_admin/db/firestore_helper.dart';
import 'package:flutter/foundation.dart';

class CategoryProvider extends ChangeNotifier {
  List<String> categoryList = [];

  void getAllCategoies() =>
      FirestoreHelper.getAllCategorise().listen((snapshort) {
        categoryList = List.generate(snapshort.docs.length,
            (index) => snapshort.docs[index].data()['name']);
        notifyListeners();
      });

  void getDeleteCategory() => FirestoreHelper.deleteCategory();
}
