import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/favorite.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'menu_page.dart';

class FavoritePage extends StatefulWidget {
  final double rating;
  const FavoritePage({
    Key key,
    @required this.rating,
  }) : super(key: key);
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  double rating;
  List shops = [];
  ApiProvider apiProvider = ApiProvider();
  Logger logger = Logger();
  Future<Favorite> _favorites;
  var favorites;
  @override
  void initState() {
    getShops();
    setState(() {
      rating = widget.rating;
    });
    super.initState();
    _favorites = getFavoriteByMe();
  }

  Future getShops() async {
    String _url = 'http://54.151.194.224:8000/api/shop';
    final response = await http.get(_url);
    var body = response.body;
    setState(() {
      shops = json.decode(body)['data'];
    });
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
                padding: EdgeInsets.only(left: 40, top: 20),
                child: Text(
                  "รายการโปรด",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'Roboto'),
                ),
              ),
              Container(
                child: Divider(
                  thickness: 1,
                  indent: 40,
                  color: Colors.black,
                  endIndent: 40,
                ),
              ),
              Container(
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
                                  bottom: 10, top: 5, left: 40, right: 40),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MenuPage(
                                        shopId: data.shop.id,
                                        shopName: data.shop.name,
                                        shopSlot: data.shop.shopSlot,
                                        shopCoverImg: data.shop.coverImg,
                                        rating: shops[index]["averageRating"]
                                            .toDouble(),
                                      ),
                                    ),
                                  );
                                },
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
                                            child: CircularProgressIndicator(
                                              strokeWidth: 5.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      const Color(0xffF6A911)),
                                            ),
                                          ),
                                        ),
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
                                                    "${data.shopId} ",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    child: VerticalDivider(
                                                      color: Colors.orange,
                                                      thickness: 3,
                                                    ),
                                                  ),
                                                  Text(
                                                    "  ${data.shop.name}",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              ),
                                            ],
                                          ),
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
