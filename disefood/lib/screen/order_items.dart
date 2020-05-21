import 'package:disefood/screen/order_promptpay_page.dart';
import 'package:disefood/screen/order_truewallet_page.dart';
import 'package:disefood/screen/view_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class OrderItemPage extends StatefulWidget {
  @override
  _OrderItemPageState createState() => _OrderItemPageState();
}

class _OrderItemPageState extends State<OrderItemPage> {
  bool ispromptpaybuttonselected = false;
  bool istruewalletbuttonselected = false;

  String _time = "  ยังไม่ได้เลือกเวลา";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 265),
            child: new IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          new IconButton(
            icon: new Icon(Icons.favorite),
            onPressed: () => debugPrint('Favorite'),
          ),
          new IconButton(
            icon: Icon(Icons.archive),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewOrder(),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 16, 5, 16),
                  child: Text(
                    "ข้อมูลการสั้งซื้อ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(Icons.fastfood),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  width: double.maxFinite,
                  color: Colors.grey[400],
                  child: Text(
                    "สรุปรายการอาหาร",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(50, 20, 50, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "x2",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Noodle 1",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "45",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              indent: 40,
              endIndent: 40,
              thickness: 1.5,
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(50, 20, 50, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "x2",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Noodle 2",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "45",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              indent: 40,
              endIndent: 40,
              thickness: 1.5,
              color: Colors.grey,
            ),
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  width: double.maxFinite,
                  color: Colors.grey[400],
                  child: Text(
                    "โปรดเลือกเวลารับอาหาร",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "คำแนะนำ : โปรดระบุเวลาอย่างน้อย 5 นาที เพื่อให้แม่ค้าสามารถ"),
                  Text(
                      "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tจัดเตรียมอาหารได้ทันตามกำหนดเวลา"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                    if (time.hour >= 8 && time.hour <= 15) {
                      if (time.hour > DateTime.now().hour) {
                        if (time.hour != 15) {
                          _time =
                              '  ${time.hour} : ${time.minute} : ${time.second}';
                          setState(() {});
                        } else {
                          if (time.minute > 30) {
                            _time = "  เวลาที่ระบุไม่ถูกต้อง"; //เกิน 15.30 min
                            setState(() {});
                          } else if (time.minute == 30) {
                            if (time.second > 0) {
                              _time =
                                  "  เวลาที่ระบุไม่ถูกต้อง"; //เกิน 15.30 sec
                              setState(() {});
                            } else {
                              _time =
                                  '  ${time.hour} : ${time.minute} : ${time.second}';
                              setState(() {});
                            }
                          } else {
                            _time =
                                '  ${time.hour} : ${time.minute} : ${time.second}';
                            setState(() {});
                          }
                        }
                      } else if (time.hour == DateTime.now().hour) {
                        if (time.minute >= DateTime.now().minute + 5) {
                          if (time.hour != 15) {
                            _time =
                                '  ${time.hour} : ${time.minute} : ${time.second}';
                            setState(() {});
                          } else {
                            if (time.minute > 30) {
                              _time =
                                  "  เวลาที่ระบุไม่ถูกต้อง"; // เกิน 15.30 min
                              setState(() {});
                            } else if (time.minute == 30) {
                              if (time.second > 0) {
                                _time =
                                    "  เวลาที่ระบุไม่ถูกต้อง"; //เกิน 15.30 sec
                                setState(() {});
                              } else {
                                _time =
                                    '  ${time.hour} : ${time.minute} : ${time.second}';
                                setState(() {});
                              }
                            } else {
                              _time =
                                  '  ${time.hour} : ${time.minute} : ${time.second}';
                              setState(() {});
                            }
                          }
                        } else {
                          _time =
                              "  เวลาที่ระบุไม่ถูกต้อง"; //เวลานาทีน้อยกว่าปัจจุบัน 5 min
                          setState(() {});
                        }
                      } else {
                        _time = "  เวลาที่ระบุไม่ถูกต้อง"; //น้อยกว่า now
                        setState(() {});
                      }
                    } else {
                      _time = "  เวลาที่ระบุไม่ถูกต้อง"; //เกินเวลาเปิดปิด1
                      setState(() {});
                    }
                  },
                      currentTime: DateTime.now().add(Duration(minutes: 5)),
                      locale: LocaleType.en);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.access_time,
                              size: 22.0,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            " $_time",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        ],
                      ),
                      Text(
                        "  เปลี่ยนเวลา",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  width: double.maxFinite,
                  color: Colors.grey[400],
                  child: Text(
                    "โปรดเลือกวิธีการชำระเงิน",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 205,
                      child: RaisedButton(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: BorderSide(
                            color: ispromptpaybuttonselected
                                ? Colors.orange
                                : Colors.grey,
                            width: ispromptpaybuttonselected ? 3 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 0, 2),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "พร้อมเพย์  ",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Image.network(
                                  "https://toppng.com/uploads/thumbnail//promptpay-logo-11551057371ufyvbrttny.png"),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PromptpayPage(),
                            ),
                          );
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 206,
                      child: RaisedButton(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: BorderSide(
                            color: istruewalletbuttonselected
                                ? Colors.orange
                                : Colors.grey,
                            width: istruewalletbuttonselected ? 3 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 0, 2),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "ทรูวอลเล็ท  ",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 30,
                              child: Image.network(
                                  "https://seeklogo.com/images/T/truemoney-wallet-logo-9CCDDD6CB0-seeklogo.com.png"),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TruewalletPage(),
                            ),
                          );
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "ราคารวม",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "90 บาท",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 320,
                  height: 40,
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: RaisedButton(
                    elevation: 5,
                    color: Colors.orange,
                    onPressed: () {},
                    child: Text(
                      "ยืนยันคำสั่งซื้อ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
