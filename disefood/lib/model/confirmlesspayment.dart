class ConfirmLessPayment {
  Data data;
  String msg;

  ConfirmLessPayment({this.data, this.msg});

  ConfirmLessPayment.fromJson(Map<String, dynamic> json) {
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
      this.updatedAt});

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
