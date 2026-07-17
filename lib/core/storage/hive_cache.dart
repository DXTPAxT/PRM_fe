import 'package:hive_flutter/hive_flutter.dart';

class HiveCache {
  HiveCache._();

  static const String categoriesBoxName = 'categories_cache';
  static const String homeProductsBoxName = 'home_products_cache';
  static const String profileBoxName = 'profile_cache';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(categoriesBoxName);
    await Hive.openBox(homeProductsBoxName);
    await Hive.openBox(profileBoxName);
  }

  static Box getBox(String name) {
    return Hive.box(name);
  }

  static Future<void> clearAll() async {
    await Hive.box(categoriesBoxName).clear();
    await Hive.box(homeProductsBoxName).clear();
    await Hive.box(profileBoxName).clear();
  }
}
