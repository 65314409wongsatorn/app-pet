import 'dart:io';
import 'package:account/models/transactions.dart';
import 'package:account/provider/PetProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final Pet pet;

  EditScreen({required this.pet});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController ownerController;
  late TextEditingController breedController;
  late TextEditingController ageController;
  late TextEditingController notesController;
  late TextEditingController dateController;
  File? _image;
  final picker = ImagePicker();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.pet.name);
    ownerController = TextEditingController(text: widget.pet.owner);
    breedController = TextEditingController(text: widget.pet.breed);
    ageController = TextEditingController(text: widget.pet.age.toString());
    notesController = TextEditingController(text: widget.pet.notes);
    dateController = TextEditingController(text: widget.pet.date.toLocal().toString().split(' ')[0]);
    _image = File(widget.pet.imagePath!);
    selectedDate = widget.pet.date;
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : _image;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateController.text = picked.toLocal().toString().split(' ')[0];
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลสัตว์เลี้ยง'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
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
            TextFormField(
              decoration: const InputDecoration(labelText: 'หมายเหตุ'),
              controller: notesController,
            ),
            SizedBox(height: 10),
            _image == null
                ? Text('ยังไม่ได้เลือกภาพ')
                : Image.file(_image!),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('เปลี่ยนภาพ'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: const Text('บันทึกการแก้ไข'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  var updatedPet = Pet(
                    keyID: widget.pet.keyID,
                    name: nameController.text,
                    owner: ownerController.text,
                    breed: breedController.text,
                    age: int.tryParse(ageController.text) ?? 0,
                    notes: notesController.text,
                    date: selectedDate,
                    imagePath: _image?.path ?? widget.pet.imagePath, // ใช้ path เก่าเมื่อไม่มีภาพใหม่
                  );

                  var provider = Provider.of<PetProvider>(context, listen: false);
                  provider.updatePet(updatedPet);

                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
