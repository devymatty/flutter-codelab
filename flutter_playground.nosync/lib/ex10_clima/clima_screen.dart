import 'package:flutter/material.dart';
import 'package:flutter_playground/ex10_clima/screens/loading_screen.dart';

class ClimaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: LoadingScreen(),
    );
  }
}
