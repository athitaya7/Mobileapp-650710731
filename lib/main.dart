// === ไฟล์ lib/main.dart ที่แก้ไขแล้ว ===

import 'package:flutter/material.dart';
// 1. Import ไฟล์หน้าจอของคุณเข้ามาแค่ครั้งเดียว (แนะนำให้ใช้ package import)
import 'package:pm25_app/api_example/api_example.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Quality App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      // 2. กำหนดให้ home (หน้าแรก) คือ Widget ที่เรา import เข้ามา (ส่วนนี้ถูกต้องแล้ว)
      home: const ApiExample(), 
      debugShowCheckedModeBanner: false,
    );
  }
}