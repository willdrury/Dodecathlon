import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('initState');
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}