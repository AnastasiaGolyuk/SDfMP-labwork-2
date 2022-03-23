import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lab2/api/api_products.dart';
import 'package:lab2/db/db_helper.dart';
import 'package:lab2/models/product.dart';
import 'package:lab2/models/product_list.dart';
import 'package:lab2/pages/product_page.dart';

class ProductTileSearch extends StatelessWidget {
  final Product product;

  ProductTileSearch(this.product);

  TextEditingController _textEditingController = TextEditingController();
  String _textFromField = '';

  Future _addToFavourites(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Add your comment...',
              style: TextStyle(fontSize: 15, color: Theme
                  .of(context)
                  .primaryColor,),
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
                    fontSize: 15, color: Theme
                      .of(context)
                      .primaryColor,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    product.commentFav = _textFromField;
                    _textFromField = '';
                    APIProducts apiProducts = Get.put(APIProducts());
                    if (product.isFavorite.isFalse) {
                      apiProducts.favouritesList.add(product);
                    } else {
                      apiProducts.favouritesList.remove(product);
                    }
                    apiProducts.favouritesList.refresh();
                    product.isFavorite.toggle();
                    await DatabaseHelper.instance.addFavourite(ProductList(id: 2, listJson: productToJson(apiProducts.favouritesList)));
                    return Navigator.pop(context, 'Ok');
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme
                          .of(context)
                          .primaryColor,
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
          Stack(
          children: [
          Container(
          height: 200,
            child: CachedNetworkImage(
              imageUrl: product.imageLink,
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
            Positioned(
              right: 0,
              child: Obx(() =>
                  CircleAvatar(
                    backgroundColor:
                    Theme
                        .of(context)
                        .cardColor,
                    child: IconButton(
                      icon: product.isFavorite.value
                          ? Icon(CupertinoIcons.heart_fill)
                          : Icon(CupertinoIcons.heart),
                      onPressed: () {
                        _addToFavourites(context);
                      },
                      color: Theme
                          .of(context)
                          .iconTheme
                          .color,
                    ),
                  )),
            )
            ],
          ),
          SizedBox(
            height: 1.5,
          ),
          Text(product.productType,
              style: TextStyle(
                fontSize: 15,
                color: Theme
                    .of(context)
                    .primaryColor,
              )),
          SizedBox(height: 2),
          Text(product.name,
              maxLines: 2,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 2),
          Text('${product.displayedCurrency}${(product.price *
              product.coefficient).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                color: Theme
                    .of(context)
                    .primaryColor,
              )),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductPage(title: ' ', product: product)),
                (ret) => true);
      },
    ));
  }
}
