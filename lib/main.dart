import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:stock/repositories/stock/models.dart';
import 'package:stock/stock_app.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CatalogAdapter());
  Hive.registerAdapter(ThingAdapter());
  await Hive.openBox<Catalog>('catalog_box');
  await Hive.openBox<Thing>('thing_box');

  runApp(const MyApp());
}




