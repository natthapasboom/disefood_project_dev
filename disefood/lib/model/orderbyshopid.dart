class SellerOrderData {
  List<Data> data;

  SellerOrderData({this.data});

  SellerOrderData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  int shopId;
  int userId;
  int totalPrice;
  int totalQuantity;
  String timePickup;
  String status;
  int confirmedByCustomer;
  String deletedAt;
  String createdAt;
  String updatedAt;
  User user;
  Shop shop;
  String payment;
  List<OrderDetails> orderDetails;

  Data(
      {this.id,
      this.shopId,
      this.userId,
      this.totalPrice,
      this.totalQuantity,
      this.timePickup,
      this.status,
      this.confirmedByCustomer,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.shop,
      this.payment,
      this.orderDetails});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    userId = json['user_id'];
    totalPrice = json['total_price'];
    totalQuantity = json['total_quantity'];
    timePickup = json['time_pickup'];
    status = json['status'];
    confirmedByCustomer = json['confirmed_by_customer'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    payment = json['payment'];
    if (json['order_details'] != null) {
      orderDetails = new List<OrderDetails>();
      json['order_details'].forEach((v) {
        orderDetails.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_id'] = this.shopId;
    data['user_id'] = this.userId;
    data['total_price'] = this.totalPrice;
    data['total_quantity'] = this.totalQuantity;
    data['time_pickup'] = this.timePickup;
    data['status'] = this.status;
    data['confirmed_by_customer'] = this.confirmedByCustomer;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    data['payment'] = this.payment;
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int id;
  String username;
  String firstName;
  String lastName;
  String tel;

  User({this.id, this.username, this.firstName, this.lastName, this.tel});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    tel = json['tel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['tel'] = this.tel;
    return data;
  }
}

class Shop {
  int id;
  int shopSlot;
  String name;

  Shop({this.id, this.shopSlot, this.name});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopSlot = json['shop_slot'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_slot'] = this.shopSlot;
    data['name'] = this.name;
    return data;
  }
}

class OrderDetails {
  int id;
  String description;
  int orderId;
  int foodId;
  int price;
  int quantity;
  String createdAt;
  String updatedAt;
  Food food;

  OrderDetails(
      {this.id,
      this.description,
      this.orderId,
      this.foodId,
      this.price,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.food});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    orderId = json['order_id'];
    foodId = json['food_id'];
    price = json['price'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    food = json['food'] != null ? new Food.fromJson(json['food']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['order_id'] = this.orderId;
    data['food_id'] = this.foodId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.food != null) {
      data['food'] = this.food.toJson();
    }
    return data;
  }
}

class Food {
  int id;
  int shopId;
  String name;
  int price;
  int status;
  String coverImg;
  String createdAt;
  String updatedAt;

  Food(
      {this.id,
      this.shopId,
      this.name,
      this.price,
      this.status,
      this.coverImg,
      this.createdAt,
      this.updatedAt});

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
    coverImg = json['cover_img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_id'] = this.shopId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    data['cover_img'] = this.coverImg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
