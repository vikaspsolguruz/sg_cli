import 'package:flutter/material.dart';
import 'package:newarch/_app_initializer.dart';
import 'package:newarch/app/app.dart';

Future<void> main() async {
  await initializeApp();
  runApp(const MyApp());
}
