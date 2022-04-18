class ReviewModel {
  List<Items>? items;
  SearchCriteria? searchCriteria;
  int? totalCount;

  ReviewModel({this.items, this.searchCriteria, this.totalCount});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    searchCriteria = json['search_criteria'] != null
        ? new SearchCriteria.fromJson(json['search_criteria'])
        : null;
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.searchCriteria != null) {
      data['search_criteria'] = this.searchCriteria!.toJson();
    }
    data['total_count'] = this.totalCount;
    return data;
  }
}

class Items {
  int? id;
  String? title;
  String? sku;
  String? detail;
  String? nickname;
  int? customerId;
  List<Ratings>? ratings;
  String? reviewEntity;
  int? reviewType;
  int? reviewStatus;
  String? createdAt;
  int? entityPkValue;
  int? storeId;
  List<int>? stores;
  String? image;

  Items(
      {this.id,
      this.title,
      this.sku,
      this.detail,
      this.nickname,
      this.customerId,
      this.ratings,
      this.reviewEntity,
      this.reviewType,
      this.reviewStatus,
      this.createdAt,
      this.entityPkValue,
      this.storeId,
      this.stores,
      this.image,
      });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    sku = json['sku'];
    detail = json['detail'];
    nickname = json['nickname'];
    customerId = json['customer_id'];
    if (json['ratings'] != null) {
      ratings = <Ratings>[];
      json['ratings'].forEach((v) {
        ratings!.add(new Ratings.fromJson(v));
      });
    }
    reviewEntity = json['review_entity'];
    reviewType = json['review_type'];
    reviewStatus = json['review_status'];
    createdAt = json['created_at'];
    entityPkValue = json['entity_pk_value'];
    storeId = json['store_id'];
    stores = json['stores'].cast<int>();
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sku'] = this.sku;
    data['detail'] = this.detail;
    data['nickname'] = this.nickname;
    data['customer_id'] = this.customerId;
    if (this.ratings != null) {
      data['ratings'] = this.ratings!.map((v) => v.toJson()).toList();
    }
    data['review_entity'] = this.reviewEntity;
    data['review_type'] = this.reviewType;
    data['review_status'] = this.reviewStatus;
    data['created_at'] = this.createdAt;
    data['entity_pk_value'] = this.entityPkValue;
    data['store_id'] = this.storeId;
    data['stores'] = this.stores;
    return data;
  }
}

class Ratings {
  int? voteId;
  int? ratingId;
  String? ratingName;
  int? percent;
  int? value;

  Ratings(
      {this.voteId, this.ratingId, this.ratingName, this.percent, this.value});

  Ratings.fromJson(Map<String, dynamic> json) {
    voteId = json['vote_id'];
    ratingId = json['rating_id'];
    ratingName = json['rating_name'];
    percent = json['percent'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vote_id'] = this.voteId;
    data['rating_id'] = this.ratingId;
    data['rating_name'] = this.ratingName;
    data['percent'] = this.percent;
    data['value'] = this.value;
    return data;
  }
}

class SearchCriteria {
 var filterGroups;

  SearchCriteria({this.filterGroups});

  SearchCriteria.fromJson(Map<String, dynamic> json) {
    if (json['filter_groups'] != null) {
    
      filterGroups = json['filter_groups'];
      // json['filter_groups'].forEach((v) {
      //   filterGroups.add(new Null.fromJson(v));
      // });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filterGroups != null) {
      data['filter_groups'] = this.filterGroups.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
