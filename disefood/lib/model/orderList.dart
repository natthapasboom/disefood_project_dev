class OrderList {
  List<Data> data;

  OrderList({this.data});

  OrderList.fromJson(Map<String, dynamic> json) {
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
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
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
  Null createdAt;
  Null updatedAt;

  OrderDetails(
      {this.id,
      this.description,
      this.orderId,
      this.foodId,
      this.price,
      this.quantity,
      this.createdAt,
      this.updatedAt});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    orderId = json['order_id'];
    foodId = json['food_id'];
    price = json['price'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}
