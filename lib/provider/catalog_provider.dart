import 'package:get/get.dart';
import 'package:sofiqe/model/data_ready_status_enum.dart';
import 'package:sofiqe/model/product_model.dart';
import 'package:sofiqe/utils/api/catalog_filters.dart';
import 'package:sofiqe/utils/api/product_list_api.dart';
import 'package:sofiqe/utils/states/user_account_data.dart';
import '../model/CategoryResponse.dart';

class CatalogProvider extends GetxController {
  RxBool showSearchBar = false.obs;

  RxList<Product> catalogItemsList = <Product>[].obs;
  RxInt catalogItemsCurrentPage = 0.obs;

  Rx<FilterType> filterType = FilterType.NONE.obs;
  Rx<FilterType> filterTypePressed = FilterType.NONE.obs;
  Rx<FaceArea> faceArea = FaceArea.ALL.obs;

  Rx<DataReadyStatus> catalogItemsStatus = DataReadyStatus.FETCHING.obs;

  Rx<PriceFilter> priceFilter = PriceFilter().obs;

  Rx<BrandFilter> allBrandFilter = BrandFilter().obs;
  Rx<BrandFilter> eyesBrandFilter = BrandFilter().obs;
  Rx<BrandFilter> lipsBrandFilter = BrandFilter().obs;
  Rx<BrandFilter> cheeksBrandFilter = BrandFilter().obs;

  Rx<ProductFilter> allProductFilter = ProductFilter().obs;
  Rx<ChildrenData> categoryFilter = ChildrenData().obs;
  Rx<ProductFilter> eyesProductFilter = ProductFilter().obs;
  Rx<ProductFilter> lipsProductFilter = ProductFilter().obs;
  Rx<ProductFilter> cheeksProductFilter = ProductFilter().obs;

  Rx<SkinToneFilter> eyesSkinToneFilter = SkinToneFilter().obs;
  Rx<SkinToneFilter> lipsSkinToneFilter = SkinToneFilter().obs;
  Rx<SkinToneFilter> cheeksSkinToneFilter = SkinToneFilter().obs;

  Rx<String> inputText = ''.obs;

  var selectedStar = 10.obs;
  var starValueChanges = false.obs;

  var availableStar = ["4+ Star", "3+ Star", "2+ Star"];

  Map<FaceArea, int> faceAreaToIdMapping = {
    FaceArea.EYES: 279,
    FaceArea.LIPS: 280,
    FaceArea.CHEEKS: 278,
    FaceArea.ALL: -1,
  };

  // Constructor
  CatalogProvider() {
    _initializedData();
  }

  _initializedData() async {
    this.defaults();
    await this
        .fetchBrandNames(faceAreaToStringMapping[FaceArea.LIPS] as String);
    await this
        .fetchBrandNames(faceAreaToStringMapping[FaceArea.CHEEKS] as String);
    await this
        .fetchBrandNames(faceAreaToStringMapping[FaceArea.EYES] as String);
    await this.fetchUnfilteredItems(false);
    await this.fetchCategory();
  }

  Future<void> fetchCategory() async {
    try {
      CategoryResponse responseList = await sfAPIFetchFaceCategory();
      if (responseList.childrenData != null &&
          responseList.childrenData!.isNotEmpty &&
          responseList.childrenData!.firstWhere(
                  (element) =>
                      element.name != null &&
                      element.name!.toLowerCase() == "shop", orElse: () {
                return ChildrenData();
              }).name ==
              null) {
        throw 'Proper key not found in response';
      }
      List<ChildrenData> faceSubAreaAndParameter = responseList.childrenData!
          .firstWhere(
              (element) =>
                  element.name != null &&
                  element.name!.toLowerCase() == "shop" &&
                  element.childrenData != null,
              orElse: () => ChildrenData())
          .childrenData!;
      categoryFilter.value = responseList.childrenData!.firstWhere(
          (element) =>
              element.name != null &&
              element.name!.toLowerCase() == "shop" &&
              element.childrenData != null,
          orElse: () => ChildrenData());
      faceSubAreaAndParameter.forEach((element) {
        if (element.name != null &&
            element.name!.toLowerCase() == "complexion") {
          allProductFilter.value.subAreas.addAll(element.childrenData!);
          cheeksProductFilter.value.subAreas.addAll(element.childrenData!);
        } else if (element.name != null &&
            element.name!.toLowerCase() == "eyes") {
          allProductFilter.value.subAreas.addAll(element.childrenData!);
          eyesProductFilter.value.subAreas.addAll(element.childrenData!);
        } else if (element.name != null &&
            element.name!.toLowerCase() == "lips") {
          allProductFilter.value.subAreas.addAll(element.childrenData!);
          lipsProductFilter.value.subAreas.addAll(element.childrenData!);
        }
      });
    } catch (err) {
      print('Could not get face areas and parameters: $err');
    }
  }

