import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperService {
  static late Database database;

  static Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'budget.db');
    var exists = await databaseExists(path);
    if (!exists) {
      var data = await rootBundle.load(join('assets', 'db', 'budget.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    database = await openDatabase(path, readOnly: false);
  }

  static Future getBudgets() async {
    try {
      var res = await database.rawQuery('SELECT * from budgets');
      print(res);
      return res;
    } catch (error) {
      print('error $error');
    }
  }

  static Future<void> createBudget(title, description, String price, type) async {
    try {
      var realPrice = price.split(',')[0];
      realPrice = realPrice.replaceAll('.', '');
      await database.rawInsert(
        "INSERT INTO budgets (title,description,price,type) values ('$title','$description','$realPrice','$type')",
      );
    } catch (error) {
      print('error $error');
    }
  }

  static Future deleteBudget(id) async {
    try {
      await database.rawDelete("DELETE FROM budgets WHERE id = '$id';");
    } catch (error) {
      print('error $error');
    }
  }

  static Future updateBudget(title, description, price, type, id) async {
    try {
      var realPrice = price.split(',')[0];
      realPrice = realPrice.replaceAll('.', '');
      return await database.rawUpdate(
        "UPDATE budgets SET title = '$title', description = '$description', price = '$realPrice', type = '$type' where id = $id",
      );
    } catch (error) {
      print('error $error');
    }
  }
}
