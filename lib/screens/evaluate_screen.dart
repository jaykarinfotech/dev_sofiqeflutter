import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../controller/looksController.dart';
import '../utils/constants/api_end_points.dart';
import '../widgets/capsule_button.dart';

class EvaluateScreen extends StatefulWidget {
  String? imagePath;
  String? sku;
  String? name;

  EvaluateScreen(this.imagePath, this.sku, this.name);

  @override
  _EvaluateScreenState createState() => _EvaluateScreenState();
}

class _EvaluateScreenState extends State<EvaluateScreen> {
  LooksController looksController = Get.put(LooksController());

  int generalRating = 0;
  int priceRating = 0;
  int qualityRating = 0;
  String details = '';
  String nickName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            child: Image.asset(
              "assets/icons/Path_11_1.png",
            ),
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'EVALUATE',
          style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(15),
            width: Get.width,
            height: Get.height,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Image(
                        width: 150,
                        height: 150,
                        image: NetworkImage(widget.imagePath!.contains('http') ? widget.imagePath! : APIEndPoints.mediaBaseUrl+widget.imagePath!)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    widget.name!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'GENERAL',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.left,
                    )),
                Align(
                  alignment: Alignment.center,
                  child: RatingBar.builder(
                    unratedColor: Colors.white,
                    itemSize: 40,
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star_border,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      generalRating = rating.toInt();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PRICE',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.left,
                    )),
                Align(
                  alignment: Alignment.center,
                  child: RatingBar.builder(
                    unratedColor: Colors.white,
                    itemSize: 40,
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star_border,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      priceRating = rating.toInt();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'QUALITY',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.left,
                    )),
                Align(
                  alignment: Alignment.center,
                  child: RatingBar.builder(
                    unratedColor: Colors.white,
                    itemSize: 40,
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star_border,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      qualityRating = rating.toInt();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      details = value.toString();
                    });
                  },
                  controller: null,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    labelText: 'Please add your comment',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      nickName = value.toString();
                    });
                  },
                  controller: null,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    labelText: 'Please add your name',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CapsuleButton(
                    backgroundColor: Colors.white,
                    borderColor: Color(0xFF393636),
                    onPress: () async {
                      if (details.isNotEmpty && nickName.isNotEmpty) {
                        looksController.createReview(
                            details,
                            nickName,
                            widget.sku!,
                            generalRating,
                            priceRating,
                            qualityRating);
                        Navigator.pop(context);
                      } else {
                        Get.showSnackbar(
                          GetBar(
                            message: 'Please enter required details.',
                            duration: Duration(seconds: 2),
                            isDismissible: true,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Share Review',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
