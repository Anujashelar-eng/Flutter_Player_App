import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:player_app/view/login_screen.dart";
import "package:player_app/view/player_info.dart";
import "package:player_app/view/splash_screen.dart";

Future <void> main()async{
  await WidgetsFlutterBinding.ensureInitialized(); //It Start the Flutter Engine,It Calls Firebase Native and Native call enable/Initialize That
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBVpEvAjt064ZP9VsP8cbRp8fDXVoMnq6o",
        appId: "1:396444083685:android:7cfeee47c56d0bd1313b0c",
        messagingSenderId: "396444083685",
        projectId: "playerapp-21da9")
  );
  runApp(const MyApp()); //Dart Call Start
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home:PlayerInfo(),
    );
  }
}