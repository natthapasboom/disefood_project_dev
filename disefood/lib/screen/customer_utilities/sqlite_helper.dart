import 'package:disefood/model/cart.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteHelper {
  final String nameDatabase = 'diseFoodSQLite.db';
  final String tableDatabase = 'cartTable';
  int version = 1;

  final String idColumn = 'id';
  final String shopId = 'shopId';
  final String foodId = 'foodId';
  final String foodName = 'foodName';
  final String foodQuantity = 'foodQuantity';
  final String foodDescription = 'foodDescription';

  SQLiteHelper() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), nameDatabase),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableDatabase ($idColumn INTEGER PRIMARY KEY,$shopId TEXT, $foodId INTEGER, $foodName TEXT, $foodQuantity INTEGER, $foodDescription TEXT)'),
        version: version);
  }

  Future<Database> connectedDatabase() async {
    return openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertDataToSQLite(CartModel cartModel) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        tableDatabase,
        cartModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('e insertData ===> ${e.toString()}');
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
}
