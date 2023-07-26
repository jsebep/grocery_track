import 'package:path/path.dart';
import 'package:grocery_track/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';


class DatabaseHelper{
  static const _databaseName = 'ShoppingList.db';
  static const _databaseVersion = 1;
  static const productTable = 'Product';
  static const productId = 'ProductId';

  
  static late BriteDatabase _streamDatabase;

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static var lock = Lock();

  // only have a single app-wide reference to the database
  static Database? _database;
  

  Future _onCreate(Database db, int version ) async {
    await db.execute('''
      CREATE TABLE $productTable(
        $productId INTEGER PRIMARY KEY,
        label TEXT,
        image TEXT,
        totalPrice REAL,
        totalDiscount REAL
        totalWeight REAL
      )

      ''');
  }

  Future <Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(
      documentsDirectory.path,
      _databaseName,
    );
    Sqflite.setDebugModeOn(true);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future <Database> get database async{
    if (_database != null) return _database!;

    await lock.synchronized(() async {
      if(_database == null){
        _database = await _initDatabase();
        _streamDatabase = BriteDatabase(_database!);
      }
    });
    return _database!;
  }

  Future <BriteDatabase> get streamDatabase async {
    await database;
    return _streamDatabase;
  }

  List <Product> parseProducts(List<Map<String, dynamic>> productList){
    final products = <Product>[];

    for(final productMap in productList){
      final product = Product.fromJson(productMap);
      products.add(product);
    }
    return products;
  }

  Future <List<Product>> findAllRecipes() async {
    final db = await instance.streamDatabase;
    final productList = await db.query(productTable);
    final products = parseProducts(productList);

    return products;
  }

  Stream <List<Product>> watchAllProducts() async*{
    final db = await instance.streamDatabase;

    yield* db.createQuery(productTable).mapToList((row) => Product.fromJson(row));
  }

  Future <Product> findProductByName(String name)async{
    final db = await instance.streamDatabase;
    final productList = await db.query(productTable, where: 'label = $name');
    final products = parseProducts(productList);

    return products.first;
  }

  Future <int> insert(String table, Map<String, dynamic> row) async{
    final db = await instance.streamDatabase;
    
    return db.insert(table, row);
  }

  Future <int> insertProduct(Product product){
    return insert(productTable, product.toJson());
  }

  Future <int> _delete(String table, String columnId, int id) async{
    final db = await instance.streamDatabase;
    
    return db.delete(table, where:'$columnId = ?', whereArgs: [id]);
  }

  Future <int> deleteProduct(Product product) async{
    if(product.id != null){
      return _delete(productTable, productId, product.id!);
    } 
    else{
      return Future.value(-1);
    }
  }

}