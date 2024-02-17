import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab3/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lab3/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD_j0F3oayolKBG3ev7IiWsKouDrOg42jM",
      appId: "1:412777821654:android:fc6d26b14763c96a002077",
      messagingSenderId: "412777821654",
      projectId: "lab3-37ac1",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().user,
      child: const MaterialApp(
        home: Wrapper(),
        ),
    );
  }
}