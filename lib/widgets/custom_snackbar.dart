import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSnackBar{
  showCustomSnackbar(BuildContext context,String message,{Color bgColor=Colors.green}){
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content:Text(message),backgroundColor: bgColor,),
  );
  }
}