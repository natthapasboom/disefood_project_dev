import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/favorite.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  ApiProvider apiProvider = ApiProvider();
  Logger logger = Logger();
  Future<Favorite> _favorites;
  var favorites;
  @override
  void initState() {
    super.initState();
    _favorites = getFavoriteByMe();
  }

  Future<Favorite> getFavoriteByMe() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    var response = await apiProvider.getFavoriteByMe(token);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      Map jsonMap = json.decode(jsonString);
      favorites = Favorite.fromJson(jsonMap);
      setState(() {});
    } else {
      logger.e('status : ${response.statusCode}');
    }
    return favorites;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 40, top: 30),
                child: Text(
                  "รายการโปรด",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'Roboto'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Divider(
                  thickness: 1,
                  indent: 40,
                  color: Colors.black,
                  endIndent: 40,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: FutureBuilder<Favorite>(
                  future: _favorites,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data.data[index];
                            return Container(
                              margin: EdgeInsets.only(
                                  bottom: 0, top: 20, left: 40, right: 40),
                              child: InkWell(
                                onTap: () {},
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 5,
                                  color: Colors.white70,
                                  // margin: EdgeInsets.only(
                                  //     top: 8, bottom: 8, left: 40, right: 40),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        imageUrl:
                                            "https://disefood.s3-ap-southeast-1.amazonaws.com/" +
                                                "${data.shop.coverImg}",
                                        width: 380,
                                        height: 140,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 50, bottom: 35),
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 5.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          const Color(
                                                              0xffF6A911)),
                                                ))),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: 140,
                                          width: 380,
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
                                      Container(
                                        color: Colors.grey[50],
                                        child: ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "0.${data.shopId}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    child: VerticalDivider(
                                                      color: Colors.black38,
                                                      thickness: 3,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${data.shop.name}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    child: VerticalDivider(
                                                      color: Colors.black38,
                                                      thickness: 3,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // subtitle: Row(
                                          //   children: <Widget>[
                                          //     Icon(
                                          //       Icons.star,
                                          //       color: Colors.orange,
                                          //     ),
                                          //     Text("  4.2 Review(20 Review)")
                                          //   ],
                                          // ),
                                        ),
                                      ),
                                    ],
//          crossAxisAlignment: CrossAxisAlignment.start,
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Container(
                        margin: EdgeInsets.only(top: 150),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5.0,
                            valueColor:
                                AlwaysStoppedAnimation(const Color(0xffF6A911)),
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
