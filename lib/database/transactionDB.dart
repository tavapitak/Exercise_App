import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Transaction {
  final int? id;
  final String name;
  final int duration;
  final DateTime date;
  final String type;

  Transaction({
    this.id,
    required this.name,
    required this.duration,
    required this.date,
    required this.type,
  });

  // แปลงจาก Transaction เป็น Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'date': date.toIso8601String(),  // แปลง DateTime เป็น String
      'type': type,
    };
  }

  // แปลงจาก Map เป็น Transaction
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      name: map['name'],
      duration: map['duration'],
      date: DateTime.parse(map['date']),
      type: map['type'],
    );
  }
}

class TransactionDB {
  static Database? _database;

  // สร้างการเชื่อมต่อกับฐานข้อมูล
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // ฟังก์ชันสำหรับการสร้างฐานข้อมูล
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'exercise.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            duration INTEGER,
            date TEXT,
            type TEXT
          )
        ''');
      },
    );
  }

  // ฟังก์ชันสำหรับการเพิ่มข้อมูลการออกกำลังกาย
  static Future<void> insertTransaction(Transaction transaction) async {
    final db = await database;
    try {
      await db.insert(
        'transactions',
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting transaction: $e");
    }
  }

  // ฟังก์ชันสำหรับการดึงข้อมูลการออกกำลังกายทั้งหมด
  static Future<List<Transaction>> getTransactions() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('transactions');

      return List.generate(maps.length, (i) {
        return Transaction.fromMap(maps[i]);  // ใช้ factory constructor
      });
    } catch (e) {
      print("Error fetching transactions: $e");
      return [];
    }
  }

  // ฟังก์ชันสำหรับการลบข้อมูลการออกกำลังกาย
  static Future<void> deleteTransaction(int id) async {
    final db = await database;
    try {
      await db.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting transaction: $e");
    }
  }

  // ฟังก์ชันสำหรับการอัพเดตข้อมูลการออกกำลังกาย
  static Future<void> updateTransaction(Transaction transaction) async {
    final db = await database;
    try {
      await db.update(
        'transactions',
        transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
    } catch (e) {
      print("Error updating transaction: $e");
    }
  }
}
