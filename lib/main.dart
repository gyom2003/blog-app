
import 'package:flutter/material.dart';
import 'package:blog_flutter_prototype/Home.dart';
//import 'package:device_preview/device_preview.dart';

void main() {
  runApp(MyApp());
  //ClassBuilder.registerClasses(); 
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Blog Prototype',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), 
      home: DrawerPage(), //HomePageWidget(), 
    );
  }
}
