import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'shopping_cart.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE master_products(id TEXT PRIMARY KEY, title TEXT, price REAL, imageUrl TEXT)',
        );
        await db.execute(
          'CREATE TABLE user_cart(id TEXT PRIMARY KEY, title TEXT, quantity INTEGER, price REAL)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertProduct(Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    await db.insert(
      'master_products',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await DBHelper.database();
    return db.query('master_products');
  }

  static Future<void> insertCartItem(Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    await db.insert(
      'user_cart',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await DBHelper.database();
    return db.query('user_cart');
  }

  static Future<void> deleteCartItem(String id) async {
    final db = await DBHelper.database();
    await db.delete('user_cart', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearCart() async {
    final db = await DBHelper.database();
    await db.delete('user_cart');
  }
}