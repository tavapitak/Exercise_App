import 'package:flutter/material.dart';
import 'package:exercise_app/transaction.dart';  // นำเข้าคลาส Transaction
import 'package:exercise_app/editscreen.dart';  // นำเข้า EditScreen ที่คุณใช้สำหรับการแก้ไขรายการ
import 'package:exercise_app/editscreen.dart';  // นำเข้า EditScreen

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function(String) onDelete;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(transaction.id),  // ใช้ id เป็น String
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete(transaction.id);  // ลบรายการ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted ${transaction.name}')),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: Icon(
            transaction.type == 'Cardio' ? Icons.directions_run : Icons.fitness_center,
            color: transaction.type == 'Cardio' ? Colors.blue : Colors.green,
          ),
          title: Text(transaction.name),
          subtitle: Text('Duration: ${transaction.duration} min'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreen(
                    transactionId: transaction.id,  // ส่ง id ที่เป็น String
                    initialName: transaction.name,
                    initialDuration: transaction.duration,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
