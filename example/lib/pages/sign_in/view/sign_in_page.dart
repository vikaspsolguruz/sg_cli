import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SignIn Page')),
      body: Center(child: Text('Welcome to SignIn Page!')),
    );
  }
}
