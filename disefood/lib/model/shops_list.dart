class Shops {
  int shopId;
  int shopSlot;
  String name;
  String coverImage;
  String createdAt;
  String updatedAt;

  Shops(
      {this.shopId,
      this.shopSlot,
      this.name,
      this.coverImage,
      this.createdAt,
      this.updatedAt});

  Shops.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    shopSlot = json['shop_slot'];
    name = json['name'];
    coverImage = json['cover_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['shop_slot'] = this.shopSlot;
    data['name'] = this.name;
    data['cover_image'] = this.coverImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future<List<Shops>> fetchShops(http.Client client) async {
//   final response = await client.get('http://10.0.2.2:8000/api/shops/');

//   return compute(parseShops, response.body);
// }

// List<Shops> parseShops(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

//   return parsed.map<Shops>((json) => Shops.fromJson(json)).toList();
// }

// class Shops {
//   final int shop_id;
//   final int shop_slot;
//   final String name;

//   Shops({this.shop_id, this.shop_slot, this.name});

//   factory Shops.fromJson(Map<String, dynamic> json) {
//     return Shops(
//       shop_id: json['shop_id'] as int,
//       shop_slot: json['shop_slot'] as int,
//       name: json['name'] as String,
//     );
//   }
// }

// class ShopsList extends StatelessWidget {
//   final List<Shops> shops;

//   ShopsList({Key key, this.shops}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: shops.length,
//       itemBuilder: (context, index) {
//         return Text('${shops[index].name}');
//       },
//     );
//   }
// }

// class ShopsApi extends StatefulWidget {
//   @override
//   _ShopsApiState createState() => _ShopsApiState();
// }

// class _ShopsApiState extends State<ShopsApi> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("title"),
//       ),
//       body: FutureBuilder<List<Shops>>(
//         future: fetchShops(http.Client()),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) print(snapshot.error);

//           return snapshot.hasData
//               ? ShopsList(shops: snapshot.data)
//               : Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }
