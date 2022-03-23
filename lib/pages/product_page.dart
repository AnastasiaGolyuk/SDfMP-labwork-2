import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:lab2/api/api_products.dart';
import 'package:lab2/models/product.dart';
import 'package:lab2/tiles/product_search_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../consts/consts.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.title, required this.product})
      : super(key: key);

  final String title;

  final Product product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  void returnBack() {
    Navigator.pop(context);
  }

  Widget? generateColorPalette() {
    if (widget.product.productColors.isNotEmpty) {
      return Container(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 25,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5, //maxCrossAxisExtent: null
              ),
              itemCount: widget.product.productColors.length,
              itemBuilder: (BuildContext ctx, index) {
                return ElevatedButton(
                  onPressed: () {},
                  child: Text(''),
                  style: ElevatedButton.styleFrom(
                      primary: Color(int.parse(getColor(
                          widget.product.productColors[index].hexValue)))),
                );
              }));
    }
    return Text(
      'In one color(from picture)',
      style: TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
    );
  }

  String getColor(String color) {
    return '0xff' + color.substring(1);
  }

  double getHeightOfColorPalette() {
    int count = widget.product.productColors.isNotEmpty
        ? widget.product.productColors.length
        : 0;
    if (count > 10) {
      bool notFullRowExisted = false;
      if (count % 10 > 0) {
        notFullRowExisted = true;
      }
      count ~/= 10;
      if (notFullRowExisted) {
        count++;
      }
    } else {
      count = 1;
    }
    return count * 35;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
              icon: Icon(CupertinoIcons.back), onPressed: returnBack),
          title: Text(widget.title,
              style: TextStyle(
              color: Theme.of(context).primaryColor,
                fontFamily: Consts.titleFont,
              )),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          //primary: Colors.white,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              //alignment: Alignment.center,
              child: Text(
                widget.product.name,
                style: TextStyle(fontSize: 25, fontFamily: Consts.titleFont, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                height: 250,
                width: 250,
                child: CachedNetworkImage(
                  imageUrl: widget.product.imageLink,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Theme
                      .of(context)
                      .iconTheme.color,), heightFactor: 50),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                widget.product.description,
                style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.justify,
              ),
            ),
            Text(
              'Colors: ',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: Consts.titleFont, color: Theme.of(context).primaryColor),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: Consts.getWidth(context) - 100,
              height: getHeightOfColorPalette(),
              child: generateColorPalette(),
            ),
            Container(
              child: Text(
                widget.product.priceSign + " " + widget.product.price.toString(),
                style: TextStyle(fontSize: 25, color: Theme.of(context).primaryColor),
              ),
            )
          ]),
        ));
  }
}
