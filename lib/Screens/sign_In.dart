import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:labors/Animation/delay_animation.dart';

import 'enter_number.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  //FirebaseAuth auth = FirebaseAuth.instance;
  //String userPhone = sharedUserData.get("userPhoneNumber");
  String phoneNo;
  

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener((){
       setState((){});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    
    return Scaffold(
      
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        widthFactor: MediaQuery.of(context).size.width,
        heightFactor: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[

            SizedBox( height : 10),
            AvatarGlow(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                radius: 100.0,
                child: Text("MAZDOOR",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Signatra"),
                  ),
              ), 
              endRadius:150,
              duration: Duration(seconds: 2),
              glowColor: Colors.black,
              repeat: true,
              repeatPauseDuration: Duration(seconds: 1),
              startDelay: Duration( seconds: 1),
              ),

              SizedBox( height: 30),

              DelayedAnimation(
                child: Text("Hello, Labors  ",textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Theme.of(context).accentColor,
                  fontFamily: "Signatra"
                ),),
                delay: delayedAmount + 1000,
                ),

                SizedBox( height: 10),

                 DelayedAnimation(
                child: Text("Your Job Is Here!", textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: Theme.of(context).accentColor,
                  fontFamily: "Signatra"
                ),),
                delay: delayedAmount + 2000,),

                SizedBox( height: 20),

                DelayedAnimation(
                  child: ButtonTheme(
                      minWidth: 270.0,
                      height: 40,
                      child: RaisedButton(
                      color:Theme.of(context).accentColor,
                      textColor: Colors.white,
                      child: Text("Sign up with phone",
                      style: TextStyle(
                        fontSize: 20.0
                      ),),
                      onPressed: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EnterNumber()),
                      );
                      },
                    ),
                  ),
                    delay: delayedAmount + 3000,),
                
                // SizedBox( height: 20),

                // DelayedAnimation(
                //   child: FacebookSignInButton(
                //     onPressed: (){
                //       UserServices().initiateFacebookLogin(context);
                //       //loginWithFb(context);
                //       // //_loginWithFb(context);
                //       //  if(userPhone == null){
                        
                //     //}
                      
                      
                //     },
                //     borderRadius: 10.0,
                //   ),
                //     delay: delayedAmount + 3000,),

          ],
          )
      ),
      
    );
  }
}