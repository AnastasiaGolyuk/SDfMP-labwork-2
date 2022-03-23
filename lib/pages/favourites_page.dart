import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lab2/api/api_products.dart';
import 'package:lab2/consts/consts.dart';
import 'package:lab2/tiles/product_fav_tile.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final APIProducts apiProducts = Get.put(APIProducts());

  @override
  Widget build(BuildContext context) {
    return Container(child: Obx(() {
      if (apiProducts.favouritesList.isEmpty) {
        return Center(
            child: Text('You have no favourite items',
                style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor)));
      } else {
        final double tileHeight = (Consts.getHeight(context) - kToolbarHeight - 24) / 3.7;
        final double tileWidth = Consts.getWidth(context);
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: tileWidth,
              childAspectRatio: (tileWidth / tileHeight),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: apiProducts.favouritesList.value.length,
            itemBuilder: (BuildContext ctx, index) {
              return ProductTileFav(apiProducts.favouritesList.value[index]);
            });
      }
    }));
  }
}
