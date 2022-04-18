class ShoppingHistoryModel {
  String? result;
  Data? data;

  ShoppingHistoryModel({this.result, this.data});

  ShoppingHistoryModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? orderId;
  String? orderIncrementId;
  String? date;
  String? status;
  String? state;
  List<Items>? items;

  Data(
      {this.orderId,
      this.orderIncrementId,
      this.date,
      this.status,
      this.state,
      this.items});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderIncrementId = json['order_increment_id'];
    date = json['date'];
    status = json['status'];
    state = json['state'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_increment_id'] = this.orderIncrementId;
    data['date'] = this.date;
    data['status'] = this.status;
    data['state'] = this.state;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? sku;
  String? name;
  String? image;
  String? orderQty;
  String? price;
  var productOptions;
  var additionalOptions;

  Items(
      {this.sku,
      this.name,
      this.image,
      this.orderQty,
      this.price,
      this.productOptions,
      this.additionalOptions});

  Items.fromJson(Map<String, dynamic> json) {
    sku = json['sku'];
    name = json['name'];
    image = json['image'];
    orderQty = json['order_qty'];
    price = json['price'];
    if (json['productOptions'] != null) {
      productOptions = [];
     productOptions= json['productOptions'];
    }
    if (json['additionalOptions'] != null) {
      additionalOptions =[];
      additionalOptions= json['additionalOptions'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku'] = this.sku;
    data['name'] = this.name;
    data['image'] = this.image;
    data['order_qty'] = this.orderQty;
    data['price'] = this.price;
    if (this.productOptions != null) {
      data['productOptions'] =
          this.productOptions.map((v) => v.toJson()).toList();
    }
    if (this.additionalOptions != null) {
      data['additionalOptions'] =
          this.additionalOptions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
