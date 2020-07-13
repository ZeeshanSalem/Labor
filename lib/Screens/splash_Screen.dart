import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:labors/Screens/showAddress.dart';
import 'package:labors/Screens/sign_In.dart';
import 'package:labors/Services/user_services.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  UserServices user;

  // Splash Screen Duration Method
  startTime() async{
    var _duration = Duration( seconds: 3);
    return Timer(_duration, navigatePage );
  }
  
  // //Check Login Status
  // loginStatus() async{
  //   sharedUserData = await SharedPreferences.getInstance();
  //   String currentID = sharedUserData.get("currentUserId");
  //   if(currentID != null){
  //     Navigator.of(context).pushReplacementNamed('/home');
  //   } else{
  //     Navigator.of(context).pushReplacementNamed('/SignIn');
  //   }
  // }

  // Navigator Method
  void navigatePage() async{
    // FirebaseUser user = await FirebaseAuth.instance.currentUser();

    // if( user != null){
    //      Navigator.pushAndRemoveUntil(context,
    //       MaterialPageRoute(builder: (context) => HomeScreen()),
    //        (Route<dynamic> route) => false);
    //    } else {
    //      Navigator.pushAndRemoveUntil(context,
    //       MaterialPageRoute(builder: (context) => SignIn()),
    //        (Route<dynamic> route) => false);
    //    }
    // // user.currentUser().then((user){
    //   if( user != null){
    //      Navigator.pushAndRemoveUntil(context,
    //       MaterialPageRoute(builder: (context) => HomeScreen()),
    //        (Route<dynamic> route) => false);
    //    } else {
    //      Navigator.pushAndRemoveUntil(context,
    //       MaterialPageRoute(builder: (context) => SignIn()),
    //        (Route<dynamic> route) => false);
    //    }
    // });


    
     auth.currentUser().then((user){
       if( user != null){
         Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => UserLocation()),
           (Route<dynamic> route) => false);
       } else {
         Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => SignIn()),
           (Route<dynamic> route) => false);
       }
     });
    //Navigator.of(context).pushReplacementNamed('/home');
  }

  //Check Network Connectivity 
  _checkInternetConnectivity() async{
    var result = await  Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      _showDialog('NO INTERNET', 'Please check your network');
    } else {
      startTime();
    }
  }

  //Dialog
  _showDialog(title, text){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: Text("Ok"))
          ],
        );
      }
      );
  }

  @override
  void initState() {
    _checkInternetConnectivity();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Stack(
        
        fit: StackFit.expand,
        children: <Widget>[  
          // Container(
          //   decoration: BoxDecoration(
          //     shape: BoxShape.rectangle,
          //     image: DecorationImage(
          //       image: AssetImage("assets/images/mazdoor3.jpg"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 100.0,
                  child: Text("Mazdoor", 
                  style:TextStyle(
                    color: Colors.white,
                    fontFamily: "Signatra",
                    fontSize: 60.0)),
                ),
                Padding(padding: EdgeInsets.only(top:10.0),),
                CircularProgressIndicator(
                  backgroundColor: Colors.lightGreenAccent,
                )
                
              ] 
            ),
            //child:Text("MAZDOOR", style: TextStyle( fontSize: 50.0,fontFamily: "Signatra", color: Colors.yellow))
          )
        ],
      ),
    );
  }
}