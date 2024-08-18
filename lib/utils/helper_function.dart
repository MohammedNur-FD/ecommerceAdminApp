import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getFormattedDate(DateTime datetime, String format) {
  return DateFormat(format).format(datetime);
}

Future<bool> isConnectivityToInternet() async {
  final result = await Connectivity().checkConnectivity();
  // ignore: unrelated_type_equality_checks
  if (result == ConnectivityResult.mobile ||
      // ignore: unrelated_type_equality_checks
      result == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

void showAlertDailog(BuildContext context, String title, String labelText1,
    String labelText2, VoidCallback onPressed1, VoidCallback onPressed2) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            textAlign: TextAlign.center,
            title,
            style: const TextStyle(color: Colors.black),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: onPressed1,
              child: Chip(label: Text(labelText1)),
            ),
            TextButton(
                onPressed: onPressed2, child: Chip(label: Text(labelText2)))
          ],
        );
      });
}
