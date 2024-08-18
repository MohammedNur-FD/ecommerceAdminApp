import 'package:ecom_boni_admin/custom_widgets/screen.dart';
import 'package:flutter/material.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});
  static const String routeName = '/order';

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
      child: Container(),
    ));
  }
}
