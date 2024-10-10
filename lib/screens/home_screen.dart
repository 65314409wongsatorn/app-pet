import 'dart:io';
import 'package:account/provider/PetProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("สัตว์เลี้ยง"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: Consumer<PetProvider>( // เปลี่ยนเป็น PetProvider
        builder: (context, provider, child) {
          if (provider.pets.isEmpty) { // เปลี่ยนเป็น pets
            return const Center(
              child: Text('ไม่มีรายการสัตว์เลี้ยง'),
            );
          } else {
            return ListView.builder(
              itemCount: provider.pets.length, // เปลี่ยนเป็น pets
              itemBuilder: (context, index) {
                var pet = provider.pets[index]; // เปลี่ยนเป็น pet
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    title: Text(pet.name), // ใช้ชื่อสัตว์เลี้ยง
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('dd MMM yyyy').format(pet.date)), // แสดงวันที่
                        Text('เจ้าของ: ${pet.owner}'), // แสดงชื่อเจ้าของ
                        Text('สายพันธุ์: ${pet.breed}'), // แสดงสายพันธุ์
                      ],
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: pet.imagePath != null 
                          ? FileImage(File(pet.imagePath!)) 
                          : null, // แสดงรูปภาพถ้ามี
                      child: pet.imagePath == null 
                          ? const Icon(Icons.pets) // แสดงไอคอนถ้าไม่มีรูป
                          : null,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        provider.deletePet(pet.keyID as int?); // ใช้ deletePet
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