  // Methods

  void unhideSeachBar() {
    this.showSearchBar.value = true;
  }

  void hideSearchBar() {
    this.showSearchBar.value = false;
  }

  void setFaceArea(FaceArea fa) {
    faceArea.value = fa;
    filterTypePressed.value = FilterType.NONE;
    catalogItemsCurrentPage.value = 0;
    selectedStar.value = 10;
    starValueChanges.value = false;
    setFilter(FilterType.NONE, newFilter: true);
  }

  void setFilter(FilterType ft, {bool newFilter = false}) async {
    if (!newFilter) {
      if (filterTypePressed.value != ft) {
        filterTypePressed.value = ft;
      } else {
        filterTypePressed.value = FilterType.NONE;
      }
    }
    if ((ft == filterType.value) && !newFilter) {
      return;
    }
    if (ft != filterType.value) {
      filterType.value = ft;
    }
    switch (ft) {
      case FilterType.SKINTONE:
        SkinToneFilter stf = SkinToneFilter();
        if (faceArea.value == FaceArea.EYES) {
          stf = eyesSkinToneFilter.value;
        } else if (faceArea.value == FaceArea.CHEEKS) {
          stf = cheeksSkinToneFilter.value;
        } else if (faceArea.value == FaceArea.LIPS) {
          stf = lipsSkinToneFilter.value;
        }
        if (stf.changed) {
          catalogItemsList.removeWhere((element) => true);
          catalogItemsCurrentPage.value = 0;
          stf.readFilter();
          catalogItemsStatus.value = DataReadyStatus.FETCHING;
          await fetchCentralColorProducts(stf);
        }
        break;
      case FilterType.PRODUCT:
        ProductFilter pf = ProductFilter();
        if (faceArea.value == FaceArea.ALL) {
          pf = allProductFilter.value;
        } else if (faceArea.value == FaceArea.EYES) {
          pf = eyesProductFilter.value;
        } else if (faceArea.value == FaceArea.CHEEKS) {
          pf = cheeksProductFilter.value;
        } else if (faceArea.value == FaceArea.LIPS) {
          pf = lipsProductFilter.value;
        }
        if (pf.changed) {
          catalogItemsList.removeWhere((element) => true);
          catalogItemsCurrentPage.value = 0;
          pf.readFilter();
          catalogItemsStatus.value = DataReadyStatus.FETCHING;
          await fetchProductItems(pf);
        }
        break;
      case FilterType.PRICE:
        if (priceFilter.value.changed) {
          catalogItemsList.removeWhere((element) => true);
          catalogItemsCurrentPage.value = 0;
          this.priceFilter.value.readFilter();
          catalogItemsStatus.value = DataReadyStatus.FETCHING;
          await fetchBetweenPriceItems();
        }
        break;
      case FilterType.BRAND:
        BrandFilter pf = BrandFilter();
        if (faceArea.value == FaceArea.ALL) {
          pf = allBrandFilter.value;
        } else if (faceArea.value == FaceArea.EYES) {
          pf = eyesBrandFilter.value;
        } else if (faceArea.value == FaceArea.CHEEKS) {
          pf = cheeksBrandFilter.value;
        } else if (faceArea.value == FaceArea.LIPS) {
          pf = lipsBrandFilter.value;
        }
        if (pf.changed) {
          catalogItemsList.removeWhere((element) => true);
          catalogItemsCurrentPage.value = 0;
          pf.readFilter();
          catalogItemsStatus.value = DataReadyStatus.FETCHING;
          await fetchBrandItems(pf);
        }
        break;
      case FilterType.REVIEW:
        if (starValueChanges.value) {
          catalogItemsList.removeWhere((element) => true);
          catalogItemsCurrentPage.value = 0;
          catalogItemsStatus.value = DataReadyStatus.FETCHING;
          if (faceArea.value == FaceArea.ALL) {
            await fetchUnfilteredItems(true);
          } else {
            await fetchUnfilteredFaceArea(
                faceAreaToIdMapping[faceArea.value] as int, true);
          }
        }
        break;
      case FilterType.POPULAR:
        catalogItemsList.removeWhere((element) => true);
        catalogItemsCurrentPage.value = 0;
        catalogItemsStatus.value = DataReadyStatus.FETCHING;
        await fetchPopularItems();
        break;
      case FilterType.NONE:
        catalogItemsList.removeWhere((element) => true);
        catalogItemsStatus.value = DataReadyStatus.FETCHING;
        if (faceArea.value == FaceArea.ALL) {
          await fetchUnfilteredItems(false);
        } else {
          await fetchUnfilteredFaceArea(
              faceAreaToIdMapping[faceArea.value] as int, false);
        }
        break;
    }
  }

