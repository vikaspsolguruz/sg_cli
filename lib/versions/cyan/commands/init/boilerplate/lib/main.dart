import 'package:flutter/material.dart';
import 'package:newarch/_app_initializer.dart';
import 'package:newarch/app/app_provider.dart';

Future<void> main() async {
  await initializeApp();
  runApp(const AppProvider());
}
