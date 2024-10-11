import 'package:account/provider/PetProvider.dart';
import 'package:account/screens/form_screen.dart'; 
import 'package:account/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return PetProvider(); // ใช้ PetProvider
        }),
      ],
      child: MaterialApp(
        title: 'สัตว์เลี้ยง',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            const HomeScreen(), 
            FormScreen(), 
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(text: "สัตว์เลี้ยง", icon: Icon(Icons.list)),
            Tab(text: "เพิ่มข้อมูล", icon: Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}
