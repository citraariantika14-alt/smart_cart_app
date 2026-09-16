import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'smart_cart.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE master_products (
            id INTEGER PRIMARY KEY,
            name TEXT,
            price REAL,
            imageUrl TEXT,
            description TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE local_cart (
            id INTEGER PRIMARY KEY,
            name TEXT,
            price REAL,
            quantity INTEGER
          )
        ''');
      },
    );
  }

  // Operasi Master Products
  static Future<void> insertProduct(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('master_products', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('master_products');
  }

  // Operasi Local Cart
  static Future<void> insertCart(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('local_cart', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('local_cart');
  }

  static Future<void> updateCartQuantity(int id, int quantity) async {
    final db = await database;
    await db.update('local_cart', {'quantity': quantity}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db.delete('local_cart', where: 'id = ?', whereArgs: [id]);
  }
}