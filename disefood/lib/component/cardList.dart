import 'package:flutter/material.dart';

class CardDetail {
  final int quaue;
  final String image;
  final String menu;
  final String name;
  final int amount;
  final double price;
  final String time;


  CardDetail({this.quaue,this.image,this.menu,this.name,this.amount,this.price,this.time});


  static List<CardDetail> allCard(){
    var listOfCard = new List<CardDetail>();
    listOfCard.add(
      new CardDetail(
            quaue: 1,
            image: "https://sifu.unileversolutions.com/image/th-TH/recipe-topvisual/2/1260-709/%E0%B8%81%E0%B9%8B%E0%B8%A7%E0%B8%A2%E0%B9%80%E0%B8%95%E0%B8%B5%E0%B9%8B%E0%B8%A2%E0%B8%A7%E0%B8%95%E0%B9%89%E0%B8%A1%E0%B8%A2%E0%B8%B3%E0%B8%AA%E0%B8%B8%E0%B9%82%E0%B8%82%E0%B8%97%E0%B8%B1%E0%B8%A2-50357483.jpg",
            menu: "รายการอาหาร",
            name: "พะโล้"+"ส้มตำ",

      ),
    );
    return listOfCard;
  }
}


