import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/cart.dart';
import 'package:disefood/screen/customer_dialog/reset_cart_dialog.dart';
import 'package:disefood/screen/customer_utilities/sqlite_helper.dart';
import 'package:disefood/screen/order_cart.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:toast/toast.dart';

class OrderAmountDialog extends StatefulWidget {
  final int shopId;
  final int foodId;
  final int foodIndex;
  final String foodQuantity;
  final String foodName;
  final String foodImg;
  final String shopName;
  final int foodPrice;
  final VoidCallback readSQLite;
  final Function(int, int) checkQuantity;

  const OrderAmountDialog({
    Key key,
    @required this.foodName,
    @required this.foodImg,
    @required this.foodId,
    @required this.shopId,
    @required this.shopName,
    @required this.foodPrice,
    @required this.readSQLite,
    @required this.checkQuantity,
    @required this.foodIndex,
    @required this.foodQuantity,
  }) : super(key: key);
  @override
  _OrderAmountDialogState createState() => _OrderAmountDialogState();
}

class _OrderAmountDialogState extends State<OrderAmountDialog> {
  VoidCallback readSQLite;
  Function(int, int) checkQuantity;

  Logger logger = Logger();
  int foodId;
  String shopId;
  String foodName;
  String foodImg;
  String foodQuantity;
  String foodDescription;
  int foodIndex;
  int foodPrice;
  String shopName;
  int shopSlot;
  int qty;
  String shopCoverImg;
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readSQLite = widget.readSQLite;
    checkQuantity = widget.checkQuantity;
    setState(() {
      foodName = widget.foodName;
      foodIndex = widget.foodIndex;
      if (widget.foodQuantity == " ") {
        qty = 1;
      } else {
        qty = int.parse(widget.foodQuantity);
      }

      foodImg = widget.foodImg;
      foodId = widget.foodId;
      shopId = widget.shopId.toString();
      foodPrice = widget.foodPrice;
      shopName = widget.shopName;
    });
    Future.microtask(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Card(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl:
                          'https://disefood.s3-ap-southeast-1.amazonaws.com/$foodImg',
                      height: 120,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                          child: Container(
                              margin: EdgeInsets.only(top: 50, bottom: 35),
                              child: CircularProgressIndicator(
                                strokeWidth: 5.0,
                                valueColor: AlwaysStoppedAnimation(
                                    const Color(0xffF6A911)),
                              ))),
                      errorWidget: (context, url, error) => Container(
                        height: 120,
                        width: double.maxFinite,
                        color: Colors.orange,
                        child: Center(
                          child: Icon(
                            Icons.fastfood,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // These values are based on trial & error method
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.centerLeft,
                  height: 30,
                  child: Text(
                    "$foodName",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  thickness: 8,
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 15),
                      hintText: 'คำแนะนำพิเศษ : ไม่จำเป็นต้องระบุ',
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38)),
                      enabledBorder: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black38),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                        height: 30,
                        child: FloatingActionButton(
                          backgroundColor: Colors.orange,
                          onPressed: () {
                            remove();
                          },
                          child: Icon(
                            Icons.remove,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: new Text(
                          '$qty',
                          style: new TextStyle(fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 30,
                        child: FloatingActionButton(
                          backgroundColor: Colors.orange,
                          onPressed: () {
                            add();
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 140,
                        child: RaisedButton(
                          elevation: 8,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          padding: EdgeInsets.only(left: 20, right: 20),
                          color: Colors.white,
                          child: Text(
                            "ยกเลิก",
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        width: 140,
                        child: RaisedButton(
                          elevation: 8,
                          onPressed: () {
                            if (qty == 0) {
                              deleteFoodInCart();
                              Navigator.of(context).pop(true);
                            } else {
                              addFoodToCart();
                              Navigator.of(context).pop(true);
                            }
                          },
                          padding: EdgeInsets.only(left: 20, right: 20),
                          color: Colors.orange,
                          child: Text(
                            "ตกลง",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void add() {
    qty++;
    checkButtonRemove();
    setState(() {});
  }

  void remove() {
    if (qty > 0) {
      qty--;
      checkButtonRemove();
      setState(() {});
    }
  }

  void checkButtonRemove() {
    if (qty <= 0) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  void showToast(String msg) {
    Toast.show(
      msg,
      context,
      textColor: Colors.white,
    );
  }

  Future<Null> addFoodToCart() async {
    Map<String, dynamic> orderMap = Map();
    orderMap['shopId'] = shopId;
    orderMap['shopName'] = shopName;
    orderMap['foodId'] = foodId;
    orderMap['foodName'] = foodName;
    orderMap['foodQuantity'] = qty;
    if (myController.text == "") {
      foodDescription = "-";
    } else {
      foodDescription = myController.text;
    }
    orderMap['foodDescription'] = foodDescription;
    orderMap['foodPrice'] = foodPrice;
    orderMap['foodSumPrice'] = foodPrice * qty;
    orderMap['foodImg'] = foodImg;
    print('Food Data :  ${orderMap.toString()} ');
    CartModel cartModel = CartModel.fromJson(orderMap);

    var object = await SQLiteHelper().readAllDataFromSQLite();

    if (object.length == 0) {
      await SQLiteHelper().insertDataToSQLite(cartModel).then(
        (value) {
          showToast("เพิ่มไปยังตะกร้าเรียบร้อยแล้ว");
          readSQLite();
          checkQuantity(foodIndex, qty);
        },
      );
    } else {
      String idShopSQLite = object[0].shopId;
      if (shopId == idShopSQLite) {
        await SQLiteHelper().insertDataToSQLite(cartModel).then(
          (value) {
            showToast("เพิ่มไปยังตะกร้าเรียบร้อยแล้ว");
            readSQLite();
            checkQuantity(foodIndex, qty);
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => ResetCart(
            shopId: shopId,
            shopName: shopName,
            foodId: foodId,
            foodName: foodName,
            qty: qty,
            foodDescription: foodDescription,
            foodPrice: foodPrice,
            foodImg: foodImg,
            foodIndex: foodIndex,
            readSQLite: readSQLite,
            checkQuantity: checkQuantity,
          ),
        );
      }
    }
  }

  Future<Null> deleteFoodInCart() async {
    int id = foodId;
    var object = await SQLiteHelper().readAllDataFromSQLite();
    print("Deleting FoodID : $id in cart");
    if (object.length == 0) {
      try {
        await SQLiteHelper().deleteDataWhereId(foodId).then((value) {
          print("FoodID : $id is not in cart.");
          // showToast("แก้ไขตะกร้าเรียบร้อยแล้ว");
          //ไม่ต้องแสดง
          readSQLite();
          checkQuantity(foodIndex, qty);
        });
      } catch (e) {
        print(e);
      }
    } else {
      String idShopSQLite = object[0].shopId;
      if (shopId == idShopSQLite) {
        try {
          await SQLiteHelper().deleteDataWhereId(foodId).then((value) {
            print("FoodID : $id has been deleted.");
            showToast("แก้ไขตะกร้าเรียบร้อยแล้ว");
            readSQLite();
            checkQuantity(foodIndex, qty);
          });
        } catch (e) {
          print(e);
        }
      } else {
        print("Case: Human error => No action.");
      }
    }
  }
}
