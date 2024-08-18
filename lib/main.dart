import 'package:ecom_boni_admin/firebase_options.dart';
import 'package:ecom_boni_admin/pages/category_list_page.dart';
import 'package:ecom_boni_admin/pages/dashboad_page.dart';
import 'package:ecom_boni_admin/pages/launcher_page.dart';
import 'package:ecom_boni_admin/pages/login_page.dart';
import 'package:ecom_boni_admin/pages/new_product_page.dart';
import 'package:ecom_boni_admin/pages/order_list_page.dart';
import 'package:ecom_boni_admin/pages/product_list_page.dart';
import 'package:ecom_boni_admin/provider/add_new_product_provider.dart';
import 'package:ecom_boni_admin/provider/admin_check_provider.dart';
import 'package:ecom_boni_admin/provider/category_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdminCheckProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => AddNewProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadowColor: Colors.black,
              elevation: 10,
              foregroundColor: Colors.white,
              iconColor: Colors.white,
              backgroundColor: Colors.black,
            ),
          ),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(color: Colors.white, fontSize: 18),
          ),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 11, 136, 98),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
        ),
        home: const LauncherPage(),
        routes: {
          LauncherPage.routeName: (context) => const LauncherPage(),
          LoginPage.routeName: (context) => const LoginPage(),
          DashboadPage.routeName: (context) => const DashboadPage(),
          NewProductPage.routeName: (context) => const NewProductPage(),
          ProductListPage.routeName: (context) => const ProductListPage(),
          OrderListPage.routeName: (context) => const OrderListPage(),
          CategoryListPage.routeName: (context) => const CategoryListPage(),
        },
      ),
    );
  }
}
