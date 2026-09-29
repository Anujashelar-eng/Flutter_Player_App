import 'package:flutter/material.dart';
import 'package:player_app/view/home_screen.dart';
import 'package:player_app/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //final prefs=SharedPreferences.getInstance();


  @override
  void initState() {
    super.initState();
    navigateToScreen();
  }

  void navigateToScreen() async{
    final prefs = await SharedPreferences.getInstance();
    bool isLogin=prefs.getBool("isLogin")?? false; //if the Value is null then use Default Value False
    print("isLogin: $isLogin"); // Debug
    Future.delayed(const Duration(seconds: 3), () {
    }
    );
    if (!mounted) return;
    if(isLogin){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context)=>HomeScreen()),
      );
    }else{
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginScreen()));
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/virat_Splash.jpg"),
      ),
    );
  }
}