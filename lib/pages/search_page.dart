import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:lab2/api/api_currency.dart';
import 'package:lab2/api/api_products.dart';
import 'package:lab2/consts/consts.dart';
import 'package:lab2/models/product.dart';
import 'package:lab2/tiles/product_search_tile.dart';

class Debouncer {
  final int milliseconds;
  Timer _timer = Timer(Duration(milliseconds: 1), () {});

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final APIProducts _apiProducts = Get.put(APIProducts());
  final APICurrency _apiCurrency = Get.put(APICurrency());

  String query = '';
  int prevSearchLength = 0;

  final controller = TextEditingController();
  var _selectedIndex = 0;

  var productList = <Product>[];
  var filteredList = <Product>[];

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    setState(() {
      productList = _apiProducts.productList.value;
      filteredList = productList;
    });
  }

  Widget _showItems(List<Product> list) {
    final double tileHeight =
        (Consts.getHeight(context) - kToolbarHeight - 24) / 2.2;
    final double tileWidth = Consts.getWidth(context) / 2;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: (tileWidth / tileHeight),
          crossAxisSpacing: 5,
          mainAxisSpacing: 5, //maxCrossAxisExtent: null
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext ctx, index) {
          return ProductTileSearch(list[index]);
        });
  }

  void searchItem(String query) {
    _debouncer.run(() {
      setState(() {
        switch(_selectedIndex){
          case 0:
            filteredList = productList.where((product) {
              final titleLower = product.name.toLowerCase();
              final searchLower = query.toLowerCase();
              return titleLower.contains(searchLower);
            }).toList();
            break;
          case 1:
            filteredList = productList.where((product) {
              final titleLower = product.brand.toLowerCase();
              final searchLower = query.toLowerCase();
              return titleLower.contains(searchLower);
            }).toList();
            break;
          case 2:
            filteredList = productList.where((product) {
              final titleLower = (product.price*product.coefficient).toString();
              final searchLower = query.toLowerCase();
              return titleLower.contains(searchLower);
            }).toList();
            break;
          case 3:
            filteredList = productList.where((product) {
              final titleLower = product.productType.toLowerCase();
              final searchLower = query.toLowerCase();
              return titleLower.contains(searchLower);
            }).toList();
            break;
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      buildSearch(),
      Expanded(child: Obx(() {
        if (_apiProducts.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).iconTheme.color));
        } else {
          return Container(child: _showItems(filteredList));
        }
      }))
    ]);
  }

  Widget buildSearch() {
    final style = TextStyle(color: Theme.of(context).primaryColor);

    return Row(children: [
      Container(
          height: 40,
          width: MediaQuery.of(context).size.width-70,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Theme.of(context).primaryColor, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
              width: Consts.getWidth(context)-70,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: style.color),
                  hintText: "Type for search something",
                  hintStyle: style,
                  border: InputBorder.none,
                ),
                style: style,
                onChanged: searchItem,
              ))),
      PopupMenuButton(
        child: Container(
          width: 50,
          child: Icon(Icons.filter_list),
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text("Name"),
            value: 0,
          ),
          PopupMenuItem(
            child: Text("Brand"),
            value: 1,
          ),
          PopupMenuItem(
            child: Text("Price"),
            value: 2,
          ),
          PopupMenuItem(
            child: Text("Product Type"),
            value: 3,
          ),
        ],
        onSelected: (int value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    ]);
  }
}
