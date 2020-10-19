import 'package:flutter/material.dart';

import 'order_amount_dialog.dart';
import 'order_status_dialog.dart';

class DialogHelper {
  static status(context) =>
      showDialog(context: context, builder: (context) => OrderStatus());
  // static orderAmount(context) =>
  //     showDialog(context: context, builder: (context) => OrderAmountDialog());
  //ใช้ ผ่านหน้าได้เลยไม่ต้องผ่าน DialogHelper เพราะส่งค่าไม่ได้
}
