import 'package:flutter/material.dart';
import 'package:exercise_app/transaction.dart';  // นำเข้าโมเดล Transaction
import 'package:uuid/uuid.dart';  // นำเข้า uuid เพื่อใช้สร้าง id ที่ไม่ซ้ำกัน

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  // ฟังก์ชันดึงข้อมูลรายการ
  Future<void> fetchTransactions() async {
    // จำลองการดึงข้อมูลจากฐานข้อมูล
    await Future.delayed(const Duration(seconds: 1));  // จำลองการโหลดข้อมูล
    _transactions = [
      Transaction(id: '1', name: 'Running', duration: 30, date: DateTime.now(), type: 'Cardio'),
      Transaction(id: '2', name: 'Cycling', duration: 45, date: DateTime.now(), type: 'Cardio'),
    ]; // เพิ่มรายการที่ดึงมา
    notifyListeners();
  }

  // ฟังก์ชันลบรายการ
  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }

  // ฟังก์ชันเพิ่มรายการ
  void addTransaction(String name, int duration, DateTime date, String type) {
    if (name.isEmpty || duration <= 0 || type.isEmpty) {
      return; // ไม่เพิ่มหากข้อมูลไม่สมบูรณ์
    }
    final newTransaction = Transaction(
      id: Uuid().v4(),  // ใช้ UUID เพื่อสร้าง id ที่ไม่ซ้ำกัน
      name: name,
      duration: duration,
      date: date,
      type: type,
    );
    _transactions.add(newTransaction);
    notifyListeners();
  }

  // ฟังก์ชันอัปเดตรายการ
  void updateTransaction(String id, String name, int duration, String type) {
    if (name.isEmpty || duration <= 0 || type.isEmpty) {
      return; // ไม่อัปเดตหากข้อมูลไม่สมบูรณ์
    }
    final index = _transactions.indexWhere((tx) => tx.id == id);
    if (index != -1) {
      _transactions[index] = Transaction(
        id: id,
        name: name,
        duration: duration,
        date: _transactions[index].date,  // ใช้วันที่เดิม
        type: type,  // อัปเดตประเภทการออกกำลังกาย
      );
      notifyListeners();
    }
  }
}
