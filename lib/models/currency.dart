import 'dart:convert';
import 'package:get/get.dart';

List<Currency> currenciesFromJson(String str) => List<Currency>.from(json.decode(str).map((x) => Currency.fromJson(x)));

String currenciesToJson(List<Currency> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Currency{

  final int id;
  final String symbol;
  final String name;
  final double buy;
  final double sell;

  Currency({required this.id, required this.symbol, required this.name, required this.buy, required this.sell});

  double getSell(){
    return this.sell;
  }

  double getBuy(){
    return this.buy;
  }

  String getSymbol(){
    return this.symbol;
  }

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    symbol: json["symbol"],
    name: json["name"],
    buy: json["buy"],
    sell: json["sell"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "name": name,
    "buy": buy,
    "sell": sell,
  };
}