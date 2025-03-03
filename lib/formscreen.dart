import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exercise_app/provider/transaction_provider.dart';
import 'package:exercise_app/transaction.dart';  // ใช้โมเดล Transaction
import 'package:intl/intl.dart';  // ใช้เพื่อจัดการการแสดงผลวันที่

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedType = 'Cardio';  // ค่าเริ่มต้น
  DateTime _selectedDate = DateTime.now();

  // ฟังก์ชันเลือกวันที่
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // ฟังก์ชันบันทึกข้อมูล
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // ดึงค่าจากฟอร์ม
      final name = _nameController.text;
      final duration = int.parse(_durationController.text);

      // ใช้ Provider เพื่อเพิ่มรายการ
      Provider.of<TransactionProvider>(context, listen: false).addTransaction(
        name,
        duration,
        _selectedDate,
        _selectedType,
      );

      Navigator.pop(context);  // กลับไปที่หน้าหลักหลังจากบันทึก
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ฟอร์มกรอกชื่อ
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Exercise Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the exercise name';
                  }
                  return null;
                },
              ),
              
              // ฟอร์มกรอกระยะเวลา
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              
              // ปุ่มเลือกวันที่
              Row(
                children: [
                  Text("Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              
              // Dropdown สำหรับเลือกประเภทการออกกำลังกาย
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Exercise Type'),
                items: ['Cardio', 'Strength'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an exercise type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ปุ่มบันทึก
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Exercise'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
