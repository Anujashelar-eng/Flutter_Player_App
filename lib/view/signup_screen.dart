import "dart:developer";

import "Package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:player_app/widgets/custom_snackbar.dart";

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("SignUp Screen"),
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
                try{
                UserCredential userCredentialObj=await _firebaseAuth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                log("user credentials: ${userCredentialObj}");
                CustomSnackBar().showCustomSnackbar(context, "login successful",bgColor: Colors.green);
                Navigator.of(context).pop();
                emailController.clear();
                passwordController.clear();
                }on FirebaseAuthException catch(error){
                  CustomSnackBar().showCustomSnackbar(context, error.message!,bgColor: Colors.red);
                }
              }else{
                CustomSnackBar().showCustomSnackbar(context, "Enter valid data",bgColor:Colors.red);
              }
            }, child: Text("Sign Up"),
            ),
            SizedBox(height:20),

          ],
        ),
      ),

    );
  }
}
