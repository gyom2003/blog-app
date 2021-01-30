import 'package:flutter/material.dart';


//class InheritedWidget
class InheritWidgetData extends InheritedWidget {
  final String inheritDescription = "Une description";
  final String inheritSeudo = "Pseudo"; 

  InheritWidgetData({Widget child, Key key}): super(child: child, key: key); 


   static InheritWidgetData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritWidgetData>(); 
  }

  @override 
  bool updateShouldNotify(InheritWidgetData oldWidget) {
    return true; //return true
  }

 
}