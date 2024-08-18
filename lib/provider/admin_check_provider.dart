import 'package:ecom_boni_admin/db/firestore_helper.dart';
import 'package:flutter/foundation.dart';

class AdminCheckProvider extends ChangeNotifier {
  Future<bool> checkAmin(String email) => FirestoreHelper.checkAdmin(email);
}
