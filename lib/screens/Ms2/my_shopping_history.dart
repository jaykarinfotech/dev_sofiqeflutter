import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sofiqe/controller/controllers.dart';
import 'package:sofiqe/controller/shoppinglistHistory.dart';
import 'package:sofiqe/provider/page_provider.dart';
import 'package:sofiqe/screens/Ms2/product_detail.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/states/function.dart';
import 'package:sofiqe/widgets/cart/empty_bag.dart';
import 'package:sofiqe/widgets/makeover/make_over_login_custom_widget.dart';

class MyShoppingHistory extends StatefulWidget {
  const MyShoppingHistory({Key? key}) : super(key: key);

  @override
  _MyShoppingHistoryState createState() => _MyShoppingHistoryState();
}

class _MyShoppingHistoryState extends State<MyShoppingHistory> {
  bool scrollingPhysics = false;
  List<Map<String, dynamic>> data = [
    {
      "name": "DIOR ADDICT LACQUER PLUMP",
      "price": "39.95 EUR",
      "image": "lip_1.png",
      "status": "In Progress",
      "date": "11 Mar 2021",
      "orderNo": "123456",
      "colour": "RED",
      "size": "5 MM"
    },
    {
      "name": "DIOR ADDICT PLUMP LACQUER ",
      "price": "65.39 EUR",
      "image": "mySelectionItem.png",
      "status": "Delivered",
      "date": "22 May 2021",
      "orderNo": "654321",
      "colour": "BROWN",
      "size": "8 MM"
    },
  ];

  ShoppingHistory sHistory = Get.put(ShoppingHistory());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sHistory.getShoppingHistory();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0.0,
            leading: InkWell(
                onTap: () {
                  profileController.screen.value = 0;
                },
                child: Icon(
                  Icons.close,
                )),
            centerTitle: true,
            title: Text(
              'sofiqe',
              style: Theme.of(context).textTheme.headline1!.copyWith(
                  color: Colors.white,
                  fontSize: size.height * 0.035,
                  letterSpacing: 0.6),
            )),
        body: Container(
          height: Get.height - AppBar().preferredSize.height,
          width: Get.width,
          child: Column(
            children: [
              Container( width: Get.width, color: Colors.black,child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'MY SHOPPING HISTORY',
                    style: TextStyle(
                        color: Colors.white, fontSize: 15, letterSpacing: 1),
                  ),
                ),
              ),),
              Expanded(
                child: SingleChildScrollView(
                  physics: sHistory.historyList == null
                      ? NeverScrollableScrollPhysics()
                      : BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      GetBuilder<ShoppingHistory>(builder: (contrl) {
                        return contrl.isShoppingListLoading
                            ? Container(
                                height: Get.height,
                                width: Get.width,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ))
                            : (contrl.historyList == null)
                                ? Container(
                                    height:
                                        Get.height - AppBar().preferredSize.height,
                                    width: Get.width,
                                    child: Container(
                                      width: double.infinity,
                                      color: Color(0xffF4F2F0),
                                      child: EmptyBagPage(
                                        emptyBagButtonText: null,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    //contrl.historyList!.data is not an array
                                    itemCount:
                                        contrl.historyList!.data!.length,
                                    itemBuilder: (context, i) {
                                      return InkWell(
                                        onTap: () {
                                          //Added on 13-04-2022...by Ashwani
                                          if(contrl
                                              .historyList!.data!.isNotEmpty) {
                                            Get.to(() =>
                                                ProductDetail(
                                                    data: data[0],
                                                    orderId: contrl
                                                        .historyList!.data![i].orderId!));
                                          }
                                        },
                                        child: Container(
                                          height: 100,
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 10),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: Get.width * 0.25,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: Image.network(
                                                    contrl.historyList!.data![i].items![0].image!.toString(),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '€${(double.parse(contrl
                                                                  .historyList!
                                                                  .data![i].subTotal!)).toStringAsFixed(2)}',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              'ORDER: ${contrl.historyList!.data![i].orderId}',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('. ',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFFF2CA8A),
                                                                        fontSize: 18,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold)),
                                                                Text(
                                                                    '${contrl.historyList!.data![i].status}',
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold)),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text(
                                                              DateFormat(
                                                                      'dd MMM yyyy')
                                                                  .format(DateTime
                                                                      .parse(contrl
                                                                          .historyList!
                                                                          .data![i]
                                                                          .date
                                                                          .toString()))
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                            (contrl.historyList!.data![i]
                                                                        .status! ==
                                                                    'pending')
                                                                ? SizedBox()
                                                                : Container(
                                                                    height: 20,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: Get.width *
                                                                        0.2,
                                                                    decoration: BoxDecoration(
                                                                        color: Color(0xffF2CA8A),
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    20)),
                                                                    child: Text(
                                                                      'BUY AGAIN',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
