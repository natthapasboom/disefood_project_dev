class ShopList {
  List<Data> data;
  String msg;
  int status;

  ShopList({this.data, this.msg, this.status});

  ShopList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    msg = json['msg'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int id;
  int userId;
  int shopSlot;
  String name;
  String coverImg;
  int approved;
  String deletedAt;
  String createdAt;
  String updatedAt;
  double averageRating;
  List<Feedbacks> feedbacks;

  Data(
      {this.id,
      this.userId,
      this.shopSlot,
      this.name,
      this.coverImg,
      this.approved,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.averageRating,
      this.feedbacks});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    shopSlot = json['shop_slot'];
    name = json['name'];
    coverImg = json['cover_img'];
    approved = json['approved'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    averageRating = json['averageRating'];
    if (json['feedbacks'] != null) {
      feedbacks = new List<Feedbacks>();
      json['feedbacks'].forEach((v) {
        feedbacks.add(new Feedbacks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['shop_slot'] = this.shopSlot;
    data['name'] = this.name;
    data['cover_img'] = this.coverImg;
    data['approved'] = this.approved;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['averageRating'] = this.averageRating;
    if (this.feedbacks != null) {
      data['feedbacks'] = this.feedbacks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feedbacks {
  int id;
  int userId;
  int shopId;
  String comment;
  String rating;
  String createdAt;
  String updatedAt;

  Feedbacks(
      {this.id,
      this.userId,
      this.shopId,
      this.comment,
      this.rating,
      this.createdAt,
      this.updatedAt});

  Feedbacks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    shopId = json['shop_id'];
    comment = json['comment'];
    rating = json['rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['shop_id'] = this.shopId;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
