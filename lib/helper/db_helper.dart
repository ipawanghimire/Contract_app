import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final pathToDatabase =
        path.join(documentsDirectory.path, 'your_database.db');

    final exists = await databaseExists(pathToDatabase);

    if (!exists) {
      // If the database does not exist, create it
      await _createDatabase(pathToDatabase);
    }

    return await openDatabase(pathToDatabase, version: 1);
  }

  Future<void> _createDatabase(String pathToDatabase) async {
    final db = await openDatabase(pathToDatabase, version: 1);
    await db.execute('''
      CREATE TABLE your_table (
        id INTEGER PRIMARY KEY,
        date TEXT,
        time TEXT,
        name TEXT,
        signature_path TEXT
      )
    ''');
  }

  Future<int> insertData(
      String date, String time, String name, Uint8List signature) async {
    final db = await database;

    // Save the signature as a file and get the file path
    final signatureFile = await _saveSignatureToFile(signature);

    return await db.insert('your_table', {
      'date': date,
      'time': time,
      'name': name,
      'signature_path': signatureFile.path,
    });
  }

  Future<File> _saveSignatureToFile(Uint8List signature) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
        '${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(signature);
    return file;
  }

  Future<bool> isDatabaseEmpty() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM your_table'));
    return count == 0;
  }
}