  Future<bool> fetchMoreItems() async {
    bool success = false;

    switch (filterType.value) {
      case FilterType.SKINTONE:
        // SkinToneFilter stf = SkinToneFilter();
        // if (faceArea.value == FaceArea.EYES) {
        //   stf = eyesSkinToneFilter.value;
        // } else if (faceArea.value == FaceArea.CHEEKS) {
        //   stf = cheeksSkinToneFilter.value;
        // } else if (faceArea.value == FaceArea.LIPS) {
        //   stf = lipsSkinToneFilter.value;
        // }
        // success = await fetchCentralColorProducts(stf);
        ///
        ///
        /// All products are fetched in continious succession so no need to call this API again
        ///
        ///
        success = true;
        break;
      case FilterType.PRODUCT:
        ProductFilter pf = ProductFilter();
        if (faceArea.value == FaceArea.ALL) {
          pf = allProductFilter.value;
        } else if (faceArea.value == FaceArea.EYES) {
          pf = eyesProductFilter.value;
        } else if (faceArea.value == FaceArea.CHEEKS) {
          pf = cheeksProductFilter.value;
        } else if (faceArea.value == FaceArea.LIPS) {
          pf = lipsProductFilter.value;
        }
        success = await fetchProductItems(pf);
        break;
      case FilterType.PRICE:
        success = await fetchBetweenPriceItems();
        break;
      case FilterType.BRAND:
        BrandFilter pf = BrandFilter();
        if (faceArea.value == FaceArea.ALL) {
          pf = allBrandFilter.value;
        } else if (faceArea.value == FaceArea.EYES) {
          pf = eyesBrandFilter.value;
        } else if (faceArea.value == FaceArea.CHEEKS) {
          pf = cheeksBrandFilter.value;
        } else if (faceArea.value == FaceArea.LIPS) {
          pf = lipsBrandFilter.value;
        }
        success = await fetchBrandItems(pf);
        break;
      case FilterType.REVIEW:
        switch (faceArea.value) {
          case FaceArea.ALL:
            success = await fetchUnfilteredItems(true);
            break;
          case FaceArea.EYES:
          case FaceArea.LIPS:
          case FaceArea.CHEEKS:
            success = await fetchUnfilteredFaceArea(
                faceAreaToIdMapping[faceArea.value] as int, true);
            break;
        }
        break;
      case FilterType.POPULAR:
        success = await fetchPopularItems();
        break;
      case FilterType.NONE:
        switch (faceArea.value) {
          case FaceArea.ALL:
            success = await fetchUnfilteredItems(false);
            break;
          case FaceArea.EYES:
          case FaceArea.LIPS:
          case FaceArea.CHEEKS:
            success = await fetchUnfilteredFaceArea(
                faceAreaToIdMapping[faceArea.value] as int, false);
            break;
        }
        break;
    }
    return success;
  }

  void applyFilter() {
    filterTypePressed.value = FilterType.NONE;
    setFilter(this.filterType.value, newFilter: true);
  }

  void search() {
    this.filterType.value = FilterType.NONE;
    this.filterTypePressed.value = FilterType.NONE;
    selectedStar.value = 10;
    starValueChanges.value = false;
    this.hideSearchBar();
    this.fetchSearchedItems();
  }

  // API calls
  Future<bool> fetchUnfilteredFaceArea(int faceArea, bool isForReview) async {
    try {
      catalogItemsCurrentPage.value++;

      Map result = await sfAPIGetUnfilteredFaceAreaItems(
          catalogItemsCurrentPage.value, faceArea);
      if (!result.containsKey('items')) {
        throw 'Key not found: items';
      }
      List itemsList = result['items'];
      List<Product> tempProductList = <Product>[];

      itemsList.forEach(
        (item) {
          tempProductList.add(Product.fromDefaultMap(item));
        },
      );

      catalogItemsList.addAll(tempProductList);
      if (isForReview) {
        if (selectedStar.value == 10) {
          catalogItemsList.sort((a, b) =>
              double.parse(a.avgRating).compareTo(double.parse(b.avgRating)));
        } else if (selectedStar.value == 0) {
          var temp = catalogItemsList;
          temp.removeWhere((element) => element.avgRating.startsWith("3"));
          temp.removeWhere((element) => element.avgRating.startsWith("2"));
          temp.removeWhere((element) => element.avgRating.startsWith("1"));
          temp.removeWhere((element) => element.avgRating.startsWith("0"));
          catalogItemsList.removeWhere((element) => true);
          catalogItemsList.addAll(temp);
        } else if (selectedStar.value == 1) {
          var temp = catalogItemsList;
          temp.removeWhere((element) => element.avgRating.startsWith("2"));
          temp.removeWhere((element) => element.avgRating.startsWith("1"));
          temp.removeWhere((element) => element.avgRating.startsWith("0"));
          catalogItemsList.removeWhere((element) => true);
          catalogItemsList.addAll(temp);
        } else {
          var temp = catalogItemsList;
          temp.removeWhere((element) => element.avgRating.startsWith("1"));
          temp.removeWhere((element) => element.avgRating.startsWith("0"));
          catalogItemsList.removeWhere((element) => true);
          catalogItemsList.addAll(temp);
        }
      }

      catalogItemsStatus.value = DataReadyStatus.COMPLETED;
      return true;
    } catch (err) {
      catalogItemsCurrentPage.value--;
      catalogItemsStatus.value = DataReadyStatus.ERROR;
      print(err);
      try {
        Get.showSnackbar(
          GetSnackBar(
            message: 'Could not load more products',
            duration: Duration(seconds: 2),
          ),
        );
      } catch (ee) {}
      return false;
    }
  }

