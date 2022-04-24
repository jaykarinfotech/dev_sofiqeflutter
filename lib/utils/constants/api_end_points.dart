class APIEndPoints {
  static String get baseUri => 'https://dev.sofiqe.com/rest/V1';
  static String get mybaseUri => 'https://dev.sofiqe.com/index.php/rest/V1';

  static String get shareBaseUrl => 'https://dev.sofiqe.com/';

  static String nonRecommendedColourProducts(String id) {
    return '$baseUri/products?searchCriteria[filterGroups][0][filters][0][field]=entity_id&searchCriteria[filterGroups][0][filters][0][value]=$id&searchCriteria[filterGroups][0][filters][0][condition_type]=eq';
  }

  static String get faceAreasAndParameters {
    return '$baseUri/custom/getFaceSubArea';
  }

  static String get faceAreaCategory {
    return '$baseUri/categories';
  }

  static String get brandNames {
    return '$baseUri/custom/brandFilterTags';
  }

  static String get subscribe {
    return '$baseUri/custom/premiumSubscribe';
  }

  static String get scanProduct {
    return '$baseUri/custom/scanProduct';
  }

  static String get getDealOfTheDay {
    return '$baseUri/custom/getVendorDeals';
  }

  static String get getVendorDealsById {
    return '$baseUri/custom/getVendorDealsById';
  }

  static String get getBestSellersList {
    return '$mybaseUri/custom/bestseller';
  }

  static String productRecommendedProductsFilteredByApplicationArea(
      String color, String faceArea, String faceSubArea) {
    return '$baseUri/products?searchCriteria[filterGroups][0][filters][0][field]=face_color&searchCriteria[filterGroups][0][filters][0][condition_type]=eq&searchCriteria[filterGroups][0][filters][0][value]=$color&searchCriteria[filterGroups][1][filters][0][field]=face_area&searchCriteria[filterGroups][1][filters][0][condition_type]=eq&searchCriteria[filterGroups][1][filters][0][value]=$faceArea&searchCriteria[filterGroups][1][filters][0][field]=face_sub_area&searchCriteria[filterGroups][1][filters][0][condition_type]=eq&searchCriteria[filterGroups][1][filters][0][value]=$faceSubArea';
  }

  static String get getNonRecommendedColors {
    return '$baseUri/custom/getAllColours';
  }

  static String get getRecommendedColors {
    return '$baseUri/custom/searchCentralColor';
  }

  static String get getFreeShippingInfo {
    return '$baseUri/custom/getfreeshippingamount';
  }


  static String get saveProfilePicture {
    return '$baseUri/custom/updateProfileImage';
  }

  static String get countryDetails {
    return '$baseUri/directory/countries';
  }

  static String get questionnaireResponse {
    return '$baseUri/custom/getSaveProfileQuestion';
  }

  static String get productStatic {
    return '$baseUri/custom/getProductStatic/';
  }

  static String get catalogUnfiltereditems {
    return '$baseUri/products?searchCriteria[pageSize]=12&searchCriteria[currentPage]=';
  }

  static String unfilteredFaceAreaItems(int page, int faceArea) {
    return '$baseUri/products?searchCriteria[pageSize]=12&searchCriteria[currentPage]=$page&searchCriteria[filterGroups][1][filters][0][condition_type]=eq&searchCriteria[filterGroups][1][filters][0][value]=$faceArea&searchCriteria[filterGroups][1][filters][0][field]=category_id';
  }

  static String get catalogPopularItems {
    return '$baseUri/custom/getPopularProducts';
  }

  static String get brandFilteredItems {
    return '$baseUri/custom/filterByBrand';
  }

  static String get centralColorProducts {
    return '$baseUri/custom/searchAlternateColor';
  }

  static String productItems(int page, int faceSubArea) {
    return '$baseUri/products?searchCriteria[pageSize]=12&searchCriteria[currentPage]=$page&searchCriteria[filterGroups][1][filters][0][condition_type]=eq&searchCriteria[filterGroups][1][filters][0][value]=$faceSubArea&searchCriteria[filterGroups][1][filters][0][field]=category_id';
  }

  static String get catalogBetweenPriceItems {
    return '$baseUri/custom/filterByPriceRange';
  }

  static String searchedItems(String query) {
    return '$baseUri/custom/products?searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=%$query%&searchCriteria[filter_groups][0][filters][0][condition_type]=like';
  }

  static String get getWishlist {
    return '$baseUri/wishlist/items/';
  }

  static String get getUser {
    return '$baseUri/customers/me';
  }

  static String get resetPassword {
    return '$baseUri/customers/password';
  }

  static String get signup {
    return '$baseUri/customers';
  }

  static String get emailAvailability {
    return '$baseUri/customers/isEmailAvailable';
  }

  static String get login {
    return '$baseUri/integration/customer/token';
  }

  static String get productBySKU {
    return '$baseUri/products/';
  }

  //for ingredients
  static String get getIngredients {
    return 'https://dev.sofiqe.com/rest/V1/ingredients';
  }

  static String get shippingAddressByCustomerId {
    return '$baseUri/customers/me/shippingAddress';
  }

  static String get guestCartNewInstance {
    return '$baseUri/guest-carts';
  }

  static String get guestCartDetails {
    return '$baseUri/guest-carts/';
  }

  static String guestCartList(String cartToken) {
    return '$baseUri/guest-carts/$cartToken/items';
  }

  static String get userCartDetails {
    return '$baseUri/carts/mine/';
  }

  static String get userCartList {
    return '$baseUri/carts/mine/items';
  }

  static String get questionnaireList {
    return '$baseUri/questionnaire/questions';
  }

  static String get mediaBaseUrl {
    return 'http://dev.sofiqe.com/media/catalog/product';
  }

  static String get addItemToWishList {
    return '$baseUri/wishlist/add/';
  }

  static String get removeItemToWishList {
    return '$baseUri/wishlist/remove/';
  }

  static String get shareWishList {
    return '$baseUri/wishlist/share';
  }

  static String get createReview {
    return '$baseUri/reviews';
  }

  static String addToCartGuest({required String cartId}) {
    return '$baseUri/guest-carts/$cartId/items';
  }

  static String addToCartCustomer({required String cartId}) {
    return '$baseUri/carts/mine/items';
  }

  static String addShippingAddress(String cartId) =>
      "$baseUri/guest-carts/$cartId/shipping-information";

  static String removeFromCart(
          {required String cartId, required String itemId}) =>
      "$baseUri/guest-carts/$cartId/items/$itemId";

  static String placeOrder(String cartId) =>
      "$baseUri/guest-carts/$cartId/order";

  static Map<String, String> headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      
    };
  }
}
