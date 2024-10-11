import 'dart:io';
import 'package:account/provider/PetProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'edit_pet_screen.dart'; 

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
        backgroundColor: const Color.fromARGB(255, 225, 234, 142),
        title: const Text("MyPet"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: Consumer<PetProvider>(
        builder: (context, provider, child) {
          if (provider.pets.isEmpty) {
            return const Center(
              child: Text('ไม่มีรายการสัตว์เลี้ยง', style: TextStyle(fontSize: 20)),
            );
          } else {
            return ListView.builder(
              itemCount: provider.pets.length,
              itemBuilder: (context, index) {
                var pet = provider.pets[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      pet.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd MMM yyyy').format(pet.date),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text('เจ้าของ: ${pet.owner}', style: TextStyle(color: Colors.grey[800])),
                        const SizedBox(height: 2),
                        Text('สายพันธุ์: ${pet.breed}', style: TextStyle(color: Colors.grey[800])),
                      ],
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: pet.imagePath != null 
                          ? FileImage(File(pet.imagePath!)) 
                          : null,
                      child: pet.imagePath == null 
                          ? const Icon(Icons.pets, size: 30) 
                          : null,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // เปิดหน้าแก้ไข
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPetScreen(pet: pet),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('ยืนยันการลบ'),
                                  content: const Text('คุณต้องการลบสัตว์เลี้ยงนี้หรือไม่?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('ยกเลิก'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        provider.deletePet(pet.keyID as int?);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('ยืนยัน'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
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
