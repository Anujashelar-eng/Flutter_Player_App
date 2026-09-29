import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  String email="";
  String userId="";
  bool isUserLoggedIn=false;

  //SET DATA
  void setSharedPreferenceData(Map<String,dynamic> MapObj)async{
    SharedPreferences sharedPreferencesObj= await SharedPreferences.getInstance();

    await sharedPreferencesObj.setString("email", MapObj["email"]);
    await sharedPreferencesObj.setString("userId", MapObj["userId"]);
    await sharedPreferencesObj.setBool("isUserLoggedIn",MapObj["isLogin"]);
  }
  //GET DATA
   Future <void> getSharedPreferenceData()async{
    SharedPreferences sharedPreferencesObj=await SharedPreferences.getInstance();
    email=sharedPreferencesObj.getString("email")?? "";
    userId=sharedPreferencesObj.getString("userId")?? "";
    isUserLoggedIn=sharedPreferencesObj.getBool("isUserLoggedIn")?? false;
   }
}