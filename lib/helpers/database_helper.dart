import 'dart:io';
import 'package:jaap_app/models/mantra_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  static const _databaseName = 'JapApp.db';
  static const _databaseVersion = 1;

  static const table = 'mantra_table';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnContent = 'content';
  static const columnType = 'type';
  static const columnFolder = 'folder';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnContent TEXT NOT NULL,
            $columnType TEXT NOT NULL,
            $columnFolder TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Mantra mantra) async {
    Database db = await instance.database;
    final map = mantra.toMap();
    map.remove('id');
    return await db.insert(table, mantra.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  //Folder column se unque value leke aayega
  Future<List<String>> getUniqueFolders() async{
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      columns: ['folder'],
      distinct: true
    );
    if(maps.isEmpty){
      return [];
    }

    // Map ki list ko String ki list me convert kiya
    return List.generate(maps.length, (i){
      return maps[i]['folder'] as String;
    });
  }

  Future<List<String>> getUniqueTypesForFolder(String folderName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      columns: ['type'],
      distinct: true,    // Sirf types
      where: 'folder = ?', // Sirf us folder ke liye jiska naam...
      whereArgs: [folderName], // ...ye hai.
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) => maps[i]['type'] as String);
  }

  // type column se unique value leke aayega
  Future<List<String>> getAllUniqueTypes() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      columns: ['type'],
      distinct: true,
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) => maps[i]['type'] as String);
  }


  Future<List<Mantra>> getMantrasByFolderAndType(String folderName, String typeName) async {
    final db = await instance.database;
    final cleanFolderName = folderName.trim();
    final cleanTypeName = typeName.trim();

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'folder = ? AND type = ?',
      whereArgs: [cleanFolderName, cleanTypeName],
    );
    return List.generate(maps.length, (i) => Mantra.fromMap(maps[i]));
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    // 'id = ?' data ko SQL injection se bachata hai.
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Mantra mantra) async {
    final db = await instance.database;
    return await db.update(
      table,
      mantra.toMap(), // Naya data
      where: 'id = ?',
      whereArgs: [mantra.id],
    );
  }
}













