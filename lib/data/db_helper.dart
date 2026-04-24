import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/billboard.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'panneaux_mapr.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE billboards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude REAL,
        longitude REAL,
        photoPath TEXT,
        description TEXT,
        type TEXT,
        dimension TEXT,
        condition TEXT,
        dateAdded TEXT
      )
    ''');
  }

  Future<int> insertBillboard(Billboard billboard) async {
    Database db = await database;
    return await db.insert('billboards', billboard.toMap());
  }

  Future<List<Billboard>> getAllBillboards() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('billboards');
    return List.generate(maps.length, (i) => Billboard.fromMap(maps[i]));
  }

  Future<int> deleteBillboard(int id) async {
    Database db = await database;
    return await db.delete('billboards', where: 'id = ?', whereArgs: [id]);
  }
}
