class GetPayment {
  Data data;
  String msg;

  GetPayment({this.data, this.msg});

  GetPayment.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Data {
  int id;
  String transactionId;
  int orderId;
  int amount;
  String paymentDate;
  String paymentImg;
  String createdAt;
  String updatedAt;
  Order order;

  Data(
      {this.id,
      this.transactionId,
      this.orderId,
      this.amount,
      this.paymentDate,
      this.paymentImg,
      this.createdAt,
      this.updatedAt,
      this.order});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    orderId = json['order_id'];
    amount = json['amount'];
    paymentDate = json['payment_date'];
    paymentImg = json['payment_img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_id'] = this.transactionId;
    data['order_id'] = this.orderId;
    data['amount'] = this.amount;
    data['payment_date'] = this.paymentDate;
    data['payment_img'] = this.paymentImg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    return data;
  }
}

class Order {
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

  Order(
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
      this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
