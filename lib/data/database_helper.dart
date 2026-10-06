import 'package:path/path.dart';
import 'package:recipe/model/recipe.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //singleton pattern
  static final DatabaseHelper instance=DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }
  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'recipe_box.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, async) async {
        await db.execute('''
      CREATE TABLE favorites(
      id INTEGER PRIMARY KEY,
      name TEXT,
      image TEXT
      )
''');
      },
    );
  }

  Future<void> insertFavorite(Recipe recipe) async{
    final db=await database;
    await db.insert("favorites", recipe.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
