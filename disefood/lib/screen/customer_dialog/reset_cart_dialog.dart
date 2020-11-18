import 'package:disefood/model/cart.dart';
import 'package:disefood/screen/customer_utilities/sqlite_helper.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ResetCart extends StatefulWidget {
  final String shopId;
  final String shopName;
  final int foodId;
  final String foodName;
  final int qty;
  final String foodDescription;
  final int foodPrice;
  final String foodImg;
  final int foodIndex;
  final VoidCallback readSQLite;
  final Function(int, int) checkQuantity;
  const ResetCart({
    Key key,
    @required this.shopId,
    @required this.shopName,
    @required this.foodId,
    @required this.foodName,
    @required this.qty,
    @required this.foodDescription,
    @required this.foodPrice,
    @required this.foodImg,
    @required this.foodIndex,
    @required this.readSQLite,
    @required this.checkQuantity,
  }) : super(key: key);
  @override
  _ResetCartState createState() => _ResetCartState();
}

class _ResetCartState extends State<ResetCart> {
  VoidCallback readSQLite;
  Function(int, int) checkQuantity;
  String shopId;
  String shopName;
  int foodId;
  String foodName;
  int qty;
  String foodDescription;
  int foodPrice;
  String foodImg;
  int foodIndex;
  @override
  void initState() {
    readSQLite = widget.readSQLite;
    checkQuantity = widget.checkQuantity;
    setState(() {
      shopId = widget.shopId;
      shopName = widget.shopName;
      foodId = widget.foodId;
      foodName = widget.foodName;
      qty = widget.qty;
      foodDescription = widget.foodDescription;
      foodPrice = widget.foodPrice;
      foodImg = widget.foodImg;
      foodIndex = widget.foodIndex;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  Future<Null> deleteAllFoodInCart() async {
    await SQLiteHelper().deleteAllData();
    addFoodToCart();
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
    orderMap['foodDescription'] = foodDescription;
    orderMap['foodPrice'] = foodPrice;
    orderMap['foodSumPrice'] = foodPrice * qty;
    orderMap['foodImg'] = foodImg;
    print('Food Data :  ${orderMap.toString()} ');
    CartModel cartModel = CartModel.fromJson(orderMap);

    await SQLiteHelper().insertDataToSQLite(cartModel).then(
      (value) {
        showToast("เพิ่มไปยังตะกร้าเรียบร้อยแล้ว");
        readSQLite();
        checkQuantity(foodIndex, qty);
      },
    );
  }

  _buildChild(BuildContext context) => Card(
        child: Container(
          height: 150,
          width: 400.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 0.0),
              Container(
                alignment: Alignment.centerLeft,
                margin:
                    EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 0),
                child: Text(
                  'เริ่มตะกร้าใหม่?',
                  style: TextStyle(
                    fontFamily: 'Aleo-Bold',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 0, left: 20, right: 0, bottom: 0),
                child: Text(
                  'รายการอาหารร้านก่อนหน้าจะถูกยกเลิก',
                  style: TextStyle(
                    fontFamily: 'Aleo-Bold',
                    fontSize: 15.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 0, left: 20, right: 0, bottom: 15),
                child: Text(
                  'ต้องการดำเนินการต่อหรือไม่?',
                  style: TextStyle(
                    fontFamily: 'Aleo-Bold',
                    fontSize: 15.0,
                  ),
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
                          deleteAllFoodInCart();
                          readSQLite();
                          checkQuantity(foodIndex, qty);
                          showToast("เพิ่มไปยังตะกร้าเรียบร้อยแล้ว");
                          Navigator.of(context).pop(true);
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
      );
}
