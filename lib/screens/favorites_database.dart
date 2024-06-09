import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class FavoritesDatabase {
  // Singleton instance
  static final FavoritesDatabase instance = FavoritesDatabase._init();

  // Private constructor
  FavoritesDatabase._init();

  static final FavoritesDatabase _instance = FavoritesDatabase.internal();
  factory FavoritesDatabase() => _instance;
  static Database? _db;

  FavoritesDatabase.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "favorites.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE favorites (id INTEGER PRIMARY KEY, fact TEXT)");
  }

  Future<int> saveFavorite(String fact) async {
    var dbClient = await db;
    return await dbClient.insert("favorites", {"fact": fact});
  }

  Future<int> deleteFavorite(String fact) async {
    var dbClient = await db;
    return await dbClient
        .delete("favorites", where: "fact = ?", whereArgs: [fact]);
  }

  Future<List<String>> getFavorites() async {
    var dbClient = await db;
    List<Map> result = await dbClient.query("favorites");
    return result.map((item) => item['fact'] as String).toList();
  }
}
