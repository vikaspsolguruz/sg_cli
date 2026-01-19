import 'package:flutter/material.dart';
import 'package:max_arch/_app_initializer.dart';
import 'package:max_arch/app/app.dart';

Future<void> main() async {
  await initializeApp();
  runApp(const MyApp());
}
