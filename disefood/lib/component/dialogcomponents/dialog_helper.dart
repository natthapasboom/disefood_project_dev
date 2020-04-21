import 'package:disefood/component/dialogcomponents/order_status_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static status(context) =>
      showDialog(context: context, builder: (context) => OrderStatus());
}
