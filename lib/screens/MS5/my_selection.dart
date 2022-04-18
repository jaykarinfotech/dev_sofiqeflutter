// ignore_for_file: must_be_immutable, unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/controller/selectedProductController.dart';
import 'package:sofiqe/provider/catalog_provider.dart';
import 'package:sofiqe/provider/page_provider.dart';
import 'package:sofiqe/screens/MS8/looks_package_details.dart';
import 'package:sofiqe/screens/shopping_bag_screen.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/widgets/makeover/total_make_over/make_over_try_on.dart';
import 'package:sofiqe/widgets/png_icon.dart';
import 'package:sofiqe/widgets/round_button.dart';
import 'package:sofiqe/widgets/translucent_background.dart';

import '../../provider/cart_provider.dart';

class MySelectionMS5 extends StatelessWidget {
  MySelectionMS5({Key? key}) : super(key: key);

  final CatalogProvider catp = Get.find();
  SelectedProductController selectedProductController =
      Get.put(SelectedProductController());

  @override
  Widget build(BuildContext context) {
    selectedProductController.getSelectedProduct();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        // height: size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _TopBanner(),
            Obx(
              () {
                FaceArea fa = catp.faceArea.value;
                return _MainFilter(faceArea: fa);
              },
            ),
            _SubFilter(),
            GetBuilder<SelectedProductController>(builder: (contrl) {
              return (contrl.isSelectedProductLoading)
                  ? Expanded(
                      child: Container(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  : Expanded(
                      child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: (contrl.selectedProduct == null)
                          ? Center(
                              child: Text("No Data Found"),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.50,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemCount: contrl.selectedProduct!.items!.length,
                              itemBuilder: (ctx, i) {
                                bool isDiscounted = false;
                                int discount = 0;
                                try {
                                  isDiscounted = contrl
                                      .selectedProduct!
                                      .items![i]
                                      .product!
                                      .specialPrice!
                                      .isNotEmpty;
                                  if (isDiscounted) {
                                    discount = (double.parse(contrl
                                                .selectedProduct!
                                                .items![i]
                                                .product!
                                                .specialPrice!) /
                                            double.parse(contrl.selectedProduct!
                                                .items![i].product!.price!) *
                                            100)
                                        .toInt();
                                  }
                                } catch (e) {
                                  isDiscounted = false;
                                }
                                return Card(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 5, left: 5, right: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  (contrl
                                                          .selectedProduct!
                                                          .items![i]
                                                          .product!
                                                          .isWished!)
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {},
                                              ),
                                              isDiscounted
                                                  ? Container(
                                                      width: 30,
                                                      height: 31,
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          color: Color(
                                                              0xffF4F2F0)),
                                                      child: Center(
                                                        child: Text(
                                                          "$discount%\noff",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Image.network(
                                          // 'assets/images/mySelectionItem.png',
                                          APIEndPoints.mediaBaseUrl +
                                              "${contrl.selectedProduct!.items![i].product!.image}",
                                          width: 69, height: 83,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          contrl.selectedProduct!.items![i]
                                              .product!.name!,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "${contrl.selectedProduct!.items![i].product!.price!}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10),
                                            ),
                                            isDiscounted
                                                ? Text(
                                                    "${contrl.selectedProduct!.items![i].product!.price!}",
                                                    style: TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.red,
                                                      fontSize: 10,
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.to(() => MakeOverTryOn());
                                              },
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    Color(0xffF2CA8A),
                                                child: Center(
                                                  child: Text(
                                                    "TRY ON",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.to(() => LookPackageMS8());
                                              },
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundColor: Colors.black,
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/images/Path_6.png',
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ));
            }),
          ],
        ),
      ),
    );
  }
}

class _TopBanner extends StatelessWidget {
  _TopBanner({Key? key}) : super(key: key);

  final PageProvider pp = Get.find();
  final CatalogProvider catp = Get.find();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var cartItems = Provider.of<CartProvider>(context).itemCount;
    return Stack(
      children: [
        Container(
          height: size.height * 0.15,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/mySelection.png'),
            ),
          ),
        ),
        Container(
            height: size.height * 0.15,
            width: size.width,
            child: TranslucentBackground(opacity: 0.2)),
        Container(
          height: size.height * 0.15,
          width: size.width,
          child: Row(
            children: [
              Container(
                width: size.width * 0.18,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: SvgPicture.asset('assets/svg/arrow.svg'),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: size.width,
          height: size.height * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sofiqe',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.white,
                      fontSize: size.height * 0.018,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                'My Selection',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.white,
                      fontSize: size.height * 0.018,
                    ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                '9 Products',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.white,
                      fontSize: size.height * 0.015,
                    ),
              ),
            ],
          ),
        ),
        Container(
          width: size.width,
          height: size.height * 0.15,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.014),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundButton(
                backgroundColor: Colors.black,
                size: size.height * 0.05,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext c) {
                        return ShoppingBagScreen();
                      },
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    PngIcon(image: 'assets/icons/add_to_cart_white.png'),
                    cartItems == 0 ? SizedBox() :
                    Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red
                        ),
                        padding: EdgeInsets.all(5),
                        child: Text(
                            cartItems.toString()
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final CatalogProvider catp = Get.find();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(storeInput);
  }

