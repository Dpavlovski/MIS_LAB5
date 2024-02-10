import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab3/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:lab3/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    // return either the Home or Authenticate widget
    return user != null ? Home() : const Authenticate();

  }
}