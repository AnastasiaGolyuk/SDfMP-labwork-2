import 'dart:io';

import 'package:get/state_manager.dart';
import 'package:lab2/consts/consts.dart';
import 'package:lab2/db/db_helper.dart';
import 'package:lab2/models/currency.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';

class APICurrency extends GetxController {
  var currencies = <Currency>[].obs;

  @override
  void onInit() {
    fetchCurrencies();
    super.onInit();
  }

  void fetchCurrencies() async {
    try {
      var fileName = "currencies.json";
      var dir = await getTemporaryDirectory();
      File file = File(dir.path + "/" + fileName);
      if (file.existsSync()) {
        if (DateTime.now().difference(file.lastModifiedSync()).inMinutes > 2) {
          file.deleteSync();
          fetchCurrencies();
        } else {
          final currenciesRead = currenciesFromJson(file.readAsStringSync());
          currencies.addAll(currenciesRead);
        }
      } else {
        var response = await http.get(Uri.parse(Consts.currenciesAPIUrl));
        if (response.statusCode == Consts.okStatus) {
          var doc = parse(response.body);
          var currencies = doc.getElementsByClassName("ex_ch");
          int length = currencies.length;
          this.currencies.add(Currency(
              id: 1,
              symbol: Consts.currenciesSymbols.first,
              name: Consts.currenciesName.first,
              buy: 1.0,
              sell: 1.0));
          for (int i = 0; i < length; i++) {
            var primaryValues = currencies[i].parent.parent.text.split('\n');
            var buy =
                double.parse(primaryValues[2].replaceAll(RegExp(r"[\s+]"), ""));
            var sell =
                double.parse(primaryValues[3].replaceAll(RegExp(r"[\s+]"), ""));
            if (i >= 2) {
              if (i == 3) {
                buy /= 10;
                sell /= 10;
              } else {
                buy /= 100;
                sell /= 100;
              }
            }
            Currency currency = Currency(
                id: i + 2,
                symbol: Consts.currenciesSymbols.elementAt(i + 1),
                name: Consts.currenciesName.elementAt(i + 1),
                buy: buy,
                sell: sell);
            this.currencies.add(currency);
          }
          this.currencies.forEach((element) async {
            await DatabaseHelper.instance.addCurrency(
                element);
          });
          file.writeAsStringSync(currenciesToJson(this.currencies),
              flush: true, mode: FileMode.write);
        }
      }
    } catch (e, stackTrace) {
      if (e is SocketException) {
        print('no connection');
        currencies.value = await DatabaseHelper.instance.getCurrencies();
      }
    }
  }
}
