// To parse this JSON data, do
//
//     final ms8Model = ms8ModelFromJson(jsonString);

import 'dart:convert';

List<Ms8Model> ms8ModelFromJson(String str) => List<Ms8Model>.from(json.decode(str).map((x) => Ms8Model.fromJson(x)));

String ms8ModelToJson(List<Ms8Model> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ms8Model {
  Ms8Model({
    this.lookImage,
    this.lookDescription,
    this.customerCurrency,
    this.lookAvgrating,
    this.lookPrice,
    this.lookDiscountedPrice,
    this.status,
    this.message,
  });

  String? lookImage;
  String? lookDescription;
  String? customerCurrency;
  String? lookAvgrating;
  double? lookPrice;
  double? lookDiscountedPrice;
  int? status;
  String? message;

  factory Ms8Model.fromJson(Map<String, dynamic> json) => Ms8Model(
    lookImage: json["look_image"],
    lookDescription: json["look_description"],
    customerCurrency: json["customer_currency"],
    lookAvgrating: json["look_avgrating"],
    lookPrice: double.parse(json["look_price"].toString()),
    lookDiscountedPrice: double.parse(json["look_discounted_price"].toString()),
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "look_image": lookImage,
    "look_description": lookDescription,
    "customer_currency": customerCurrency,
    "look_avgrating": lookAvgrating,
    "look_price": lookPrice,
    "look_discounted_price": lookDiscountedPrice,
    "status": status,
    "message": message,
  };
}
