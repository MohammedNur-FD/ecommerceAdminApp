import 'package:ecom_boni_admin/provider/add_new_product_provider.dart';
import 'package:ecom_boni_admin/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});
  static const String routeName = '/product_list';

  @override
  State<ProductListPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<ProductListPage> {
  late AddNewProductProvider _addProductProvider;
  @override
  void didChangeDependencies() {
    _addProductProvider = Provider.of<AddNewProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: _addProductProvider.productList.isEmpty
          ? const Center(
              child: Text(
                'No items found',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : ListView.builder(
              itemCount: _addProductProvider.productList.length,
              itemBuilder: (context, index) {
                final product = _addProductProvider.productList[index];
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(product.name!),
                    leading: fadedImageWidget(product.downlodeImageUrl!),
                    subtitle: Text('Stock ${product.stock.toString()}'),
                    trailing: Chip(
                      label: Text('$takaSymbol${product.price}'),
                    ),
                  ),
                );
              }),
    );
  }

  Widget fadedImageWidget(String url) {
    return FadeInImage.assetNetwork(
        fadeInDuration: const Duration(seconds: 3),
        fit: BoxFit.cover,
        fadeInCurve: Curves.bounceOut,
        placeholder: 'images/placeholder.jpg',
        image: url);
  }
}
