import 'package:flutter/material.dart';
import 'package:emotify/ModelIntegration.dart';


void main() {
  runApp(const FlutterwithML());
}

class FlutterwithML extends StatelessWidget {
  const FlutterwithML({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false
      ,home: ModelIntegration(),);
  }
}