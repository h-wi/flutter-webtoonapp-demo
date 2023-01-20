import 'package:flutter/material.dart';
import 'package:webtoon/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // key를 부모 클래스에 보낸다 -> 위젯을 식별하는 역할 (key = widget ID)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
