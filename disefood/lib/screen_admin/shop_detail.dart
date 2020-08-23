import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ShopDetail extends StatefulWidget {
  final int shopId;
  final String name;
  final int shopSlot;
  final String coverImg;
  const ShopDetail(
      {Key key,
      @required this.shopId,
      @required this.name,
      @required this.shopSlot,
      @required this.coverImg})
      : super(key: key);

  @override
  _ShopDetailState createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  Logger logger = Logger();
  String name;
  String coverImg;
  int id;
  int shopSlot;
  @override
  void initState() {
    super.initState();
    setState(() {
      name = widget.name;
      coverImg = widget.coverImg;
      shopSlot = widget.shopSlot;
      id = widget.shopId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 40, top: 30),
                child: Text(
                  "รายละเอียดร้านค้า",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      fontFamily: 'Aleo'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Divider(
                  indent: 40,
                  color: Colors.black,
                  endIndent: 40,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, top: 10, right: 40),
                decoration: BoxDecoration(
                  color: coverImg == null ? Colors.grey[200] : Colors.white,
                  border: Border.all(width: 1),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://disefood.s3-ap-southeast-1.amazonaws.com/$coverImg",
                  fit: BoxFit.fitHeight,
                  height: 173,
                  width: 332,
                  placeholder: (context, url) => Container(
                      height: 173,
                      margin: EdgeInsets.only(top: 0, bottom: 0, left: 0),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.amber[900],
                        ),
                      )),
                  errorWidget: (context, url, error) => Container(
                    height: 173,
                    width: 332,
                    color: const Color(0xff7FC9C5),
                    child: Center(
                      child: Icon(
                        Icons.store,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
