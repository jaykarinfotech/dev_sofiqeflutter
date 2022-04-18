import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sofiqe/provider/catalog_provider.dart';
import 'package:sofiqe/widgets/capsule_button.dart';

import '../../../model/CategoryResponse.dart';

class FilterOverlay extends StatelessWidget {
  FilterOverlay({Key? key}) : super(key: key);

  final CatalogProvider catp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Obx(
        () {
          FilterType ftp = catp.filterTypePressed.value;

          switch (ftp) {
            case FilterType.SKINTONE:
              return Column(
                children: [
                  SkinToneSelector(),
                  CloseButton(),
                ],
              );
            case FilterType.PRODUCT:
              return Column(
                children: [
                  ProductSelector(),
                  CloseButton(),
                ],
              );
            case FilterType.PRICE:
              return Column(
                children: [
                  PriceSelector(),
                  CloseButton(),
                ],
              );
            case FilterType.BRAND:
              return Column(
                children: [
                  BrandSelector(),
                  CloseButton(),
                ],
              );
            case FilterType.REVIEW:
              return Column(
                children: [
                  ReviewSelector(),
                  CloseButton(),
                ],
              );
            case FilterType.POPULAR:
              break;
            case FilterType.NONE:
              break;
          }
          return Container();
        },
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  CloseButton({Key? key}) : super(key: key);

  final CatalogProvider catp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.065,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(size.height * 0.06),
            bottomRight: Radius.circular(size.height * 0.06)),
      ),
      child: GestureDetector(
        onTap: () {
          catp.applyFilter();
        },
        child: Center(
          child: Text(
            'FIND',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.white,
                  fontSize: size.height * 0.016,
                ),
          ),
        ),
      ),
    );
  }
}

class PriceSelector extends StatefulWidget {
  PriceSelector({Key? key}) : super(key: key);

  @override
  State<PriceSelector> createState() => _PriceSelectorState();
}

class _PriceSelectorState extends State<PriceSelector> {
  final CatalogProvider catp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    RangeValues currentRangeValues = RangeValues(
        catp.priceFilter.value.currentMinPrice.toDouble(),
        catp.priceFilter.value.currentMaxPrice.toDouble());
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.08, vertical: size.height * 0.06),
      color: Colors.black,
      child: Row(
        children: [
          Text(
            '€${catp.priceFilter.value.minPrice}',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.white,
                  fontSize: size.height * 0.014,
                ),
          ),
          Expanded(
            child: RangeSlider(
              activeColor: Color(0xFFF2CA8A),
              inactiveColor: Color(0xFF504D4D),
              values: currentRangeValues,
              min: catp.priceFilter.value.minPrice.toDouble(),
              max: catp.priceFilter.value.maxPrice.toDouble(),
              labels: RangeLabels(
                '€ ${catp.priceFilter.value.currentMinPrice}',
                '€ ${catp.priceFilter.value.currentMaxPrice}',
              ),
              divisions: catp.priceFilter.value.maxPrice,
              onChanged: (RangeValues values) {
                catp.priceFilter.value.currentMinPrice = values.start.toInt();
                catp.priceFilter.value.currentMaxPrice = values.end.toInt();
                setState(() {});
              },
            ),
          ),
          Text(
            '€${catp.priceFilter.value.maxPrice}',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.white,
                  fontSize: size.height * 0.014,
                ),
          ),
        ],
      ),
    );
  }
}

class BrandSelector extends StatelessWidget {
  BrandSelector({Key? key}) : super(key: key);

