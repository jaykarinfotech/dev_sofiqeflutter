class Ms8Model {
  String? lookImage;
  String? lookDescription;
  String? customerWarningFlag;
  String? customerCurrency;
  var faceSubareas;
  double? lookPrice;
  double? lookDiscountedPrice;
  int? status;
  String? message;

  Ms8Model(
      {this.lookImage,
      this.lookDescription,
      this.customerWarningFlag,
      this.customerCurrency,
      this.faceSubareas,
      this.lookPrice,
      this.lookDiscountedPrice,
      this.status,
      this.message});

  Ms8Model.fromJson(Map<String, dynamic> json) {
    lookImage = json['look_image'];
    lookDescription = json['look_description'];
    customerWarningFlag = json['customer_warning_flag'];
    customerCurrency = json['customer_currency'];
    faceSubareas = json['face_subareas'] != null ? json['face_subareas'] : null;
    lookPrice = json['look_price'];
    lookDiscountedPrice = json['look_discounted_price'];
    status = json['status'];
    message = json['message'];
  }
}
