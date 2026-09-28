import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:player_app/custom_snackbar.dart';
import 'package:player_app/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController=TextEditingController();
  final TextEditingController jerseyController=TextEditingController();
  final TextEditingController imageController=TextEditingController();

  final FirebaseFirestore _firebaseFirestoreObj=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Home Screen"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon:Icon(Icons.logout),
            onPressed: () async {
              FirebaseAuth.instance.signOut();

              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context)=>LoginScreen()),
                      (route)=>false //Remove all previous screens from the stack//Remove keyboard
              );
            },
          )
        ]
      ),
      body:Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Player Name",
            ),
          ),
          SizedBox(height:20),
          TextField(
            controller:jerseyController,
            keyboardType:TextInputType.number,
            decoration: InputDecoration(
              hintText: "Jersey Number",
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller:imageController,
            decoration: InputDecoration(
              hintText:"Player Image",
            ),
          ),
          SizedBox(height:20),
          ElevatedButton(onPressed: () async{
            FocusScope.of(context).unfocus(); //keyboard down for snackbar
            if(nameController.text.trim().isNotEmpty &&
                jerseyController.text.trim().isNotEmpty &&
                imageController.text.trim().isNotEmpty
            ){
              //DATA
              Map<String,dynamic> obj={
                "playerName":nameController.text,
                "jerNo":jerseyController.text,
                "playerImage":imageController.text,
              };
                await _firebaseFirestoreObj.collection("PlayerData").add(obj);
                nameController.clear();
                jerseyController.clear();
                imageController.clear();
                CustomSnackBar().showCustomSnackbar(context, "Data added successfully",bgColor: Colors.green);
                setState(() {
                });


            }else{
              CustomSnackBar().showCustomSnackbar(context, "Enters Valid data",bgColor: Colors.red);
            }
          }, child: Text("Add Data"),),
          SizedBox(height:20),
          ElevatedButton(onPressed: ()async{
            QuerySnapshot playerData=await _firebaseFirestoreObj.collection("PlayerData").get();

            log("Player Data:${playerData.docs.length}");

            for(int i=0;i<playerData.docs.length;i++){
              log("Player Name: ${playerData.docs[i].id}");
            }
          }, child:Text("Get Data")),

          SizedBox(height: 20,),

          //Display Data
          ListView.builder(
            itemCount: 10,
            shrinkWrap:true,
            itemBuilder:(context,index){
              return Container();
            } ,

          ),
        ],
      )
    );
  }
}