  Future<bool> fetchFaceAreasAndParameters(int faceArea) async {
    try {
      List responseList = await sfAPIFetchFaceAreasAndParameters(faceArea);
      Map responseMap = responseList[0];
      if (!responseMap.containsKey('face_sub_area')) {
        throw 'Proper key not found in response';
      }
      List faceSubAreaAndParameter = responseMap['face_sub_area'];

      if (faceArea == faceAreaToIdMapping[FaceArea.CHEEKS]) {
        cheeksSkinToneFilter.value.storeSubAreaOptions(faceSubAreaAndParameter);
      } else if (faceArea == faceAreaToIdMapping[FaceArea.LIPS]) {
        lipsSkinToneFilter.value.storeSubAreaOptions(faceSubAreaAndParameter);
      } else if (faceArea == faceAreaToIdMapping[FaceArea.EYES]) {
        eyesSkinToneFilter.value.storeSubAreaOptions(faceSubAreaAndParameter);
      }
      return true;
    } catch (err) {
      print('Could not get face areas and parameters: $err');
      return false;
    }
  }

  Future<bool> fetchCentralColorProducts(SkinToneFilter stf) async {
    try {
      this.catalogItemsCurrentPage.value++;

      /// Find the user token
      String token = await getUserToken();

      /// Extract selected face sub are
      String faceSubArea = stf.selectedFaceSubArea;

      /// Extract the options
      List<SkinToneFilterParameters> stfp =
          stf.options[faceSubArea] as List<SkinToneFilterParameters>;

      /// Extract all recommended colors
      List colors = [];
      stfp.forEach(
        (parameter) {
          if (parameter.selected.isNotEmpty) {
            colors.addAll(parameter.parameterOptions[parameter.selected]);
          }
        },
      );

      /// Fetch products for each recommended colors
      /// Add product to catalogListItems List
      /// Use a normal for loop to make sure all APIs complete before ending the function call
      for (int i = 0; i < colors.length; i++) {
        List result = await sfAPIFetchCentralColorProducts(
          token,
          colors[i][1],
          faceSubArea,
          'neutral',
          faceAreaToStandardId[faceSubArea.toLowerCase()] as int,
        );
        Map resultMap = result[0];

        if (!resultMap.containsKey('product')) {
          throw 'Key not found: product';
        }
        if (resultMap['product'].runtimeType == (<dynamic>[].runtimeType)) {
          continue;
        }
        Map tempProductMap = resultMap['product'];
        List<Product> tempProductList = <Product>[];
        tempProductMap.forEach(
          (key, p) {
            tempProductList.add(Product.fromMap(p));
          },
        );
        this.catalogItemsList.addAll(tempProductList);
        this.catalogItemsStatus.value = DataReadyStatus.COMPLETED;
      }

      this.catalogItemsStatus.value = DataReadyStatus.COMPLETED;
      return true;
    } catch (err) {
      this.catalogItemsStatus.value = DataReadyStatus.ERROR;
      this.catalogItemsCurrentPage.value--;
      print('Error fetching parameterizedFaceSubAreaProducts: $err');
      try {
        Get.showSnackbar(
          GetSnackBar(
            message: 'Could not load more products',
            duration: Duration(seconds: 2),
          ),
        );
      } catch (ee) {}
      return false;
    }
  }

  Future<bool> fetchBrandNames(String faceArea) async {
    print("Fetch Brand Names  --fetchBrandNames");
    try {
      List result = await sfAPIGetBrandNames(faceArea);
      Map resultMap = result[0];
      if (!resultMap.containsKey('brand') ||
          !resultMap.containsKey('face_sub_area')) {
        throw 'Key not found: brand OR face_sub_area';
      }
      List resultFaceSubArea = resultMap['face_sub_area'];
      Map resultBrand = resultMap['brand'];

      BrandFilter brandFilter = BrandFilter();

      resultFaceSubArea.forEach(
        (fsa) {
          brandFilter.subAreas.add(fsa);
        },
      );

      resultBrand.forEach(
        (index, b) {
          brandFilter.brands.add(b);
        },
      );

      if (faceArea == faceAreaToStringMapping[FaceArea.ALL]) {
        allBrandFilter.value = brandFilter;
      } else if (faceArea == faceAreaToStringMapping[FaceArea.EYES]) {
        eyesBrandFilter.value = brandFilter;
      } else if (faceArea == faceAreaToStringMapping[FaceArea.CHEEKS]) {
        cheeksBrandFilter.value = brandFilter;
      } else if (faceArea == faceAreaToStringMapping[FaceArea.LIPS]) {
        lipsBrandFilter.value = brandFilter;
      }

      return true;
    } catch (err) {
      print('Error fetching brand names: $err');
      // This method called again and again...changed on 13-04-2022 by Ashwani
      //fetchBrandNames(faceArea);
      return false;
    }
  }

