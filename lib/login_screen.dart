import "dart:developer";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:player_app/home_screen.dart";
import "package:player_app/signup_screen.dart";
import "package:shared_preferences/shared_preferences.dart";

import "custom_snackbar.dart";
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Login Screen"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login",style:TextStyle(fontSize: 40)),
            SizedBox(height: 30,),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height:30),
            TextField(
              controller:passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                border:OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30,),

            ElevatedButton(onPressed: ()async{

              if(emailController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty){
                try {
                  UserCredential userCredential = await _firebaseAuth
                      .signInWithEmailAndPassword(email: emailController.text,
                      password: passwordController.text);
                  log("${userCredential.user}");
                  log("${userCredential.user!.uid}");
                  final prefs = await SharedPreferences.getInstance();

                  await prefs.setBool("isLogin",true);
                  await prefs.setString("uid", userCredential.user!.uid);
                  await prefs.setString("email", userCredential.user!.email!);
                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));

                }on FirebaseAuthException catch(error){
                  CustomSnackBar().showCustomSnackbar(context, error.message!,bgColor: Colors.red);
                }
              }else{
                CustomSnackBar().showCustomSnackbar(context, "Enter valid data",bgColor:Colors.red);
              }
            }, child: Text("Login")),
            SizedBox(height:20),
            TextButton(onPressed: (){
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context){
                return SignupScreen();
              }));
            },child: Text("New User? Sign Up",style:TextStyle(fontSize: 15)),)
          ],
        ),
      ),

    );
  }
}