  void storeInput() {
    catp.inputText.value = controller.value.text;
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {});
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.012, vertical: size.height * 0.008),
      alignment: Alignment.center,
      width: size.width * 0.6,
      height: size.height * 0.05,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(size.height * 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: size.width * 0.5,
            child: CupertinoTextField(
              padding: EdgeInsets.symmetric(horizontal: 4),
              controller: controller,
              autofocus: true,
              decoration: BoxDecoration(
                  // border: InputBorder.none,
                  ),
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                    fontSize: size.height * 0.0225,
                    decoration: TextDecoration.none,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () {
              catp.search();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
              child: SvgPicture.asset(
                'assets/svg/search.svg',
                color: Colors.black,
                height: size.height * 0.018,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainFilter extends StatelessWidget {
  final FaceArea faceArea;
  _MainFilter({
    Key? key,
    required this.faceArea,
  }) : super(key: key);

  final CatalogProvider catp = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.055,
      width: size.width,
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            bottom: BorderSide(
              color: Color(0xFF645F5F),
              width: 0.5,
            ),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              // catp.setFaceArea(FaceArea.ALL);
            },
            child: Text(
              'ALL',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: faceArea == FaceArea.ALL
                        ? Color(0xFFF2CA8A)
                        : Colors.white,
                    fontSize: size.height * 0.018,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // catp.setFaceArea(FaceArea.EYES);
            },
            child: Text(
              'EYES',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: faceArea == FaceArea.EYES
                        ? Color(0xFFF2CA8A)
                        : Colors.white,
                    fontSize: size.height * 0.018,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // catp.setFaceArea(FaceArea.LIPS);
            },
            child: Text(
              'LIPS',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: faceArea == FaceArea.LIPS
                        ? Color(0xFFF2CA8A)
                        : Colors.white,
                    fontSize: size.height * 0.018,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // catp.setFaceArea(FaceArea.CHEEKS);
            },
            child: Text(
              'CHEEKS',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: faceArea == FaceArea.CHEEKS
                        ? Color(0xFFF2CA8A)
                        : Colors.white,
                    fontSize: size.height * 0.018,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.075,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Path_6.png',
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "ADD ALL TO BAG",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class _SubFilterButton extends StatelessWidget {
  final String filterName;
  final String svgPath;
  final Color color;
  final bool premium;
  final void Function() onTap;
  const _SubFilterButton({
    Key? key,
    required this.filterName,
    required this.svgPath,
    required this.color,
    required this.onTap,
    this.premium = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.01),
            SvgPicture.asset(
              '$svgPath',
              color: color,
              width: size.height * 0.02,
              height: size.height * 0.02,
            ),
            SizedBox(height: size.height * 0.005),
            Text(
              '$filterName',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: color,
                    fontSize: size.height * 0.015,
                  ),
            ),
            Text(
              '${premium ? 'PREMIUM' : ''}',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Color(0xFFF2CA8A),
                    fontSize: size.height * 0.01,
                    letterSpacing: 0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
