// To parse this JSON data, do
//
//     final myReviewSkuModel = myReviewSkuModelFromJson(jsonString);

import 'dart:convert';

MyReviewSkuModel myReviewSkuModelFromJson(String str) => MyReviewSkuModel.fromJson(json.decode(str));

String myReviewSkuModelToJson(MyReviewSkuModel data) => json.encode(data.toJson());

class MyReviewSkuModel {
  MyReviewSkuModel({
    this.id,
    this.sku,
    this.name,
    this.attributeSetId,
    this.price,
    this.status,
    this.visibility,
    this.typeId,
    this.createdAt,
    this.updatedAt,
    this.extensionAttributes,
    this.productLinks,
    this.options,
    this.mediaGalleryEntries,
    this.tierPrices,
    this.customAttributes,
  });

  int? id;
  String? sku;
  String? name;
  int? attributeSetId;
  double? price;
  int? status;
  int? visibility;
  String? typeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  ExtensionAttributes? extensionAttributes;
  List<dynamic>? productLinks;
  List<dynamic>? options;
  List<MediaGalleryEntry>? mediaGalleryEntries;
  List<dynamic>? tierPrices;
  List<CustomAttribute>? customAttributes;

  factory MyReviewSkuModel.fromJson(Map<String, dynamic> json) => MyReviewSkuModel(
    id: json["id"] == null ? null : json["id"],
    sku: json["sku"] == null ? null : json["sku"],
    name: json["name"] == null ? null : json["name"],
    attributeSetId: json["attribute_set_id"] == null ? null : json["attribute_set_id"],
    price: json["price"] == null ? 0.0 : double.parse(json["price"].toString()),
    status: json["status"] == null ? null : json["status"],
    visibility: json["visibility"] == null ? null : json["visibility"],
    typeId: json["type_id"] == null ? null : json["type_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    extensionAttributes: json["extension_attributes"] == null ? null : ExtensionAttributes.fromJson(json["extension_attributes"]),
    productLinks: json["product_links"] == null ? null : List<dynamic>.from(json["product_links"].map((x) => x)),
    options: json["options"] == null ? null : List<dynamic>.from(json["options"].map((x) => x)),
    mediaGalleryEntries: json["media_gallery_entries"] == null ? null : List<MediaGalleryEntry>.from(json["media_gallery_entries"].map((x) => MediaGalleryEntry.fromJson(x))),
    tierPrices: json["tier_prices"] == null ? null : List<dynamic>.from(json["tier_prices"].map((x) => x)),
    customAttributes: json["custom_attributes"] == null ? null : List<CustomAttribute>.from(json["custom_attributes"].map((x) => CustomAttribute.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "sku": sku == null ? null : sku,
    "name": name == null ? null : name,
    "attribute_set_id": attributeSetId == null ? null : attributeSetId,
    "price": price == null ? null : price,
    "status": status == null ? null : status,
    "visibility": visibility == null ? null : visibility,
    "type_id": typeId == null ? null : typeId,
    "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
    "extension_attributes": extensionAttributes == null ? null : extensionAttributes!.toJson(),
    "product_links": productLinks == null ? null : List<dynamic>.from(productLinks!.map((x) => x)),
    "options": options == null ? null : List<dynamic>.from(options!.map((x) => x)),
    "media_gallery_entries": mediaGalleryEntries == null ? null : List<dynamic>.from(mediaGalleryEntries!.map((x) => x.toJson())),
    "tier_prices": tierPrices == null ? null : List<dynamic>.from(tierPrices!.map((x) => x)),
    "custom_attributes": customAttributes == null ? null : List<dynamic>.from(customAttributes!.map((x) => x.toJson())),
  };
}

class CustomAttribute {
  CustomAttribute({
    this.attributeCode,
    this.value,
  });

  String? attributeCode;
  dynamic value;

  factory CustomAttribute.fromJson(Map<String, dynamic> json) => CustomAttribute(
    attributeCode: json["attribute_code"] == null ? null : json["attribute_code"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "attribute_code": attributeCode == null ? null : attributeCode,
    "value": value,
  };
}

class ExtensionAttributes {
  ExtensionAttributes({
    this.websiteIds,
    this.categoryLinks,
    this.stockItem,
    this.avgrating,
  });

  List<int>? websiteIds;
  List<CategoryLink>? categoryLinks;
  StockItem? stockItem;
  String? avgrating;

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) => ExtensionAttributes(
    websiteIds: json["website_ids"] == null ? null : List<int>.from(json["website_ids"].map((x) => x)),
    categoryLinks: json["category_links"] == null ? null : List<CategoryLink>.from(json["category_links"].map((x) => CategoryLink.fromJson(x))),
    stockItem: json["stock_item"] == null ? null : StockItem.fromJson(json["stock_item"]),
    avgrating: json["avgrating"] == null ? null : json["avgrating"],
  );

  Map<String, dynamic> toJson() => {
    "website_ids": websiteIds == null ? null : List<dynamic>.from(websiteIds!.map((x) => x)),
    "category_links": categoryLinks == null ? null : List<dynamic>.from(categoryLinks!.map((x) => x.toJson())),
    "stock_item": stockItem == null ? null : stockItem!.toJson(),
    "avgrating": avgrating == null ? null : avgrating,
  };
}

class CategoryLink {
  CategoryLink({
    this.position,
    this.categoryId,
  });

  int? position;
  String? categoryId;

  factory CategoryLink.fromJson(Map<String, dynamic> json) => CategoryLink(
    position: json["position"] == null ? null : json["position"],
    categoryId: json["category_id"] == null ? null : json["category_id"],
  );

  Map<String, dynamic> toJson() => {
    "position": position == null ? null : position,
    "category_id": categoryId == null ? null : categoryId,
  };
}

class StockItem {
  StockItem({
    this.itemId,
    this.productId,
    this.stockId,
    this.qty,
    this.isInStock,
    this.isQtyDecimal,
    this.showDefaultNotificationMessage,
    this.useConfigMinQty,
    this.minQty,
    this.useConfigMinSaleQty,
    this.minSaleQty,
    this.useConfigMaxSaleQty,
    this.maxSaleQty,
    this.useConfigBackorders,
    this.backorders,
    this.useConfigNotifyStockQty,
    this.notifyStockQty,
    this.useConfigQtyIncrements,
    this.qtyIncrements,
    this.useConfigEnableQtyInc,
    this.enableQtyIncrements,
    this.useConfigManageStock,
    this.manageStock,
    this.lowStockDate,
    this.isDecimalDivided,
    this.stockStatusChangedAuto,
  });

  int? itemId;
  int? productId;
  int? stockId;
  int? qty;
  bool? isInStock;
  bool? isQtyDecimal;
  bool? showDefaultNotificationMessage;
  bool? useConfigMinQty;
  int? minQty;
  int? useConfigMinSaleQty;
  int? minSaleQty;
  bool? useConfigMaxSaleQty;
  int? maxSaleQty;
  bool? useConfigBackorders;
  int? backorders;
  bool?  useConfigNotifyStockQty;
  int ? notifyStockQty;
  bool?  useConfigQtyIncrements;
  int ? qtyIncrements;
  bool?  useConfigEnableQtyInc;
  bool?  enableQtyIncrements;
  bool?  useConfigManageStock;
  bool?  manageStock;
  dynamic lowStockDate;
  bool? isDecimalDivided;
  int? stockStatusChangedAuto;

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
    itemId: json["item_id"] == null ? null : json["item_id"],
    productId: json["product_id"] == null ? null : json["product_id"],
    stockId: json["stock_id"] == null ? null : json["stock_id"],
    qty: json["qty"] == null ? null : json["qty"],
    isInStock: json["is_in_stock"] == null ? null : json["is_in_stock"],
    isQtyDecimal: json["is_qty_decimal"] == null ? null : json["is_qty_decimal"],
    showDefaultNotificationMessage: json["show_default_notification_message"] == null ? null : json["show_default_notification_message"],
    useConfigMinQty: json["use_config_min_qty"] == null ? null : json["use_config_min_qty"],
    minQty: json["min_qty"] == null ? null : json["min_qty"],
    useConfigMinSaleQty: json["use_config_min_sale_qty"] == null ? null : json["use_config_min_sale_qty"],
    minSaleQty: json["min_sale_qty"] == null ? null : json["min_sale_qty"],
    useConfigMaxSaleQty: json["use_config_max_sale_qty"] == null ? null : json["use_config_max_sale_qty"],
    maxSaleQty: json["max_sale_qty"] == null ? null : json["max_sale_qty"],
    useConfigBackorders: json["use_config_backorders"] == null ? null : json["use_config_backorders"],
    backorders: json["backorders"] == null ? null : json["backorders"],
    useConfigNotifyStockQty: json["use_config_notify_stock_qty"] == null ? null : json["use_config_notify_stock_qty"],
    notifyStockQty: json["notify_stock_qty"] == null ? null : json["notify_stock_qty"],
    useConfigQtyIncrements: json["use_config_qty_increments"] == null ? null : json["use_config_qty_increments"],
    qtyIncrements: json["qty_increments"] == null ? null : json["qty_increments"],
    useConfigEnableQtyInc: json["use_config_enable_qty_inc"] == null ? null : json["use_config_enable_qty_inc"],
    enableQtyIncrements: json["enable_qty_increments"] == null ? null : json["enable_qty_increments"],
    useConfigManageStock: json["use_config_manage_stock"] == null ? null : json["use_config_manage_stock"],
    manageStock: json["manage_stock"] == null ? null : json["manage_stock"],
    lowStockDate: json["low_stock_date"],
    isDecimalDivided: json["is_decimal_divided"] == null ? null : json["is_decimal_divided"],
    stockStatusChangedAuto: json["stock_status_changed_auto"] == null ? null : json["stock_status_changed_auto"],
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId == null ? null : itemId,
    "product_id": productId == null ? null : productId,
    "stock_id": stockId == null ? null : stockId,
    "qty": qty == null ? null : qty,
    "is_in_stock": isInStock == null ? null : isInStock,
    "is_qty_decimal": isQtyDecimal == null ? null : isQtyDecimal,
    "show_default_notification_message": showDefaultNotificationMessage == null ? null : showDefaultNotificationMessage,
    "use_config_min_qty": useConfigMinQty == null ? null : useConfigMinQty,
    "min_qty": minQty == null ? null : minQty,
    "use_config_min_sale_qty": useConfigMinSaleQty == null ? null : useConfigMinSaleQty,
    "min_sale_qty": minSaleQty == null ? null : minSaleQty,
    "use_config_max_sale_qty": useConfigMaxSaleQty == null ? null : useConfigMaxSaleQty,
    "max_sale_qty": maxSaleQty == null ? null : maxSaleQty,
    "use_config_backorders": useConfigBackorders == null ? null : useConfigBackorders,
    "backorders": backorders == null ? null : backorders,
    "use_config_notify_stock_qty": useConfigNotifyStockQty == null ? null : useConfigNotifyStockQty,
    "notify_stock_qty": notifyStockQty == null ? null : notifyStockQty,
    "use_config_qty_increments": useConfigQtyIncrements == null ? null : useConfigQtyIncrements,
    "qty_increments": qtyIncrements == null ? null : qtyIncrements,
    "use_config_enable_qty_inc": useConfigEnableQtyInc == null ? null : useConfigEnableQtyInc,
    "enable_qty_increments": enableQtyIncrements == null ? null : enableQtyIncrements,
    "use_config_manage_stock": useConfigManageStock == null ? null : useConfigManageStock,
    "manage_stock": manageStock == null ? null : manageStock,
    "low_stock_date": lowStockDate,
    "is_decimal_divided": isDecimalDivided == null ? null : isDecimalDivided,
    "stock_status_changed_auto": stockStatusChangedAuto == null ? null : stockStatusChangedAuto,
  };
}

class MediaGalleryEntry {
  MediaGalleryEntry({
    this.id,
    this.mediaType,
    this.label,
    this.position,
    this.disabled,
    this.types,
    this.file,
  });

  int? id;
  String? mediaType;
  dynamic label;
  int? position;
  bool? disabled;
  List<String>? types;
  String? file;

  factory MediaGalleryEntry.fromJson(Map<String, dynamic> json) => MediaGalleryEntry(
    id: json["id"] == null ? null : json["id"],
    mediaType: json["media_type"] == null ? null : json["media_type"],
    label: json["label"],
    position: json["position"] == null ? null : json["position"],
    disabled: json["disabled"] == null ? null : json["disabled"],
    types: json["types"] == null ? null : List<String>.from(json["types"].map((x) => x)),
    file: json["file"] == null ? null : json["file"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "media_type": mediaType == null ? null : mediaType,
    "label": label,
    "position": position == null ? null : position,
    "disabled": disabled == null ? null : disabled,
    "types": types == null ? null : List<dynamic>.from(types!.map((x) => x)),
    "file": file == null ? null : file,
  };
}
