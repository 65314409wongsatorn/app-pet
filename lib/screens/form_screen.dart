import 'dart:io';
import 'package:account/main.dart';
import 'package:account/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';

class FormScreen extends StatefulWidget {
  FormScreen({super.key});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final ownerController = TextEditingController();
  final breedController = TextEditingController();
  final amountController = TextEditingController();
  XFile? imageFile;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แบบฟอร์มข้อมูล'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'ชื่อสัตว์เลี้ยง',
              ),
              controller: titleController,
              validator: (String? str) {
                if (str!.isEmpty) {
                  return 'กรุณากรอกข้อมูล';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'ชื่อเจ้าของ',
              ),
              controller: ownerController,
              validator: (String? str) {
                if (str!.isEmpty) {
                  return 'กรุณากรอกข้อมูล';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'สายพันธุ์',
              ),
              controller: breedController,
              validator: (String? str) {
                if (str!.isEmpty) {
                  return 'กรุณากรอกข้อมูล';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('เลือกภาพสัตว์เลี้ยง'),
            ),
            if (imageFile != null)
              Image.file(File(imageFile!.path)),
            TextButton(
              child: const Text('บันทึก'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (imageFile == null) {
                    // แสดงข้อความเตือนหากไม่ได้เลือกภาพ
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('กรุณาเลือกภาพสัตว์เลี้ยง')),
                    );
                    return;
                  }
                  
                  var statement = Transactions(
                    keyID: null,
                    title: titleController.text,
                    owner: ownerController.text,
                    breed: breedController.text,
                    amount: double.parse(amountController.text),
                    date: DateTime.now(),
                    imagePath: imageFile!.path, // ใช้ path จาก imageFile
                  );

                  var provider = Provider.of<TransactionProvider>(context, listen: false);
                  provider.addTransaction(statement);

                  Navigator.push(context, MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return const MyHomePage();
                    },
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
