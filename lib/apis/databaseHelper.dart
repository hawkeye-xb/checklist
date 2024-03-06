import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:checklist/types.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'card_type_db.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE CardType (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        contentList TEXT,
        created_at INTEGER,
        updated_at INTEGER,
        favorite INTEGER DEFAULT 0
      )
    '''); // 结尾逗号不能要
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 如果旧版本小于2，那么添加favorite字段
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE CardType ADD COLUMN favorite INTEGER DEFAULT 0');
    }
  }

  // 增加新的CardType
  Future<int> saveCardType(CardType cardType) async {
    var dbClient = await db;
    var result = await dbClient.insert(
      "CardType",
      cardType.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace, // 如果有冲突，则替换旧数据
    );
    return result;
  }

  // 根据id获取CardType
  Future<CardType?> getCardType(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
      "CardType",
      columns: ['id', 'title', 'contentList', 'created_at', 'updated_at'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return CardType.fromMap(maps.first);
    }
    return null;
  }

  // 获取所有CardTypes
  Future<List<CardType>> getCardTypes() async {
    var dbClient = await db;
    List<CardType> cardTypes = [];

    try {
      List<Map> list = await dbClient.rawQuery('SELECT * FROM CardType');
      cardTypes = list.isNotEmpty ? list.map((c) => CardType.fromMap(c)).toList() : [];
    } catch (e) {
      print('Error when getting card types: $e');
      if (e.toString().contains('no such table: CardType') && _db != null) {
        _onCreate(_db!, 1);
      }
    }
    return cardTypes;
  }

  // 更新CardType
  Future<int> updateCardType(CardType cardType) async {
    var dbClient = await db;
    return await dbClient.update(
      "CardType",
      cardType.toMap(),
      where: 'id = ?',
      whereArgs: [cardType.id],
    );
  }

  // 删除CardType
  Future<int> deleteCardType(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      "CardType",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 删除多个CardTypes，入参ids
  Future<int> deleteCardTypes(List<int> ids) async {
    var dbClient = await db;
    return await dbClient.delete(
      "CardType",
      where: 'id IN (${ids.join(",")})',
    );
  }

  // 清空所有CardTypes
  Future<int> clearCardTypes() async {
    var dbClient = await db;
    return await dbClient.delete("CardType");
  }

  // 删除所有表
  Future<void> deleteAllTables() async {
    var dbClient = await db;
    return await dbClient.execute('DROP TABLE CardType');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}