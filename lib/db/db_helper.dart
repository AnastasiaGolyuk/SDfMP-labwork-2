import 'dart:io';

import 'package:lab2/models/currency.dart';
import 'package:lab2/models/product_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:lab2/models/product.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'labwork_2.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
          id INTEGER PRIMARY KEY,
          listJson TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE currencies(
          id INTEGER PRIMARY KEY,
          symbol TEXT,
          name TEXT,
          buy DOUBLE,
          sell DOUBLE
      )
      ''');
  }

  Future<String> getProducts() async {
    Database db = await instance.database;
    var results = await db.query('products');
    List<ProductList> productsList = results.isNotEmpty
        ? results.map((c) => ProductList.fromJson(c)).toList()
        : [];
    return productsList.first.listJson;
  }

  Future<String> getFavorites() async {
    Database db = await instance.database;
    var results = await db
        .query('products');
    List<ProductList> productsList = results.isNotEmpty
        ? results.map((c) => ProductList.fromJson(c)).toList()
        : [];
    return productsList.last.listJson;
  }

  Future<List<Currency>> getCurrencies() async {
    Database db = await instance.database;
    var results = await db.query('currencies');
    List<Currency> currenciesList = results.isNotEmpty
        ? results.map((c) => Currency.fromJson(c)).toList()
        : [];
    return currenciesList;
  }

  Future<int> addProducts(ProductList productList) async {
    Database db = await instance.database;
    await db.delete('products', where: 'id = ?', whereArgs: [1]);
    return await db.insert('products', productList.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> addCurrency(Currency currency) async {
    Database db = await instance.database;
    return await db.insert('currencies', currency.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> addFavourite(ProductList favouriteList) async {
    Database db = await instance.database;
    await db.delete('products', where: 'id = ?', whereArgs: [2]);
    return await db.insert('products', favouriteList.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