  final CatalogProvider catp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.01, vertical: size.height * 0.02),
      width: size.width,
      color: Colors.black,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(
              () {
                Rx<BrandFilter> pf = BrandFilter().obs;
                if (catp.faceArea.value == FaceArea.ALL) {
                  pf = catp.allBrandFilter;
                } else if (catp.faceArea.value == FaceArea.CHEEKS) {
                  pf = catp.cheeksBrandFilter;
                } else if (catp.faceArea.value == FaceArea.LIPS) {
                  pf = catp.lipsBrandFilter;
                } else if (catp.faceArea.value == FaceArea.EYES) {
                  pf = catp.eyesBrandFilter;
                }
                return Row(
                  children: pf.value.subAreas.map(
                    (sa) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: size.width * 0.012),
                        child: CapsuleButton(
                          backgroundColor: pf.value.subArea == sa
                              ? Colors.white
                              : Colors.transparent,
                          borderColor: Colors.white38,
                          height: size.height * 0.05,
                          child: Text(
                            '$sa',
                            style:
                                Theme.of(context).textTheme.headline2!.copyWith(
                                      fontSize: size.height * 0.014,
                                      color: pf.value.subArea == sa
                                          ? Colors.black
                                          : Color(0xFFF2CA8A),
                                    ),
                          ),
                          onPress: () {
                            if (pf.value.subArea == sa) {
                              pf.value.subArea = '';
                            } else {
                              pf.value.subArea = sa;
                            }
                            pf.refresh();
                          },
                        ),
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Obx(
            () {
              Rx<BrandFilter> pf = BrandFilter().obs;
              if (catp.faceArea.value == FaceArea.ALL) {
                pf = catp.allBrandFilter;
              } else if (catp.faceArea.value == FaceArea.CHEEKS) {
                pf = catp.cheeksBrandFilter;
              } else if (catp.faceArea.value == FaceArea.LIPS) {
                pf = catp.lipsBrandFilter;
              } else if (catp.faceArea.value == FaceArea.EYES) {
                pf = catp.eyesBrandFilter;
              }
              return Container(
                constraints: BoxConstraints(
                  minWidth: size.width,
                  maxHeight: size.height * 0.4,
                ),
                // height: size.height * 0.2,
                child: SingleChildScrollView(
                  child: Wrap(
                    runSpacing: size.height * 0.014,
                    children: [
                      ...pf.value.brands.map(
                        (b) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.01),
                            child: CapsuleButton(
                              horizontalPadding: 0,
                              borderColor: Colors.white38,
                              backgroundColor: pf.value.brand == b
                                  ? Colors.white
                                  : Colors.black,
                              width: size.width * 0.3,
                              height: size.height * 0.05,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  '$b',
                                  // overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                        fontSize: size.height * 0.012,
                                        color: pf.value.brand == b
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                ),
                              ),
                              // child: Container(
                              //   padding: EdgeInsets.all(1),
                              //   child: AutoSizeText(
                              //     '$b',
                              //     minFontSize: 4,
                              //     textAlign: TextAlign.center,
                              //     style: Theme.of(context).textTheme.headline2!.copyWith(
                              //           fontSize: size.height * 0.014,
                              //           color: pf.value.brand == b ? Colors.black : Colors.white,
                              //         ),
                              //     maxLines: 1,
                              // ),
                              // ),
                              onPress: () {
                                if (pf.value.brand == b) {
                                  pf.value.brand = '';
                                } else {
                                  pf.value.brand = b;
                                }
                                pf.refresh();
                              },
                            ),
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class ReviewSelector extends StatelessWidget {
  ReviewSelector({Key? key}) : super(key: key);

  final CatalogProvider catp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.01, vertical: size.height * 0.02),
      width: size.width,
      color: Colors.black,
      child: Column(
        children: [
          Obx(() {
              return Container(
                constraints: BoxConstraints(
                  minWidth: size.width,
                  maxHeight: size.height * 0.4,
                ),
                // height: size.height * 0.2,
                child: SingleChildScrollView(
                  child: Wrap(
                    runSpacing: size.height * 0.014,
                    children: [
                      ...catp.availableStar.map(
                            (b) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.01),
                            child: CapsuleButton(
                              horizontalPadding: 0,
                              borderColor: Colors.white38,
                              backgroundColor:

                              catp.selectedStar.value == 0 && b == "4+ Star" ? Colors.white :
                              catp.selectedStar.value == 1 && b == "3+ Star" ? Colors.white :
                              catp.selectedStar.value == 2 && b == "2+ Star" ? Colors.white : Colors.black,

                              width: size.width * 0.3,
                              height: size.height * 0.05,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  '$b',
                                  // overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                    fontSize: size.height * 0.012,
                                    color:
                                    catp.selectedStar.value == 0 && b == "4+ Star" ? Colors.black :
                                    catp.selectedStar.value == 1 && b == "3+ Star" ? Colors.black :
                                    catp.selectedStar.value == 2 && b == "2+ Star" ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                              // child: Container(
                              //   padding: EdgeInsets.all(1),
                              //   child: AutoSizeText(
                              //     '$b',
                              //     minFontSize: 4,
                              //     textAlign: TextAlign.center,
                              //     style: Theme.of(context).textTheme.headline2!.copyWith(
                              //           fontSize: size.height * 0.014,
                              //           color: pf.value.brand == b ? Colors.black : Colors.white,
                              //         ),
                              //     maxLines: 1,
                              // ),
                              // ),
                              onPress: () {
                                if (catp.selectedStar.value == 0 && b == "4+ Star") {
                                  catp.selectedStar.value = 10;
                                  catp.starValueChanges.value = true;
                                } else if(catp.selectedStar.value != 0 && b == "4+ Star"){
                                  catp.selectedStar.value = 0;
                                  catp.starValueChanges.value = true;
                                }else if(catp.selectedStar.value == 1 && b == "3+ Star"){
                                  catp.selectedStar.value = 10;
                                  catp.starValueChanges.value = true;
                                }else if(catp.selectedStar.value != 1 && b == "3+ Star"){
                                  catp.selectedStar.value = 1;
                                  catp.starValueChanges.value = true;
                                }else if(catp.selectedStar.value == 2 && b == "2+ Star"){
                                  catp.selectedStar.value = 10;
                                  catp.starValueChanges.value = true;
                                }else if(catp.selectedStar.value != 2 && b == "2+ Star"){
                                  catp.selectedStar.value = 2;
                                  catp.starValueChanges.value = true;
                                }
                              },
                            ),
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class ProductSelector extends StatelessWidget {
  ProductSelector({Key? key}) : super(key: key);

  final CatalogProvider catp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.02, vertical: size.height * 0.02),
      width: size.width,
      color: Colors.black,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(
          () {
            Rx<ProductFilter> pf = ProductFilter().obs;
            if (catp.faceArea.value == FaceArea.ALL) {
              pf = catp.allProductFilter;
            } else if (catp.faceArea.value == FaceArea.CHEEKS) {
              pf = catp.cheeksProductFilter;
            } else if (catp.faceArea.value == FaceArea.LIPS) {
              pf = catp.lipsProductFilter;
            } else if (catp.faceArea.value == FaceArea.EYES) {
              pf = catp.eyesProductFilter;
            }
            return Row(
              children: pf.value.subAreas.map(
                (sa) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: size.width * 0.012),
                    child: CapsuleButton(
                      backgroundColor: pf.value.subArea == sa
                          ? Colors.white
                          : Colors.transparent,
                      borderColor: Colors.white38,
                      height: size.height * 0.05,
                      child: Text(
                        '${sa.name!}',
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              fontSize: size.height * 0.014,
                              color: pf.value.subArea == sa
                                  ? Colors.black
                                  : Color(0xFFF2CA8A),
                            ),
                      ),
                      onPress: () {
                        if (pf.value.subArea == sa) {
                          pf.value.subArea = ChildrenData();
                        } else {
                          pf.value.subArea = sa;
                        }
                        pf.refresh();
                      },
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }
}

class SkinToneSelector extends StatelessWidget {
  SkinToneSelector({Key? key}) : super(key: key);

  final CatalogProvider catp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(maxHeight: size.height * 0.55),
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.02, vertical: size.height * 0.02),
      width: size.width,
      color: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () {
                  Rx<SkinToneFilter> pf = SkinToneFilter().obs;
                  if (catp.faceArea.value == FaceArea.CHEEKS) {
                    pf = catp.cheeksSkinToneFilter;
                  } else if (catp.faceArea.value == FaceArea.LIPS) {
                    pf = catp.lipsSkinToneFilter;
                  } else if (catp.faceArea.value == FaceArea.EYES) {
                    pf = catp.eyesSkinToneFilter;
                  }
                  return Row(
                    children: pf.value.faceSubAreas.map(
                      (fsa) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.012),
                          child: CapsuleButton(
                            backgroundColor:
                                pf.value.selectedFaceSubArea.contains(fsa)
                                    ? Colors.white
                                    : Colors.transparent,
                            borderColor: Colors.white38,
                            height: size.height * 0.05,
                            child: Text(
                              '$fsa',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                    fontSize: size.height * 0.014,
                                    color: pf.value.selectedFaceSubArea
                                            .contains(fsa)
                                        ? Colors.black
                                        : Color(0xFFF2CA8A),
                                  ),
                            ),
                            onPress: () {
                              pf.value.toggleFaceSubArea(fsa);
                              pf.refresh();
                            },
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: size.height * 0.02),
            CapsuleButton(
              backgroundColor: Colors.transparent,
              horizontalPadding: 0,
              borderColor: Colors.white38,
              height: size.height * 0.05,
              width: size.width * 0.75,
              child: Text(
                'SEARCH BASED ON YOUR ANALYSIS',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontSize: size.height * 0.013,
                      color: Color(0xFFF2CA8A),
                    ),
              ),
              onPress: () {},
            ),
            SizedBox(height: size.height * 0.02),
            Obx(
              () {
                Rx<SkinToneFilter> pf = SkinToneFilter().obs;
                if (catp.faceArea.value == FaceArea.CHEEKS) {
                  pf = catp.cheeksSkinToneFilter;
                } else if (catp.faceArea.value == FaceArea.LIPS) {
                  pf = catp.lipsSkinToneFilter;
                } else if (catp.faceArea.value == FaceArea.EYES) {
                  pf = catp.eyesSkinToneFilter;
                }
                if (pf.value.selectedFaceSubArea.isEmpty) {
                  return Container();
                }
                List<SkinToneFilterParameters> options =
                    pf.value.options[pf.value.selectedFaceSubArea]
                        as List<SkinToneFilterParameters>;
                return Container(
                  constraints: BoxConstraints(
                      maxHeight: size.height * 0.44, minWidth: size.width),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: options.map(
                        (stfp) {
                          List<Widget> optionList = <Widget>[];
                          stfp.parameterOptions.forEach(
                            (key, value) {
                              optionList.add(
                                CapsuleButton(
                                  backgroundColor: stfp.selected == key
                                      ? Colors.white
                                      : Colors.transparent,
                                  horizontalPadding: 0,
                                  borderColor: Colors.white38,
                                  height: size.height * 0.05,
                                  width: size.width * 0.3,
                                  child: Text(
                                    '$key',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(
                                          fontSize: size.height * 0.014,
                                          color: stfp.selected == key
                                              ? Colors.black
                                              : Color(0xFFF2CA8A),
                                        ),
                                  ),
                                  onPress: () {
                                    if (stfp.selected == key) {
                                      stfp.select('');
                                      pf.value.changed = true;
                                    } else {
                                      stfp.select(key);
                                      pf.value.changed = true;
                                    }
                                    pf.refresh();
                                  },
                                ),
                              );
                            },
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: size.height * 0.02),
                              Text(
                                '${stfp.parameterName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                      fontSize: size.height * 0.014,
                                      color: Colors.white,
                                    ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              Wrap(
                                spacing: size.width * 0.02,
                                runSpacing: size.height * 0.01,
                                children: optionList,
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
