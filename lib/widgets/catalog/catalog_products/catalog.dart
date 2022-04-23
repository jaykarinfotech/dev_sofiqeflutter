import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/model/data_ready_status_enum.dart';
import 'package:sofiqe/provider/catalog_provider.dart';
import 'package:sofiqe/widgets/product_item_card.dart';

import '../../../provider/account_provider.dart';
import '../../../provider/cart_provider.dart';

class Catalog extends StatefulWidget {
  const Catalog({Key? key}) : super(key: key);

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  ScrollController gridScrollController = ScrollController();

  final CatalogProvider cp = Get.find();

  @override
  void initState() {
    super.initState();
     gridScrollController.addListener(loadMore);
   // loadMore();
  }

  @override
  void dispose() {
    // gridScrollController.removeListener(loadMore);
    super.dispose();
  }

  Future<void> loadMore() async {
    if (gridScrollController.offset == gridScrollController.position.maxScrollExtent) {
      print('Loading More');
      if (await cp.fetchMoreItems()) {
        setState(() {});
        gridScrollController.animateTo(gridScrollController.offset + 20, duration: Duration(milliseconds: 200), curve: Curves.linear);
      } else {
        print('Could not fetch more products');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding = size.height * 0.04;
    return Obx(
      () {
        DataReadyStatus status = cp.catalogItemsStatus.value;
        if (status == DataReadyStatus.INACTIVE) {
          return EmptyCatalog();
        } else if (status == DataReadyStatus.FETCHING) {
          return BufferingCatalog();
        } else if (status == DataReadyStatus.COMPLETED) {
          if (cp.catalogItemsList.isEmpty) {
            return EmptyCatalog();
          }
          return Column(
            children: [
              Container(
                height: size.height * 0.025,
                color: Color(0xffF2CA8A),
                alignment: Alignment.center,
                child: Text(Provider.of<CartProvider>(context).itemCount == 0 ? 'Free shipping above €'+Provider.of<AccountProvider>(context, listen: false).freeShippingAmount : 'Add € XXX to your cart to get free shipping',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Container(
                height: size.height * .62,
                width: size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFF4F2F0),
                ),
                child: GridView.builder(
                  controller: gridScrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: padding / 2,
                    mainAxisSpacing: padding / 2,
                    childAspectRatio:
                        ((size.width - padding) / 2) / (size.height * 0.4),
                  ),
                  padding: EdgeInsets.all(padding / 2),
                  itemCount: cp.catalogItemsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(cp.catalogItemsList[index].avgRating);
                    return ProductItemCard(
                      product: cp.catalogItemsList[index],
                    );
                  },
                ),
              ),
            ],
          );
        } else if (status == DataReadyStatus.ERROR) {
          return ErrorCatalog();
        } else {
          return ErrorCatalog();
        }
      },
    );
  }
}

class EmptyCatalog extends StatelessWidget {
  const EmptyCatalog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Color(0xFFF4F2F0),
      ),
      child: Center(
        child: Text(
          'We can\'t find products matching the selection. Please try a different filter',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2!.copyWith(
                fontSize: size.height * 0.024,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

class BufferingCatalog extends StatelessWidget {
  const BufferingCatalog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Color(0xFFF4F2F0),
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorCatalog extends StatelessWidget {
  const ErrorCatalog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Color(0xFFF4F2F0),
      ),
      child: Center(
        child: Text(
          'Looks like there is an issue on our end... Please try again later',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2!.copyWith(
                fontSize: size.height * 0.024,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
