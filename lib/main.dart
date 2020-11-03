import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';

void main() async {
  // these 2 lines
  WidgetsFlutterBinding
      .ensureInitialized(); //ติดตั้ง pugin หน้า pubspec.yaml ที่ชื่อ  firebase_core: ^0.5.0+1 firebase_auth: ^0.18.1+2
  await Firebase.initializeApp(); //                   ก่อนค่อยใส่ 2 บรรทัดนี้
  //
  runApp(MyApp());
}

//class ตัวนี้ดึง widget ที่มาจาก home มาแสดง
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      title: 'Get&Give Blood',
      home: Login(), //เริ่มต้นRun
    );
  }
}
