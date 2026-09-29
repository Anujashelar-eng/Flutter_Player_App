import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:player_app/widgets/custom_snackbar.dart';
import 'package:player_app/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/player_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController=TextEditingController();
  final TextEditingController jerNoController=TextEditingController();
  final TextEditingController imageController=TextEditingController();

  final FirebaseFirestore _firebaseFirestoreObj=FirebaseFirestore.instance;

  //Player List
  List<PlayerModel> playerList=[];
  
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
            controller:jerNoController,
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
                jerNoController.text.trim().isNotEmpty &&
                imageController.text.trim().isNotEmpty
            ){
              //DATA
              Map<String,dynamic> obj={
                "playerName":nameController.text,
                "jerNo":jerNoController.text,
                "playerImage":imageController.text,
              };
                await _firebaseFirestoreObj.collection("PlayerData").add(obj);
                nameController.clear();
                jerNoController.clear();
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
            //Implemented Cloud Firestore database and GetX state management.
            playerList.clear(); //Local List Will get Clear and Fill newly Every time
            QuerySnapshot playerData=await _firebaseFirestoreObj.collection("PlayerData").get();

            log("Player Data:${playerData.docs.length}");

            for(int i=0;i<playerData.docs.length;i++){
              log("Player Name: ${playerData.docs[i]['playerName']}");
              log("id: ${playerData.docs[i].id}");

              PlayerModel playerModelObj=PlayerModel(playerName: playerData.docs[i]['playerName'],
                  jerNo: playerData.docs[i]['jerNo'],
                  playerImage: playerData.docs[i]['playerImage'],
                  id: playerData.docs[i].id);
              playerList.add(playerModelObj);
              log("data added");

            }//for loop
            log("Player List Length: ${playerList.length}");
            setState(() {

            });
          }, child:Text("Get Data"),),

          SizedBox(height: 20,),

          //Display Data
          ListView.builder(
            itemCount: playerList.length,
            shrinkWrap:true,
            itemBuilder:(context,index){
              return ListTile(
                leading:Image.network(playerList[index].playerImage),
                title:Text(playerList[index].playerName,style:TextStyle(fontSize: 20)),
                subtitle: Text(playerList[index].jerNo,style:TextStyle(fontSize: 20)),
                trailing: IconButton(onPressed: () async{
                  await _firebaseFirestoreObj.collection("playerData").doc(playerList[index].id).delete();

                  playerList.remove(index);
                  CustomSnackBar().showCustomSnackbar(context, "Data Deleted!",bgColor:Colors.green);
                  setState(() {

                  });
                }, icon: Icon(Icons.delete)),
                
              );
            } ,

          ),
        ],
      )
    );
  }
}