  Future<bool> fetchBrandItems(BrandFilter bf) async {
    try {
      this.catalogItemsCurrentPage.value++;

      List result = await sfAPIFetchBrandFilteredItems(
          this.catalogItemsCurrentPage.value, bf.brand, bf.subArea);
      dynamic resultMap = result[0];
      if (!resultMap.containsKey('products')) {
        throw 'Key not found: products';
      }

      if (resultMap['products'] is List) {
        List<dynamic> tempProductsMap = resultMap['products'];
        List<Product> tempProductList = <Product>[];

        tempProductsMap.forEach(
          (p) {
            tempProductList.add(Product.fromMap(p));
          },
        );
        this.catalogItemsList.addAll(tempProductList);
      } else {
        Map tempProductsMap = resultMap['products'];
        List<Product> tempProductList = <Product>[];

        tempProductsMap.forEach(
          (k, p) {
            tempProductList.add(Product.fromMap(p));
          },
        );
        this.catalogItemsList.addAll(tempProductList);
      }

      this.catalogItemsStatus.value = DataReadyStatus.COMPLETED;
      return true;
    } catch (err) {
      this.catalogItemsCurrentPage.value--;
      this.catalogItemsStatus.value = DataReadyStatus.ERROR;
      print('Error fetching brand filtered items: $err');
      Get.showSnackbar(
        GetSnackBar(
          message: 'Could not fetch products',
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
  }

  Future<bool> fetchProductItems(ProductFilter pf) async {
    try {
      this.catalogItemsCurrentPage.value++;
      Map result = await sfAPIFetchProductItems(
          this.catalogItemsCurrentPage.value, pf.subArea.id!);
      if (!result.containsKey('items')) {
        throw 'Key not found: items';
      }
      List resultList = result['items'];
      List<Product> tempProductList = <Product>[];

      resultList.forEach(
        (p) {
          tempProductList.add(Product.fromDefaultMap(p));
        },
      );

      this.catalogItemsList.addAll(tempProductList);
      this.catalogItemsStatus.value = DataReadyStatus.COMPLETED;
      return true;
    } catch (err) {
      this.catalogItemsCurrentPage.value--;
      this.catalogItemsStatus.value = DataReadyStatus.ERROR;
      print('Error fetching product filtered items: $err');
      Get.showSnackbar(
        GetSnackBar(
          message: 'Could not fetch products for this filter',
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
  }

  Future<bool> fetchUnfilteredItems(bool sortReviewBased) async {
    try {
      catalogItemsCurrentPage.value++;
      Map catalogUnfilteredItemsMap =
          await sfAPIGetCatalogUnfilteredItems(catalogItemsCurrentPage.value);
      if (!catalogUnfilteredItemsMap.containsKey('items')) {
        throw 'Server failed to send catalog list';
      }
      List catalogUnfilteredItemsTempList = catalogUnfilteredItemsMap['items'];
      List<Product> catalogUnfilteredItemsTempListOfProducts =
          catalogUnfilteredItemsTempList.map<Product>(
        (m) {
          return Product.fromDefaultMap(m);
        },
      ).toList();
      catalogItemsList.addAll(catalogUnfilteredItemsTempListOfProducts);
      if (sortReviewBased) {
        if (selectedStar.value == 10) {
          catalogItemsList.sort((a, b) =>
              double.parse(a.avgRating).compareTo(double.parse(b.avgRating)));
        } else if (selectedStar.value == 0) {
          var temp = catalogItemsList;
          temp.removeWhere((element) => !element.avgRating.startsWith("5"));
          catalogItemsList.removeWhere((element) => true);
          catalogItemsList.addAll(temp);
        } else if (selectedStar.value == 1) {
          var temp = catalogItemsList;
          temp.removeWhere((element) => !element.avgRating.startsWith("4"));
          catalogItemsList.removeWhere((element) => true);
          catalogItemsList.addAll(temp);
        } else {
          var temp = catalogItemsList;
          temp.removeWhere((element) => !element.avgRating.startsWith("3"));
          catalogItemsList.removeWhere((element) => true);
          catalogItemsList.addAll(temp);
        }
      }
      catalogItemsStatus.value = DataReadyStatus.COMPLETED;
      return true;
    } catch (err) {
      catalogItemsCurrentPage.value--;
      catalogItemsStatus.value = DataReadyStatus.ERROR;
      print(err);
      try {
        Get.showSnackbar(
          GetSnackBar(
            message: 'Could not load more products',
            duration: Duration(seconds: 2),
          ),
        );
      } catch (ee) {
        return false;
      }
      return false;
    }
  }

  Future<bool> fetchPopularItems() async {
    try {
      catalogItemsCurrentPage.value++;

      if (faceArea.value == FaceArea.ALL) {
        Map<String, dynamic> bestSellerResponse = await sfAPIGetBestSellers();
        var responseList = bestSellerResponse["bestseller_product"];
        List<Product> tempProductList = <Product>[];
        responseList.forEach((p) {
          Product(
              id: int.parse(p['product_id']),
              name: p['name'],
              sku: p['sku'],
              price: double.parse(p['price']),
              image: p['image'],
              faceSubArea: -1,
              description: "",
              hasOption: true,
              avgRating: p['extension_attributes'] != null &&
                      p['extension_attributes']['avgrating'] != null
                  ? p['extension_attributes']['avgrating']
                  : "0.0");
        });

        this.catalogItemsList.addAll(tempProductList);
      } else {
        List responseList =
            await sfAPIGetCatalogPopularItems(catalogItemsCurrentPage.value);
        dynamic responseMap = responseList[0];
        if (!responseMap.containsKey('products')) {
          throw 'Products not found in response';
        }

        if (responseMap['products'] is List) {
          List<dynamic> tempProductsMap = responseMap['products'];
          List<Product> tempProductList = <Product>[];

          tempProductsMap.forEach(
            (value) {
              if (value['face_area'] == null ||
                  faceArea.value == FaceArea.ALL) {
                tempProductList.add(
                  Product(
                      id: int.parse(value['entity_id']),
                      sku: value['sku'],
                      image: value['image'] ??
                          value['small_image'] ??
                          value['thumbnail'] ??
                          "",
                      description:
                          value['short_description'] ?? value['description'],
                      faceSubArea: int.parse(value['face_sub_area']),
                      name: value['name'],
                      price: double.parse(value['price']),
                      options: [],
                      avgRating: value['extension_attributes'] != null &&
                              value['extension_attributes']['avgrating'] != null
                          ? value['extension_attributes']['avgrating']
                          : "0.0",
                      hasOption:
                          value['required_options'] == "1" ? true : false),
                );
              } else {
                var id = faceAreaToIdMapping[faceArea.value] as int;
                if (value['face_area'].toString() == id.toString()) {
                  tempProductList.add(
                    Product(
                        id: int.parse(value['entity_id']),
                        sku: value['sku'],
                        avgRating: value['extension_attributes'] != null &&
                                value['extension_attributes']['avgrating'] !=
                                    null
                            ? value['extension_attributes']['avgrating']
                            : "0.0",
                        image: value['image'] ??
                            value['small_image'] ??
                            value['thumbnail'] ??
                            "",
                        description:
                            value['short_description'] ?? value['description'],
                        faceSubArea: int.parse(value['face_sub_area']),
                        name: value['name'],
                        price: double.parse(value['price']),
                        options: [],
                        hasOption:
                            value['required_options'] == "1" ? true : false),
                  );
                }
              }
            },
          );
          this.catalogItemsList.addAll(tempProductList);
        } else {
          Map tempProductsMap = responseMap['products'];
          List<Product> tempProductList = <Product>[];

          tempProductsMap.forEach(
            (key, value) {
              if (value['face_area'] == null ||
                  faceArea.value == FaceArea.ALL) {
                tempProductList.add(
                  Product(
                      id: int.parse(value['entity_id']),
                      sku: value['sku'],
                      image: value['image'] ??
                          value['small_image'] ??
                          value['thumbnail'] ??
                          "",
                      description:
                          value['short_description'] ?? value['description'],
                      faceSubArea: int.parse(value['face_sub_area']),
                      name: value['name'],
                      price: double.parse(value['price']),
                      options: [],
                      avgRating: value['extension_attributes'] != null &&
                              value['extension_attributes']['avgrating'] != null
                          ? value['extension_attributes']['avgrating']
                          : "0.0",
                      hasOption:
                          value['required_options'] == "1" ? true : false),
                );
              } else {
                var id = faceAreaToIdMapping[faceArea.value] as int;
                if (value['face_area'].toString() == id.toString()) {
                  tempProductList.add(
                    Product(
                        id: int.parse(value['entity_id']),
                        sku: value['sku'],
                        image: value['image'] ??
                            value['small_image'] ??
                            value['thumbnail'] ??
                            "",
                        description:
                            value['short_description'] ?? value['description'],
                        faceSubArea: int.parse(value['face_sub_area']),
                        name: value['name'],
                        avgRating: value['extension_attributes'] != null &&
                                value['extension_attributes']['avgrating'] !=
                                    null
                            ? value['extension_attributes']['avgrating']
                            : "0.0",
                        price: double.parse(value['price']),
                        options: [],
                        hasOption:
                            value['required_options'] == "1" ? true : false),
                  );
                }
              }
            },
          );
          this.catalogItemsList.addAll(tempProductList);
        }
      }

      catalogItemsStatus.value = DataReadyStatus.COMPLETED;

      return true;
    } catch (err) {
      catalogItemsCurrentPage.value--;
      catalogItemsStatus.value = DataReadyStatus.ERROR;
      print(err);
      try {
        Get.showSnackbar(
          GetSnackBar(
            message: 'Could not load more products',
            duration: Duration(seconds: 2),
          ),
        );
      } catch (ee) {
        return false;
      }
      return false;
    }
  }

  Future<bool> fetchBetweenPriceItems() async {
    try {
      catalogItemsCurrentPage.value++;
      List response = await sfAPIGetCatalogBetweenPriceItems(
          catalogItemsCurrentPage.value,
          this.priceFilter.value.currentMinPrice,
          this.priceFilter.value.currentMaxPrice);
      Map responseMap = response[0];
      if (!responseMap.containsKey('products')) {
        throw 'Products not found in response';
      }
      Map productMap = responseMap['products'];

      //faceAreaToIdMapping[faceArea.value] as int
      List<Product> tempProductList = <Product>[];
      productMap.forEach(
        (key, value) {
          if (value['face_area'] == null || faceArea.value == FaceArea.ALL) {
            tempProductList.add(
              Product(
                  id: int.parse(value['entity_id']),
                  sku: value['sku'],
                  image: value['image'],
                  description: value['description'] ?? '',
                  faceSubArea: int.parse(value['face_sub_area']),
                  name: value['name'],
                  avgRating: value['extension_attributes'] != null &&
                          value['extension_attributes']['avgrating'] != null
                      ? value['extension_attributes']['avgrating']
                      : "0.0",
                  price: double.parse(value['price']),
                  options: [],
                  hasOption: value['required_options'] == "1" ? true : false),
            );
          } else {
            var id = faceAreaToIdMapping[faceArea.value] as int;
            if (value['face_area'].toString() == id.toString()) {
              tempProductList.add(
                Product(
                    id: int.parse(value['entity_id']),
                    sku: value['sku'],
                    image: value['image'],
                    avgRating: value['extension_attributes'] != null &&
                            value['extension_attributes']['avgrating'] != null
                        ? value['extension_attributes']['avgrating']
                        : "0.0",
                    description: value['description'] ?? '',
                    faceSubArea: int.parse(value['face_sub_area']),
                    name: value['name'],
                    price: double.parse(value['price']),
                    options: [],
                    hasOption: value['required_options'] == "1" ? true : false),
              );
            }
          }
        },
      );

      this.catalogItemsList.addAll(tempProductList);
      catalogItemsStatus.value = DataReadyStatus.COMPLETED;
      return true;
    } catch (err) {
      catalogItemsCurrentPage.value--;
      catalogItemsStatus.value = DataReadyStatus.ERROR;
      print('Could not load items between price range $err');
      try {
        Get.showSnackbar(
          GetSnackBar(
            message: 'Could not load more products',
            duration: Duration(seconds: 2),
          ),
        );
      } catch (ee) {}
      return false;
    }
  }

  Future<bool> fetchSearchedItems() async {
    try {
      this.catalogItemsStatus.value = DataReadyStatus.FETCHING;
      this.catalogItemsList.removeWhere((element) => true);
      Map response = await sfAPIGetSearchedItems(this.inputText.value);
      List responseList = response['items'] ?? [];
      if (responseList.isEmpty) {
        this.catalogItemsStatus.value = DataReadyStatus.COMPLETED;
        return false;
      }
      List<Product> tempProductList = <Product>[];
      responseList.forEach(
        (m) {
          tempProductList.add(
            Product.fromDefaultMap(m),
          );
        },
      );

      this.catalogItemsList.addAll(tempProductList);
      catalogItemsStatus.value = DataReadyStatus.COMPLETED;
      return true;
    } catch (err) {
      catalogItemsStatus.value = DataReadyStatus.ERROR;
      print('Could not find user searched items: $err');
      Get.showSnackbar(
        GetSnackBar(
          message: 'No results found!',
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
  }

  // Defaults
  void defaults() {
    showSearchBar = false.obs;
    catalogItemsList = <Product>[].obs;
    catalogItemsCurrentPage = 0.obs;
    catalogItemsStatus = DataReadyStatus.INACTIVE.obs;
    filterType = FilterType.NONE.obs;
    filterTypePressed = FilterType.NONE.obs;
    faceArea = FaceArea.ALL.obs;
  }

  void softDefaults() {
    showSearchBar = false.obs;
    catalogItemsCurrentPage = 0.obs;
    catalogItemsStatus = DataReadyStatus.INACTIVE.obs;
    filterType = FilterType.NONE.obs;
    filterTypePressed = FilterType.NONE.obs;
    faceArea = FaceArea.ALL.obs;
  }
}

Map<FaceArea, String> faceAreaToStringMapping = {
  FaceArea.EYES: 'Eyes',
  FaceArea.LIPS: 'Lips',
  FaceArea.CHEEKS: 'Cheeks',
  FaceArea.ALL: '',
};

Map<String, int> faceAreaToStandardId = {
  'foundation': 1,
  'bronzer': 2,
  'highligther': 3,
  'blusher': 4,
  'consealer': 12,
  'eyelid': 5,
  'eyesocket': 6,
  'orbital-bone': 7,
  'eyeliner': 8,
  'eyebrow': 9,
  'lipliner': 10,
  'lipstick': 11,
};

enum FilterType {
  SKINTONE,
  PRODUCT,
  PRICE,
  BRAND,
  REVIEW,
  POPULAR,
  NONE,
}

enum FaceArea {
  ALL,
  EYES,
  LIPS,
  CHEEKS,
}

class PriceFilter {
  int minPrice;
  int maxPrice;
  int _currentMinPrice = 10;
  int _currentMaxPrice = 200;
  bool changed = false;

  PriceFilter({
    this.minPrice = 0,
    this.maxPrice = 200,
  });

  void readFilter() {
    changed = false;
  }

  int get currentMinPrice {
    return _currentMinPrice;
  }

  int get currentMaxPrice {
    return _currentMaxPrice;
  }

  set currentMinPrice(int cmp) {
    _currentMinPrice = cmp;
    changed = true;
  }

  set currentMaxPrice(int cmp) {
    _currentMaxPrice = cmp;
    changed = true;
  }
}

class BrandFilter {
  List<String> brands = <String>[];
  List<String> subAreas = <String>[];

  bool changed = false;

  late String _brand = '';
  late String _subArea = '';

  BrandFilter();

  set brand(String b) {
    _brand = b;
    changed = true;
  }

  set subArea(String s) {
    _subArea = s;
    changed = true;
  }

  String get brand {
    return _brand;
  }

  String get subArea {
    return _subArea;
  }

  void readFilter() {
    changed = false;
  }
}

class ProductFilter {
  List<ChildrenData> subAreas = <ChildrenData>[];

  bool changed = false;

  ChildrenData _subArea = ChildrenData();

  ProductFilter();

  set subArea(ChildrenData sa) {
    _subArea = sa;
    changed = true;
  }

  ChildrenData get subArea {
    return _subArea;
  }

  void readFilter() {
    changed = false;
  }
}

class SkinToneFilter {
  List<String> faceSubAreas = <String>[];
  Map<String, List<SkinToneFilterParameters>> options =
      <String, List<SkinToneFilterParameters>>{};

  String _selectedFaceSubArea = '';

  bool changed = false;

  SkinToneFilter();

  String get selectedFaceSubArea {
    return _selectedFaceSubArea;
  }

  void toggleFaceSubArea(String fsa) {
    if (selectedFaceSubArea.contains(fsa)) {
      unselectFaceSubArea(fsa);
    } else {
      selectFaceSubArea(fsa);
    }
  }

  void selectFaceSubArea(String fsa) {
    _selectedFaceSubArea = fsa;
    changed = true;
  }

  void unselectFaceSubArea(String fsa) {
    _selectedFaceSubArea = '';
  }

  void readFilter() {
    changed = false;
  }

  void storeSubAreaOptions(List areaOptionsList) {
    areaOptionsList.forEach(
      (subArea) {
        String subAreaName = subArea['sub_area_name'];
        List parameters = subArea['parameters'];
        options[subAreaName] = [];
        List<String> uniqueParameterNames = <String>[];
        parameters.forEach(
          (p) {
            if (!uniqueParameterNames.contains(p['parameter_name'])) {
              uniqueParameterNames.add(p['parameter_name']);
            }
          },
        );

        uniqueParameterNames.forEach(
          (pN) {
            Map tempOptions = {};
            parameters.forEach(
              (p) {
                if (p['parameter_name'] == pN) {
                  tempOptions[p['value']] = p['parameter_options'];
                }
              },
            );

            options[subAreaName]!.add(SkinToneFilterParameters(
              parameterName: pN,
              parameterOptions: tempOptions,
            ));
          },
        );

        faceSubAreas.add(subAreaName);
      },
    );
  }
}

class SkinToneFilterParameters {
  String parameterName;
  Map parameterOptions = {};
  String selected = '';
  List selectedColors = [];

  SkinToneFilterParameters({
    required this.parameterName,
    required this.parameterOptions,
  });

  void select(String s) {
    selected = s;
  }
}
