import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:account/models/transactions.dart';

class TransactionDB {
  String dbName;

  TransactionDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertDatabase(Transactions statement) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    var keyID = store.add(db, {
      "title": statement.title,
      "owner": statement.owner, // เพิ่มฟิลด์เจ้าของ
      "breed": statement.breed, // เพิ่มฟิลด์สายพันธุ์
      "amount": statement.amount,
      "date": statement.date.toIso8601String(),
      "imagePath": statement.imagePath // เพิ่มฟิลด์ที่อยู่ไฟล์ภาพ
    });
    db.close();
    return keyID;
  }

 Future<List<Transactions>> loadAllData() async {
  var db = await openDatabase();
  var store = intMapStoreFactory.store('expense');
  var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder(Field.key, false)]));
  List<Transactions> transactions = [];
  for (var record in snapshot) {
    transactions.add(Transactions(
      keyID: record.key.toString(),
      title: record['title'].toString(),
      owner: record['owner'].toString(),
      breed: record['breed'].toString(),
      amount: double.parse(record['amount'].toString()),
      date: DateTime.parse(record['date'].toString()),
      imagePath: record['imagePath'] != null ? record['imagePath'] as String : null, // ตรวจสอบค่า
    ));
  }
  return transactions;
}


  Future<void> deleteDatabase(int? index) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');
    await store.delete(db, finder: Finder(filter: Filter.equals(Field.key, index)));
  }
}
