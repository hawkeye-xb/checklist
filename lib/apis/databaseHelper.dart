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
    var db = await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    print('Creating new table');
    await db.execute('''
      CREATE TABLE CardType (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        contentList TEXT,
        created_at INTEGER,
        updated_at INTEGER
      )
    '''); // 结尾逗号不能要
    // 注意，这里我们将contentList存储为TEXT类型，实际将它存储为JSON字符串。
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE CardType ADD COLUMN created_at INTEGER');
    //   await db.execute('ALTER TABLE CardType ADD COLUMN updated_at INTEGER');
    // }
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
      // 在这里处理错误，例如显示一个错误消息，是否需要重新创建表？
      if (_db != null) {
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
  Future<int> deleteCardType(String id) async {
    var dbClient = await db;
    return await dbClient.delete(
      "CardType",
      where: 'id = ?',
      whereArgs: [id],
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