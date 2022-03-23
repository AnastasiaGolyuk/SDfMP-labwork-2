import 'dart:io';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:lab2/api/api_currency.dart';
import 'package:lab2/consts/consts.dart';
import 'package:lab2/db/db_helper.dart';
import 'package:lab2/models/currency.dart';
import 'package:lab2/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:lab2/models/product_list.dart';
import 'package:path_provider/path_provider.dart';

class APIProducts extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var favouritesList = <Product>[].obs;

  @override
  Future<void> onInit() async {
    fetchProducts();
    super.onInit();
  }

  void setCurrency(Currency currency) {
    APICurrency apiCurrency = Get.put(APICurrency());
    var sell = apiCurrency.currencies.elementAt(1).sell;
    var buy = currency.buy;
    var symbol = currency.symbol;
    if (symbol == "\$") {
      buy = 1.0;
      sell = 1.0;
    }
    for (var element in productList) {
      element.coefficient = sell / buy;
      element.displayedCurrency.value = symbol;
    }
    productList.refresh();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var fileName = "products.json";
      var dir = await getTemporaryDirectory();
      File file = File(dir.path + "/" + fileName);
      if (file.existsSync()) {
        if (DateTime.now().difference(file.lastModifiedSync()).inMinutes>2){
          file.deleteSync();
          fetchProducts();
        } else {
          final products = productFromJson(file.readAsStringSync());
          productList.addAll(products);
        }
      } else {
        for (int i = 0; i < Consts.brandList.length; i++) {
          var response = await http.get(Uri.parse(
              Consts.productsAPIUrlBrand + Consts.brandList.elementAt(i)));
          if (response.statusCode == Consts.okStatus) {
            final products = productFromJson(response.body);
            productList.addAll(products);
          }
        }
        file.writeAsStringSync(productToJson(productList),flush: true,mode: FileMode.write);
        await DatabaseHelper.instance.addProducts(ProductList(id: 1, listJson: productToJson(productList)));
      }
      for (var element in productList) {
        element.priceSign = Consts.currenciesSymbols.elementAt(1);
        element.currency = Consts.currenciesName.elementAt(1);
      }
      String jsonDBFav = await DatabaseHelper.instance.getFavorites();
      final favourites = productFromJson(jsonDBFav);
      favouritesList.addAll(favourites);

      favouritesList.forEach((elementFav) {
        productList.forEach((element) {
          if (element.name==elementFav.name){
            element.isFavorite.toggle();
            elementFav.isFavorite.toggle();
          }
        });
      });
    } catch (e, stackTrace) {
      if (e is SocketException) {
        String jsonDB = await DatabaseHelper.instance.getProducts();
        final products = productFromJson(jsonDB);
        productList.addAll(products);
        for (var element in productList) {
          element.priceSign = Consts.currenciesSymbols.elementAt(1);
          element.currency = Consts.currenciesName.elementAt(1);
          element.coefficient = 1.0;
        }

        String jsonDBFav = await DatabaseHelper.instance.getFavorites();
        final favourites = productFromJson(jsonDBFav);
        favouritesList.addAll(favourites);

        favouritesList.forEach((elementFav) {
          productList.forEach((element) {
            if (element.name==elementFav.name){
              element.isFavorite.toggle();
              elementFav.isFavorite.toggle();
            }
          });
        });
      }
    } finally {
      isLoading(false);
    }
  }
}
