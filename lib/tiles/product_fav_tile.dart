import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lab2/api/api_products.dart';
import 'package:lab2/db/db_helper.dart';
import 'package:lab2/models/product.dart';
import 'package:lab2/models/product_list.dart';
import 'package:lab2/pages/web_view_page.dart';

class ProductTileFav extends StatelessWidget {
  final Product product;

  ProductTileFav(this.product);

  TextEditingController _textEditingController = TextEditingController();
  String _textFromField = '';

  Future _removeFromFavourites() async {
    APIProducts apiProducts = Get.put(APIProducts());
    apiProducts.favouritesList.remove(product);
    product.isFavorite.toggle();
    apiProducts.favouritesList.refresh();
    apiProducts.productList.refresh();
    await DatabaseHelper.instance.addFavourite(ProductList(id: 2, listJson: productToJson(apiProducts.favouritesList)));
  }

  Future _changeComment(BuildContext context) async {
    _textEditingController.text = product.commentFav;
    _textFromField = _textEditingController.text;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Make changes...',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColor),
            ),
            content: TextField(
              controller: _textEditingController,
              onChanged: (value) {
                _textFromField = value;
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    product.commentFav = _textFromField;
                    _textFromField = '';
                    APIProducts apiProducts = Get.put(APIProducts());
                    apiProducts.favouritesList.refresh();
                    return Navigator.pop(context, 'Change comment');
                  },
                  child: Text(
                    'Change comment',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        child: InkResponse(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Stack(
                    children: [
                      Positioned(
                          child: Container(
                              height: 130,
                              width: 130,
                              child: CachedNetworkImage(
                                imageUrl: product.imageLink,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    heightFactor: 50),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ))),
                      Positioned(
                        left: 0,
                        child: Obx(() => CircleAvatar(
                              backgroundColor: Theme.of(context).cardColor,
                              child: IconButton(
                                  icon: product.isFavorite.value
                                      ? Icon(CupertinoIcons.heart_fill)
                                      : Icon(CupertinoIcons.heart),
                                  onPressed: () {
                                    _removeFromFavourites();
                                  },
                                  color: Theme.of(context).iconTheme.color),
                            )),
                      ),
                    ],
                  ),
                  Stack(children: [
                    Container(
                      height: 130,
                      width: 230,
                      child: Text(
                        'Your comment:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Theme.of(context).primaryColor),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    if (product.commentFav.isNotEmpty)
                      Container(
                          padding: EdgeInsets.only(top: 30),
                          width: 200,
                          child: Text(
                              'Your comment: ${product.commentFav}',
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).primaryColor),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis))
                    else
                      Container(
                          width: 200,
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            'You didn\'t left any comments',
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor),
                            textAlign: TextAlign.start,
                          )),
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).cardColor,
                        child: IconButton(
                          icon: Icon(CupertinoIcons.pencil),
                          onPressed: () {
                            _changeComment(context);
                          },
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ])
                ]),
                SizedBox(
                  height: 1.5,
                ),
                SizedBox(height: 2),
                Text(product.name,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewPage(product: product)),
                (ret) => true);
          },
        ));
  }
}
