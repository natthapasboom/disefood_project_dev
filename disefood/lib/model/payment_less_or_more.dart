class PaymentLessOrMore {
  Data data;
  String msg;

  PaymentLessOrMore({this.data, this.msg});

  PaymentLessOrMore.fromJson(Map<String, dynamic> json) {
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
  String msg;
  int different;

  Data({this.msg, this.different});

  Data.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    different = json['different'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['different'] = this.different;
    return data;
  }
}
