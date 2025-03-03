import 'package:flutter/material.dart';
import 'package:exercise_app/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final String transactionId;
  final String initialName;
  final int initialDuration;

  const EditScreen({
    super.key,
    required this.transactionId,
    required this.initialName,
    required this.initialDuration,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _durationController = TextEditingController(text: widget.initialDuration.toString());
  }

  void _updateTransaction() {
    if (_formKey.currentState!.validate()) {
      // ใช้ข้อมูลใหม่ในการอัปเดต
      Provider.of<TransactionProvider>(context, listen: false).updateTransaction(
        widget.transactionId,  // ส่ง id ที่เป็น String
        _nameController.text,  // ชื่อใหม่
        int.parse(_durationController.text),  // ระยะเวลาใหม่
        'Cardio',  // ตัวอย่าง: คุณสามารถเพิ่มตัวเลือกประเภท (เช่น 'Cardio' หรือ 'Strength') ตามที่ต้องการ
      );
      Navigator.pop(context);  // กลับไปยังหน้าหลัก
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Exercise Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateTransaction,
                child: const Text('Update Exercise'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
