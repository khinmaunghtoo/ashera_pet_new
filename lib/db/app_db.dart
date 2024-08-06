
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDB{
  static const String _dbName = 'pet_db';
  static const String searchTable = 'search_record';
  static const String msgTable = 'msg_record';
  static const String messageRoomTable = 'message_room_record';
  static const String allPet = 'all_pet_record';
  static late Database _database;

  //初始化
  static Future<void> initDatabase() async {
    _database = await openDatabase(join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) => _createdDB(db, version),
      onUpgrade: (db, oldVersion, newVersion) => _upGrade(db, oldVersion, newVersion),
      version: 3
    );
  }

  //建立DB-Table
  static void _createdDB(Database db, int version) async {
    //建立DB
    Batch batch = db.batch();
    batch.execute("CREATE TABLE $searchTable("
        "id INTEGER PRIMARY KEY,"
        "memberId INTEGER,"
        "nickname TEXT,"
        "mugshot TEXT,"
        "facePic TEXT,"
        "aboutMe TEXT,"
        "age INTEGER,"
        "birthday TEXT,"
        "animalType INTEGER,"
        "gender INTEGER,"
        "healthStatus INTEGER,"
        "member TEXT,"
        "status INTEGER"
        ")"
    );
    batch.execute("CREATE TABLE $msgTable("
        "id INTEGER PRIMARY KEY,"
        "fromMember TEXT,"
        "fromMemberId INTEGER,"
        "fromMemberView TEXT,"
        "targetMember TEXT,"
        "targetMemberId INTEGER,"
        "targetMemberView TEXT,"
        "content TEXT,"
        "type TEXT,"
        "unreadCnt INTEGER,"
        "block INTEGER,"
        "isRead INTEGER,"
        "updatedAt TEXT,"
        "createdAt TEXT,"
        "status INTEGER,"
        "chatRoomId INTEGER,"
        "chatType TEXT)"
    );
    batch.execute("CREATE TABLE $messageRoomTable("
        "id INTEGER PRIMARY KEY,"
        "chatRoomId INTEGER,"
        "memberId INTEGER,"
        "memberPetId INTEGER,"
        "chatType TEXT)"
    );
    batch.execute("CREATE TABLE $allPet("
        "id INTEGER PRIMARY KEY,"
        "memberId INTEGER,"
        "mugshot TEXT,"
        "facePic TEXT,"
        "nickname TEXT,"
        "aboutMe TEXT,"
        "age INTEGER,"
        "birthday TEXT,"
        "animalType INTEGER,"
        "gender INTEGER,"
        "healthStatus INTEGER,"
        "status TEXT,"
        "member TEXT,"
        "latitude REAL,"
        "longitude REAL,"
        "pics TEXT)"
    );
    await batch.commit(noResult: true, continueOnError: true);
  }

  //更新DB
  static void _upGrade(Database db, int oldVersion, int newVersion) async {
    Batch batch = db.batch();
    if(oldVersion == 1){
      batch.execute('ALTER TABLE $msgTable ADD chatRoomId INTEGER');
      batch.execute('ALTER TABLE $msgTable ADD chatType TEXT');
    }
    if(oldVersion == 2){
      batch.execute("CREATE TABLE $messageRoomTable("
          "id INTEGER PRIMARY KEY,"
          "chatRoomId INTEGER,"
          "memberId INTEGER,"
          "memberPetId INTEGER,"
          "chatType TEXT)"
      );
      batch.execute("CREATE TABLE $allPet("
          "id INTEGER PRIMARY KEY,"
          "memberId INTEGER,"
          "mugshot TEXT,"
          "facePic TEXT,"
          "nickname TEXT,"
          "aboutMe TEXT,"
          "age INTEGER,"
          "birthday TEXT,"
          "animalType INTEGER,"
          "gender INTEGER,"
          "healthStatus INTEGER,"
          "status TEXT,"
          "member TEXT,"
          "latitude REAL,"
          "longitude REAL,"
          "pics TEXT)"
      );
    }
    await batch.commit();
  }

  ///新增
  /// * [tableName] 表名
  /// * [data] 資料
  static Future<void> insert(String tableName, Map<String, dynamic> data) async {
    Batch batch = _database.batch();
    batch.insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true, continueOnError: false);
  }

  ///更新
  /// * [tableName] 表名
  /// * [where] 條件 ex: name = ?
  /// * [key] 關鍵字
  /// * [data] 資料
  static Future<void> update(String tableName, String where, List<String> key, Map<String, dynamic> data) async {
    Batch batch = _database.batch();
    batch.update(
      tableName,
      data,
      where: where,
      whereArgs: key
    );
    await batch.commit(noResult: true);
  }

  ///取得此表符合條件資料
  /// * [tableName] 表名
  /// * [where] 條件 ex: name = ?
  /// * [key] 關鍵字
  static Future<List<Map<String, dynamic>>> getTableData(String tableName, String where, List<String> key, [int? limit, String? orderBy, int? offset]) async {
    List<Map<String, dynamic>> maps = await _database.query(tableName, where: where, whereArgs: key, orderBy: orderBy, limit: limit, offset: offset);
    return maps;
  }

  ///取得此表全部資料
  /// * [tableName] 表名
  static Future<List<Map<String, dynamic>>> getAllTableData(String tableName) async {
    List<Map<String, dynamic>> maps = await _database.query(tableName);
    return maps;
  }

  ///刪除
  /// * [tableName] 表名
  static Future<void> delete(String tableName) async {
    Batch batch = _database.batch();
    batch.delete(tableName);
    await batch.commit();
  }

  ///刪除單筆
  /// * [tableName] 表名
  ///
  static Future<void> deleteData(String tableName, String where, List<dynamic> key) async {
    Batch batch = _database.batch();
    batch.delete(tableName, where: where, whereArgs: key);
    await batch.commit();
  }
}