import 'package:disefood/model/cart.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteHelper {
  final String nameDatabase = 'diseFoodSQLite.db';
  final String tableDatabase = 'cartTable';
  int version = 1;

  final String idColumn = 'id';
  final String shopId = 'shopId';
  final String shopName = 'shopName';
  final String foodId = 'foodId';
  final String foodName = 'foodName';
  final String foodQuantity = 'foodQuantity';
  final String foodDescription = 'foodDescription';
  final String foodPrice = 'foodPrice';
  final String foodSumPrice = 'foodSumPrice';
  final String foodImg = 'foodImg';

  SQLiteHelper() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), nameDatabase),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableDatabase ($idColumn INTEGER PRIMARY KEY,$shopId TEXT,$shopName TEXT, $foodId INTEGER, $foodName TEXT, $foodQuantity INTEGER, $foodDescription TEXT, $foodPrice INTEGER, $foodSumPrice INTEGER, $foodImg TEXT)'),
        version: version);
  }

  Future<Database> connectedDatabase() async {
    return openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertDataToSQLite(CartModel cartModel) async {
    Database database = await connectedDatabase();
    var result = await database.query(tableDatabase,
        where: "$foodId = ${cartModel.foodId}");
    if (result.isEmpty) {
      print("Case 1 [Not exist Item Inserting Data to SQLite.....]");
      try {
        database.insert(
          tableDatabase,
          cartModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print("Insert Complete");
      } catch (e) {
        print('e insertData ===> ${e.toString()}');
      }
    } else {
      print("Case 2 [Exist Item Updating Data to SQLite.....]");
      try {
        database.rawUpdate(
          "UPDATE $tableDatabase SET $foodQuantity = ${cartModel.foodQuantity} , $foodSumPrice = ${cartModel.foodSumPrice} WHERE $foodId = ${cartModel.foodId}",
        );
        print("Insert Complete");
      } catch (e) {
        print('e insertData ===> ${e.toString()}');
      }
    }
  }

  Future<List<CartModel>> readAllDataFromSQLite() async {
    Database database = await connectedDatabase();
    List<CartModel> cartModels = List();
    List<Map<String, dynamic>> maps = await database.query(tableDatabase);
    for (var map in maps) {
      CartModel cartModel = CartModel.fromJson(map);
      cartModels.add(cartModel);
    }
    return cartModels;
  }

  Future<List<CartModel>> readAllQuantity() async {
    Database database = await connectedDatabase();
    List<CartModel> cartModels = List();
    List<Map<String, dynamic>> maps = await database.query(tableDatabase);
    for (var map in maps) {
      CartModel cartModel = CartModel.fromJson(map);
      cartModels.add(cartModel);
    }
    return cartModels;
  }

  Future<Null> deleteDataWhereId(int id) async {
    Database database = await connectedDatabase();
    try {
      await database.delete(tableDatabase, where: '$foodId=$id');
    } catch (e) {
      print('e delete ===> ${e.toString()}');
    }
  }

  Future<Null> deleteAllData() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(tableDatabase);
    } catch (e) {
      print('e delete ===> ${e.toString()}');
    }
  }
}
