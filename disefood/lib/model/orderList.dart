class OrderLIst {
  List<Data> data;

  OrderLIst({this.data});

  OrderLIst.fromJson(Map<String, dynamic> json) {
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
  Null deletedAt;
  Null createdAt;
  Null updatedAt;
  User user;
  List<OrderDetails> orderDetails;

  Data(
      {this.id,
      this.shopId,
      this.userId,
      this.totalPrice,
      this.totalQuantity,
      this.timePickup,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.orderDetails});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    userId = json['user_id'];
    totalPrice = json['total_price'];
    totalQuantity = json['total_quantity'];
    timePickup = json['time_pickup'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
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
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int id;
  String username;
  String email;
  String firstName;
  String lastName;
  String tel;
  String profileImg;
  String role;
  String createdAt;
  String updatedAt;

  User(
      {this.id,
      this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.tel,
      this.profileImg,
      this.role,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    tel = json['tel'];
    profileImg = json['profile_img'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['tel'] = this.tel;
    data['profile_img'] = this.profileImg;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class OrderDetails {
  int id;
  Null description;
  int orderId;
  int foodId;
  int price;
  int quantity;
  Null createdAt;
  Null updatedAt;
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
  Null createdAt;
  Null updatedAt;

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