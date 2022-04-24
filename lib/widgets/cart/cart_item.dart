import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/provider/cart_provider.dart';

// Utils
import 'package:sofiqe/utils/constants/app_colors.dart';
import 'package:sofiqe/utils/states/function.dart';

import '../../model/product_model.dart';
import '../../provider/catalog_provider.dart';
import '../../utils/api/product_details_api.dart';

class CartItem extends StatefulWidget {
  final Map<String, dynamic> item;
  CartItem({Key? key, required this.item}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late final List listItem = List.generate(widget.item['qty'] + 10, (int index) {
    return index + 1;
  });

  var image = "".obs;
  final CatalogProvider catp = Get.find();
  late int valueChoose = widget.item['qty'];

  @override
  void initState() {
    super.initState();
    loadProductImage();
  }

  Future<void> loadProductImage() async {
    var contain = catp.catalogItemsList.where((element) => element.sku == widget.item['sku']);
    if(contain.isNotEmpty){
      image.value = contain.single.image;
    }else{
      var response = await sfAPIGetProductDetailsFromSKU(sku:  widget.item['sku']);
      Map<String, dynamic> responseBody = json.decode(response.body);
      Product product = Product.fromDefaultMap(responseBody);
      image.value = product.image;
    }
    if (image.startsWith('http')) {
      image.value = image.replaceAll(
          RegExp(r'https://dev.sofiqe.com/media/catalog/product'), '');
    }
    image.value = 'https://dev.sofiqe.com/media/catalog/product/cache/983707a945d60f44d700277fbf98de57$image';
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Container(
          child: Card(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 29),
                      child: Container(
                        child: Obx(()=>image.isEmpty ?
                        Image.asset(
                          'assets/icons/lip_1.png',
                          // width: 9,
                          // height: 5,
                        ): Image.network(image.value,width: 50,fit: BoxFit.fill,errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                          return Image.asset(
                            'assets/icons/lip_1.png',
                            // width: 9,
                            // height: 5,
                          );
                        }))
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 28,
                          ),
                          Text(
                            '${widget.item['name']}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontFamily: 'Arial, Bold', fontWeight: FontWeight.bold, color: SplashScreenPageColors.backgroundColor),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text('${widget.item['product_type']}'),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 11.5, right: 11.5),
                          child: IconButton(
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false).removeFromCart(widget.item['item_id'].toString());
                            },
                            icon: Icon(
                              Icons.delete,
                              size: 20,
                            ),
                            color: Colors.grey.shade300,
                            // iconSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5, top: 10),
                              child: Icon(
                                Icons.circle,
                                color: AppColors.primaryColor,
                                size: 10,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 23.5, top: 10),
                              child: Text(
                                'IN STOCK',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 7, fontFamily: 'Arial, Regular'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Divider(
                    height: 4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                        child: DropdownButton(
                          menuMaxHeight: MediaQuery.of(context).size.height * 0.4,
                          elevation: 0,
                          value: valueChoose,
                          icon: Icon(Icons.expand_more_sharp),
                          iconSize: 30,
                          isExpanded: true,
                          items: listItem.map((valueItem) {
                            return DropdownMenuItem(value: valueItem, child: Text('$valueItem'));
                          }).toList(),
                          onChanged: (newValue) async {
                            valueChoose = newValue as int;
                            setState(() {});
                            await changeQuantity(context, valueChoose, widget.item);
                          },
                        ),
                      ),
                      Text(
                        '${(widget.item['price'] as num).toDouble().toProperCurrencyString()}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Arial, Regular',
                          color: SplashScreenPageColors.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changeQuantity(BuildContext c, int current, Map item) async {
    var cartProvider = Provider.of<CartProvider>(c, listen: false);
    print(item);
    int type = item['product_type'] == 'configurable' ? 1 : 0;
    try {

      await cartProvider.removeFromCart('${item['item_id']}', refresh: false);
      await cartProvider.addToCart(c,
          item['sku'] != null ? item['sku'].toString().contains("-") ? item['sku'].toString().split("-").first : item['sku'] : "",
          item['product_option'] == null ? [] :
          item['product_option']['extension_attributes'] == null ? [] :
          item['product_option']['extension_attributes']['${type == 1
              ? 'custom_options'
              : 'configurable_item_options'}'], type,
          refresh: false,quantity: current);
      cartProvider.fetchCartDetails();
    }catch(e){
      print(e.toString());
    }

  }


}
