import 'package:ecom_boni_admin/auth/firebase_auth_service.dart';
import 'package:ecom_boni_admin/custom_widgets/dashboad_grad_veiw_section.dart';
import 'package:ecom_boni_admin/pages/category_list_page.dart';
import 'package:ecom_boni_admin/pages/login_page.dart';
import 'package:ecom_boni_admin/pages/new_product_page.dart';
import 'package:ecom_boni_admin/pages/order_list_page.dart';
import 'package:ecom_boni_admin/pages/product_list_page.dart';
import 'package:ecom_boni_admin/provider/add_new_product_provider.dart';
import 'package:ecom_boni_admin/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboadPage extends StatefulWidget {
  const DashboadPage({super.key});
  static const String routeName = '/dashboad';

  @override
  State<DashboadPage> createState() => _DashboadPageState();
}

class _DashboadPageState extends State<DashboadPage> {
  late CategoryProvider _categoryProvider;
  late AddNewProductProvider _addNewProductProvider;
  @override
  void didChangeDependencies() {
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _categoryProvider.getAllCategoies();
    _addNewProductProvider =
        Provider.of<AddNewProductProvider>(context, listen: false);
    _addNewProductProvider.getAllProducts();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: _logoutAdmin,
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: _gridViewsection(context),
    );
  }

  GridView _gridViewsection(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      children: [
        DashboadGridVeiwSection(
            text: 'Add Product',
            onPressed: () {
              Navigator.pushNamed(context, NewProductPage.routeName);
            }),
        DashboadGridVeiwSection(
            text: 'View Product',
            onPressed: () {
              Navigator.pushNamed(context, ProductListPage.routeName);
            }),
        DashboadGridVeiwSection(
            text: 'Orders',
            onPressed: () {
              Navigator.pushNamed(context, OrderListPage.routeName);
            }),
        DashboadGridVeiwSection(
            text: 'Categories',
            onPressed: () {
              Navigator.pushNamed(context, CategoryListPage.routeName);
            }),
        DashboadGridVeiwSection(text: 'Customers', onPressed: () {}),
        DashboadGridVeiwSection(text: 'Purchase History', onPressed: () {}),
        DashboadGridVeiwSection(
          text: 'Reprts',
          onPressed: () {},
        ),
      ],
    );
  }

  void _logoutAdmin() {
    FirebaseAuthService.logoutAdmin().then(
        (_) => Navigator.pushReplacementNamed(context, LoginPage.routeName));
  }
}
