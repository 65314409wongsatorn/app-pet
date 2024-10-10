import 'dart:io';
import 'package:account/models/transactions.dart'; // แก้ไขให้ตรงกับโมเดลของคุณ
import 'package:account/provider/PetProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // เพิ่มการนำเข้าตัวนี้
import '../main.dart';

class FormScreen extends StatefulWidget {
  FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ownerController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final notesController = TextEditingController();
  final dateController = TextEditingController(); // เพิ่ม controller สำหรับวันที่
  File? _image;
  final picker = ImagePicker();
  DateTime selectedDate = DateTime.now(); // กำหนดวันที่เริ่มต้น

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd MMM yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มข้อมูลสัตว์เลี้ยง'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ชื่อสัตว์เลี้ยง
              TextFormField(
                decoration: const InputDecoration(labelText: 'ชื่อสัตว์เลี้ยง'),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อสัตว์เลี้ยง';
                  }
                  return null;
                },
              ),
              // เจ้าของ
              TextFormField(
                decoration: const InputDecoration(labelText: 'ชื่อเจ้าของ'),
                controller: ownerController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อเจ้าของ';
                  }
                  return null;
                },
              ),
              // สายพันธุ์
              TextFormField(
                decoration: const InputDecoration(labelText: 'สายพันธุ์'),
                controller: breedController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกสายพันธุ์';
                  }
                  return null;
                },
              ),
              // อายุ
              TextFormField(
                decoration: const InputDecoration(labelText: 'อายุ (ปี)'),
                controller: ageController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกอายุ';
                  }
                  return null;
                },
              ),
              // วันที่
              TextFormField(
                decoration: const InputDecoration(labelText: 'วันที่'),
                controller: dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกวันที่';
                  }
                  return null;
                },
              ),
              // หมายเหตุ
              TextFormField(
                decoration: const InputDecoration(labelText: 'หมายเหตุ'),
                controller: notesController,
              ),
              // รูปภาพ
              SizedBox(height: 10),
              _image == null ? const Text('ยังไม่ได้เลือกภาพ') : Image.file(_image!),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('เลือกภาพ'),
              ),
              SizedBox(height: 20),
              // ปุ่มบันทึก
              ElevatedButton(
                child: const Text('บันทึก'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (_image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('กรุณาเลือกภาพ')),
                      );
                      return;
                    }
                    var pet = Pet(
                      keyID: null,
                      name: nameController.text,
                      owner: ownerController.text,
                      breed: breedController.text,
                      age: int.tryParse(ageController.text) ?? 0,
                      notes: notesController.text,
                      imagePath: _image!.path,
                      date: selectedDate, // เพิ่มวันที่ที่เลือก
                    );

                    var provider = Provider.of<PetProvider>(context, listen: false);
                    provider.addPet(pet);

                    // นำทางกลับไปยังหน้าแรกของแอพ
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
