import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecom_boni_admin/models/product_model.dart';
import 'package:ecom_boni_admin/provider/add_new_product_provider.dart';
import 'package:ecom_boni_admin/provider/category_provider.dart';
import 'package:ecom_boni_admin/utils/contants.dart';
import 'package:ecom_boni_admin/utils/helper_function.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({super.key});
  static const String routeName = '/new_product';

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final ProductModel _productModel = ProductModel();
  bool isSaving = false;
  DateTime? _dateTime;
  final _fromKey = GlobalKey<FormState>();
  String? _category;
  ImageSource _imageSource = ImageSource.camera;
  String? _imagePath;
  late CategoryProvider _categoryProvider;
  late AddNewProductProvider _addNewProductProvider;
  String collectionCategory = 'Categories';
  final _formlKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    _categoryProvider = Provider.of<CategoryProvider>(context);
    _addNewProductProvider = Provider.of<AddNewProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Product',
        ),
        actions: [
          IconButton.outlined(
              onPressed: _saveProduct, icon: const Icon(Icons.save))
        ],
      ),
      body: Stack(
        children: [
          if (isSaving)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          _productInputSection(),
        ],
      ),
    );
  }

  Widget _productInputSection() {
    return Form(
      key: _fromKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          _inputTextScetion(),
          const SizedBox(
            height: 10,
          ),
          _drodownCategoryMenuItem(),
          const SizedBox(
            height: 10,
          ),
          _datePickerSection(),
          const SizedBox(
            height: 16,
          ),
          _imagePickerSection()
        ],
      ),
    );
  }

  Widget _imagePickerSection() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: _imagePath == null
              ? Image.asset(
                  'images/placeholder.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              : Image.file(File(_imagePath!),
                  width: 100, height: 100, fit: BoxFit.cover),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 10,
          child: Row(
            children: [
              const SizedBox(
                width: 70,
              ),
              ElevatedButton(
                  onPressed: () {
                    _imageSource = ImageSource.camera;
                    _imagePick();
                  },
                  child: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    _imageSource = ImageSource.gallery;
                    _imagePick();
                  },
                  child: const Text(
                    'Gallery',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget _datePickerSection() {
    return Card(
      elevation: 10,
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: _sowDatePicker,
            icon: const Icon(Icons.date_range),
            label: const Text(
              'Select Date',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 100,
          ),
          Text(_dateTime == null
              ? 'No date chosen'
              : getFormattedDate(_dateTime!, 'dd/MM/yyyy')),
        ],
      ),
    );
  }

  Widget _drodownCategoryMenuItem() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            hint: const Text(
              'Select Category',
              selectionColor: Colors.black,
            ),
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            dropdownColor: Colors.black,
            borderRadius: BorderRadius.circular(10),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
            items: _categoryProvider.categoryList
                .map((cate) => DropdownMenuItem(
                      value: cate,
                      child: Text(cate),
                    ))
                .toList(),
            value: _category,
            onChanged: (value) {
              setState(() {
                _category = value;
              });
              _productModel.category = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            onPressed: () {
              _addNewCategoryDailogBox(context);
            },
            icon: const Icon(
              Icons.add,
              size: 25,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  void _saveProduct() {
    if (_fromKey.currentState!.validate()) {
      _fromKey.currentState!.save();
      if (_dateTime == null) {
        showMessage(context, 'Please a select a date');
        return;
      }
      if (_imagePath == null) {
        showMessage(context, 'Please a select an image');
        return;
      }
      setState(() {
        isSaving = true;
      });
      // print(_productModel);
      _uplodeImageAndSvaeProduct();
    }
  }

  void _sowDatePicker() async {
    final dt = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2),
        lastDate: DateTime.now());
    if (dt != null) {
      setState(() {
        _dateTime = dt;
      });
      _productModel.purchaseDate = Timestamp.fromDate(_dateTime!);
    }
  }

  void _imagePick() async {
    final pickedFile = await ImagePicker().pickImage(source: _imageSource);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
      _productModel.localImagePath = _imagePath;
    }
  }

  void _uplodeImageAndSvaeProduct() async {
    final uploadFile = File(_imagePath!);
    final imageName = 'Product_${DateTime.now()}';
    final photoRef =
        FirebaseStorage.instance.ref().child('$photoDirectory/$imageName');
    try {
      final uploadTask = photoRef.putFile(uploadFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final dlUrl = await snapshot.ref.getDownloadURL();
      _productModel.downlodeImageUrl = dlUrl;
      _productModel.imageName = imageName;
      _addNewProductProvider.insertNewProduct(_productModel).then((_) {
        setState(() {
          isSaving = false;
        });
        Navigator.pop(context);
      });
    } catch (error) {
      setState(() {
        isSaving = false;
      });
      // ignore: use_build_context_synchronously
      showMessage(context, 'Failed to upload image');
    }
  }

  Widget _inputTextScetion() {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'this filed must not be empty';
            }
            return null;
          },
          onSaved: (value) {
            _productModel.name = value;
          },
          decoration: const InputDecoration(
            label: Text(
              'Product Name',
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          maxLength: 100,
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'this filed must not be empty';
            }
            return null;
          },
          onSaved: (value) {
            _productModel.description = value;
          },
          decoration: const InputDecoration(
            label: Text('Dsescription'),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'this filed must not be empty';
            }
            return null;
          },
          onSaved: (value) {
            _productModel.price = num.parse(value!);
          },
          decoration: const InputDecoration(
            label: Text('Price'),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'this filed must not be empty';
            }
            return null;
          },
          onSaved: (value) {
            _productModel.stock = int.parse(value!);
          },
          decoration: const InputDecoration(
            label: Text(
              'Quantity',
              selectionColor: Colors.white,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
      ],
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
}
