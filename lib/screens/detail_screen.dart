import 'dart:io';
import 'package:account/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_screen.dart';

class DetailScreen extends StatelessWidget {
  final Pet pet;

  DetailScreen({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => EditScreen(pet: pet),
              )).then((_) {
                // Refresh the screen after returning from EditScreen
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreen(pet: pet)),
                );
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Image.file(
            File(pet.imagePath!),
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          ListTile(
            title: Text('เจ้าของ'),
            subtitle: Text(pet.owner),
          ),
          ListTile(
            title: Text('วันที่'),
            subtitle: Text(DateFormat('dd MMM yyyy').format(pet.date)),
          ),
          ListTile(
            title: Text('สายพันธุ์'),
            subtitle: Text(pet.breed),
          ),
          ListTile(
            title: Text('อายุ'),
            subtitle: Text('${pet.age} ปี'),
          ),
          ListTile(
            title: Text('หมายเหตุ'),
            subtitle: Text(pet.notes),
          ),
        ],
      ),
    );
  }
}
