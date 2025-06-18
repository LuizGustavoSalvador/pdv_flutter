import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ProductRepository {
  static final ProductRepository _instance = ProductRepository._internal();
  factory ProductRepository() => _instance;
  ProductRepository._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pdv_products.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            price REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return db.query('products', orderBy: 'id DESC');
  }

  Future<int> insertProduct(String name, double price) async {
    final db = await database;
    return db.insert('products', {'name': name, 'price': price});
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
