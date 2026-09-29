import "dart:developer";
import "dart:io";

import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:player_app/widgets/custom_snackbar.dart";
class PlayerInfo extends StatefulWidget {
  const PlayerInfo({super.key});

  @override
  State<PlayerInfo> createState() => _PlayerInfoState();
}

class _PlayerInfoState extends State<PlayerInfo> {
  TextEditingController playerController=TextEditingController();
  TextEditingController jerNoController=TextEditingController();

  //IMAGE PICKER
  ImagePicker imagePicker=ImagePicker();
  XFile? selectedImageFile;

  //FIREBASE STORAGE
  FirebaseStorage firebaseStorageObj=FirebaseStorage.instance;

 //Flag
  bool isLoding=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:AppBar(
        title:Text("Player Info"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body:Padding(
        padding: EdgeInsets.all(10),
        child:Column(
        children: [
          //Player Image
          GestureDetector(
            onTap:()async{
              selectedImageFile=await imagePicker.pickImage(source: ImageSource.gallery);
              log("Selected Image:${selectedImageFile?.path}");
              setState(() {

              },);
            },
            child:ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(50),
              child:(selectedImageFile==null)? Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyzgHGldRmy6F7rY2C5appVqQsqtlynZRWGn3kpO--7w&s=10",
                width:90,
                height:90,
                fit:BoxFit.cover,
              )//Image.network
              :Image.file(
                File(selectedImageFile!.path),
                height:90,
                width:90,
                fit:BoxFit.cover,
              ),
            ),
          ),


          //Player Name
          TextField(
            controller:playerController,
            decoration:InputDecoration(
            hintText:"Player Name",
          ),),
          SizedBox(height:20),
          //Player Jersey Number
          TextField(
            controller:jerNoController,
            decoration:InputDecoration(
              hintText:"Jersey Number"
            ),
          ),
          SizedBox(height:20),

         ElevatedButton(onPressed: ()async{
           FocusScope.of(context).unfocus();
          if(playerController.text.trim().isNotEmpty && jerNoController.text.trim().isNotEmpty &&selectedImageFile!=null){
            log("Player Name:${playerController.text}");
            log("jersey Name:${jerNoController.text}");
            log("image Link:${selectedImageFile!.path}");
            isLoding=true;
            setState(() {  //call the build //tree build//Object create again

            });
            //Upload Image To Storage
            //abc ==>Image name //Same name replace image
            String filename=selectedImageFile!.name+ DateTime.now().toString(); //two uplaod the image ==>unique file name

            await firebaseStorageObj.ref().child("abc").putFile(File(selectedImageFile!.path));


            //Download Image From Storage (url)


            //Store DATA To DATABASE

            //GET DATA FROM DATABASE

          }else{
            CustomSnackBar().showCustomSnackbar(context,"Please Provide valid data",bgColor: Colors.red);

          }
         }, child:(isLoding)?CircularProgressIndicator(color:Colors.black): Text("Save Data")),


        ],
      ),),
    );
  }
  Future<void> uploadImage({required String filename})async{
    await firebaseStorageObj.ref().child("abc").putFile(File(selectedImageFile!.path));
  }
}

