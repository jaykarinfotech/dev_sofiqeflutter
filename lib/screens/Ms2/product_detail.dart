// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sofiqe/controller/orderDetailController.dart';
import 'package:sofiqe/utils/constants/api_end_points.dart';
import 'package:sofiqe/utils/states/function.dart';

class ProductDetail extends StatefulWidget {
  Map<String, dynamic> data;
  String orderId;

  ProductDetail({required this.data, required this.orderId});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
//   @override
  OrderDetailController shoppingHistory = Get.put(OrderDetailController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shoppingHistory.getOrderDetails(widget.orderId);
  }

//   @override
  @override
  Widget build(BuildContext context) {
    print('orderId  ${widget.orderId}');
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            //toolbarHeight: size.height * 0.15,
            backgroundColor: Colors.black,
            elevation: 0.0,
            leading: InkWell(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back,
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
                      'ORDER DETAILS',
                      style: TextStyle(
                          color: Colors.white, fontSize: 15, letterSpacing: 1),
                    ),
                  ),
                ),),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: GetBuilder<OrderDetailController>(builder: (contrl) {
                      return (contrl.isOrderLoading)
                          ? Container(
                              height: Get.height,
                              width: Get.width,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : (contrl.orderModel == null)
                              ? Container(
                                  height: Get.height,
                                  width: Get.width,
                                  child: Center(child: Text("No Data Found")),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PRODUCTS (${contrl.orderModel!.data!.items!.length})',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            contrl.orderModel!.data!.items!.length,
                                        itemBuilder: (context, i) {
                                          return InkWell(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.symmetric(vertical: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: Get.width * 0.25,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(10.0),
                                                      child: Image.network(
                                                        APIEndPoints.mediaBaseUrl +
                                                            "${contrl.orderModel!.data!.items![i].image}",
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${contrl.orderModel!.data!.items![i].name}",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              'REFERANCE: ${contrl.orderModel!.data!.items![i].orderQty}',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                "SIZE: ${contrl.orderModel!.data!.items![i].customAttributes!.volume}",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                    "COLOUR: ${widget.data["colour"]}",
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal)),
                                                                SizedBox(
                                                                  width: 100,
                                                                ),
                                                                Text(
                                                                  '€${(double.parse(contrl.orderModel!.data!.items![i].price!)).toStringAsFixed(2)}',
                                                                  style: TextStyle(
                                                                      fontSize: 10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),

                                                      /* Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [

                                                            //  Container(

                                                            //   child: Column(
                                                            //      crossAxisAlignment: CrossAxisAlignment.end,
                                                            //     mainAxisAlignment: MainAxisAlignment.end,
                                                            //     children: [
                                                            //       Text("€ ${ data["price"]}",style: TextStyle(fontSize: 10,fontWeight: FontWeight.normal),),
                                                            //     SizedBox(height: 10,),
                                                            //       // Container(
                                                            //       //   height: 20,
                                                            //       //   alignment: Alignment.center,
                                                            //       //   width: Get.width*0.2,
                                                            //       //   decoration: BoxDecoration(
                                                            //       //     color: Colors.black,
                                                            //       //     borderRadius: BorderRadius.circular(20)
                                                            //       //   ),
                                                            //       //   child: Text('BUY AGAIN',style: TextStyle(color: Colors.white,fontSize: 10),),
                                                            //       // ),
                                                            //     ],
                                                            //   ),
                                                            // )
                                                          ],
                                                        ),*/
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                    Divider(),
                                    SizedBox(height: 10),
                                    Text(
                                      'DELIVERY',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        "${contrl.orderModel!.data!.shippingAddress!.street}\n${contrl.orderModel!.data!.shippingAddress!.city}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal)),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("DELIVERY DATE",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal)),
                                        Text(
                                            DateFormat('E, dd MMM yyyy')
                                                .format(DateTime.parse(contrl
                                                    .orderModel!.data!.date
                                                    .toString()))
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("PAYMENT METHOD",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal)),
                                        Row(
                                          children: [
                                            Text(
                                                contrl.orderModel!.data!
                                                            .paymentMethod!.ccType ==
                                                        null
                                                    ? ''
                                                    : "${contrl.orderModel!.data!.paymentMethod!.ccType} ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.normal)),
                                            Text(
                                                contrl.orderModel!.data!
                                                            .paymentMethod!.ccLast4 ==
                                                        null
                                                    ? ''
                                                    : "${contrl.orderModel!.data!.paymentMethod!.ccLast4}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.normal)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Text(
                                        'STATUS',
                                        style: TextStyle(
                                          fontSize: 10,
                                          letterSpacing: 1.30,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text(
                                        "${contrl.orderModel!.data!.status}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            letterSpacing: 1.40,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Center(
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        width: Get.width * 0.6,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(30)),
                                        child: Text(
                                          'BUY AGAIN',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                    }),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
