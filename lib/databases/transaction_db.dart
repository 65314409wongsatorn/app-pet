import 'dart:io';
import 'package:account/models/transactions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class PetDB {
  final String dbName;

  PetDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    return await dbFactory.openDatabase(dbLocation);
  }

  Future<int> insertPet(Pet pet) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('pets');

    var keyID = await store.add(db, {
      "name": pet.name,
      "owner": pet.owner, // ฟิลด์เจ้าของ
      "breed": pet.breed, // ฟิลด์สายพันธุ์
      "date": pet.date.toIso8601String(),
      "imagePath": pet.imagePath // ฟิลด์ที่อยู่ไฟล์ภาพ
    });
    await db.close(); // ปิดการเชื่อมต่อกับฐานข้อมูล
    return keyID;
  }

  Future<List<Pet>> loadAllPets() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('pets');
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder(Field.key, false)]));

    List<Pet> pets = [];
    for (var record in snapshot) {
      pets.add(Pet(
        keyID: record.key,
        name: record['name'].toString(),
        owner: record['owner'].toString(),
        breed: record['breed'].toString(),
        date: DateTime.parse(record['date'].toString()),
        imagePath: record['imagePath'] != null
            ? record['imagePath'].toString()
            : null, // ตรวจสอบค่า
        age: record['age'] != null
            ? record['age'] as int
            : 0, // ตรวจสอบค่าและแปลงเป็น int
        notes: record['notes'] != null
            ? record['notes'].toString()
            : '', // ตรวจสอบค่า
      ));
    }
    await db.close(); // ปิดการเชื่อมต่อกับฐานข้อมูล
    return pets;
  }

  Future<void> deletePet(int? index) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('pets');
    await store.delete(db,
        finder: Finder(filter: Filter.equals(Field.key, index)));
    await db.close(); // ปิดการเชื่อมต่อกับฐานข้อมูล
  }
}
