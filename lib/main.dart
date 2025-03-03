import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exercise_app/provider/transaction_provider.dart';
import 'formscreen.dart';
import 'package:exercise_app/model/transactionitem.dart';  // นำเข้า widget ที่จะใช้

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: const ExerciseApp(),
    ),
  );
}

class ExerciseApp extends StatelessWidget {
  const ExerciseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TransactionListScreen(),
    );
  }
}

class TransactionListScreen extends StatefulWidget {
  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลการทำรายการเมื่อเริ่มต้น
    Future.delayed(Duration.zero, () {
      Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise Transactions"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormScreen()),  // นำทางไปหน้าฟอร์ม
              );
            },
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          // ตรวจสอบว่าไม่มีรายการใดๆ
          if (provider.transactions.isEmpty) {
            return const Center(child: Text("No transactions found"));
          }

          return ListView.builder(
            itemCount: provider.transactions.length,
            itemBuilder: (context, index) {
              final transaction = provider.transactions[index];
              return TransactionItem(
                transaction: transaction,
                onDelete: (id) {
                  provider.deleteTransaction(id);  // ลบรายการ
                },
              );
            },
          );
        },
      ),
    );
  }
}
