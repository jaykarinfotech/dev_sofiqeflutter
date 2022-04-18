class LooksMs3Model {
  int? totalRecords;
  List<Items>? items;
  int? status;
  String? message;

  LooksMs3Model({this.totalRecords, this.items, this.status, this.message});

  LooksMs3Model.fromJson(Map<String, dynamic> json) {
    totalRecords = json['totalRecords'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalRecords'] = this.totalRecords;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Items {
  String? entityId;
  String? name;
  String? identifier;
  String? header;
  String? description;
  String? image;
  String? discount;
  String? fromDate;
  String? toDate;
  String? country;
  String? imageUrl;
  String? sku;
  var oldPrice;
  var price;
  double? rating = 0.0;

  Items(
      {this.entityId,
      this.name,
      this.identifier,
      this.header,
      this.description,
      this.image,
      this.discount,
      this.fromDate,
      this.toDate,
      this.country,
      this.imageUrl,
      this.sku,
      this.oldPrice,
      this.price,
      this.rating,
      });

  Items.fromJson(Map<String, dynamic> json) {
    entityId = json['entity_id'];
    name = json['name'];
    identifier = json['identifier'];
    header = json['header'];
    description = json['description'];
    image = json['image'];
    discount = json['discount'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    country = json['country'];
    imageUrl = json['image_url'];
    sku = json['sku'];
    try {
      oldPrice = double.tryParse(json['old_price']);
    } catch (e) {
      oldPrice = 99.9;
    }

    try {
      price = double.tryParse(json['price']);
      print("PRICE: $price");
    } catch (e) {
      price = 00.0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entity_id'] = this.entityId;
    data['name'] = this.name;
    data['identifier'] = this.identifier;
    data['header'] = this.header;
    data['description'] = this.description;
    data['image'] = this.image;
    data['discount'] = this.discount;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['country'] = this.country;
    data['image_url'] = this.imageUrl;
    data['sku'] = this.sku;
    data['old_price'] = this.oldPrice;
    data['price'] = this.price;
    return data;
  }
}
