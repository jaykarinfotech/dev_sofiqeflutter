import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sofiqe/controller/ms8Controller.dart';
import 'package:sofiqe/utils/api/product_details_api.dart';
import 'package:sofiqe/widgets/makeover/total_make_over/make_over_try_on.dart';
import 'package:sofiqe/widgets/product_detail/static_details.dart';

class LookPackageMS8 extends StatefulWidget {
  final String? image;
  const LookPackageMS8({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  _LookPackageMS8State createState() => _LookPackageMS8State();
}

class _LookPackageMS8State extends State<LookPackageMS8> {
  Ms8Controller controller = Get.put(Ms8Controller());

  @override
  void initState() {
    controller.getLookList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: GetBuilder<Ms8Controller>(builder: (contrl) {
          return (contrl.isLookLoading)
              ? Container(
                  height: Get.height,
                  width: Get.width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : (contrl.ms8model == null)
                  ? Container(
                      color: Colors.red,
                    )
                  : Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.black,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "sofiqe",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                  Text(
                                    "LOOKS",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Center(
                                  child:
                                      Image.asset("assets/images/Path_6.png"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          height: 308,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    widget.image!,

                                    // AssetImage('assets/images/mysofiqe.png')
                                    //     as ImageProvider

                                    // contrl.ms8model!.lookImage != null
                                    // NetworkImage(APIEndPoints.mediaBaseUrl +
                                    //         "${contrl.ms8model!.lookImage!}"
                                    //'assets/images/mysofiqe.png'
                                  )
                                  //     : AssetImage('assets/images/mysofiqe.png')
                                  //         as ImageProvider,
                                  //  fit: BoxFit.fill

                                  )),
                        ),
                        SizedBox(
                          height: Get.height * 0.07,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(),
                            Text(
                              contrl.ms8model!.lookDescription! //"BOMBSHELL"
                              ,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            IconButton(
                              onPressed: () {


                              },
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.grey[300],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.07,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "€ " +
                                        contrl.ms8model!.lookPrice!.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 5,
                                        backgroundColor: Color(0xffF2CA8A),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "IN STOCK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              FutureBuilder(
                                future: sfAPIGetProductStatic(),
                                builder: (BuildContext _, snapshot) {
                                  if (snapshot.hasData) {
                                    return StaticDetails(
                                        data: json
                                            .decode(snapshot.data as String));
                                  } else {
                                    return Container(
                                      height: 65,
                                      color: Colors.black,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              height: 50,
                              minWidth: Get.width * 0.4,
                              color: Color(0xffF2CA8A),
                              shape: StadiumBorder(),
                              onPressed: () {
                                Get.to(() => MakeOverTryOn());
                              },
                              child: Text("TRY ON"),
                            ),
                            MaterialButton(
                              height: 50,
                              minWidth: Get.width * 0.4,
                              color: Colors.white,
                              shape: StadiumBorder(),
                              onPressed: () {
                                //TODO
                              },
                              child: Row(
                                children: [
                                  Image.asset('assets/images/Path_6.png'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("ADD TO BAG")
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
        }),
      ),
    ));
  }
}
