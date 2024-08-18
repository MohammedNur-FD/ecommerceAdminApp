import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_boni_admin/utils/helper_function.dart';
import 'package:flutter/material.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});
  static const String routeName = '/category';

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  // ignore: override_on_non_overriding_member
  String collectionCategory = 'Categories';
  final _formlKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 96, 109, 110),
      appBar: AppBar(
        title: const Text('Category List'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.green,
              Colors.lightBlue,
            ],
          ),
        ),
        child: _addCategory(context),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent.shade700,
        shape: const CircleBorder(),
        elevation: 10,
        onPressed: () => _addNewCategoryDailogBox(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _addNewCategoryDailogBox(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'New Category',
              style: TextStyle(color: Colors.black),
            ),
            content: Form(
              key: _formlKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new category';
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Category'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL')),
              TextButton(
                  onPressed: () {
                    if (_formlKey.currentState!.validate()) {
                      FirebaseFirestore.instance
                          .collection(collectionCategory)
                          .add({
                        'name': nameController.text,
                      }).then((value) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text('SAVE')),
            ],
          );
        });
  }

  _addCategory(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection(collectionCategory).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var category = snapshot.data!.docs[index];
            return ListTile(
              title: Text(category['name'],
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  showAlertDailog(
                      context, 'Detete your item?', 'Cancel', 'Delete', () {
                    Navigator.pop(context);
                  }, () {});
                },
              ),
            );
          },
        );
      },
    );
  }
}
