import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:labors/Services/user_id.dart';
import 'package:labors/Shared_Widget/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Gvariable.dart' as global;

class EnterNumber extends StatefulWidget {
  @override
  _EnterNumberState createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  String phoneNo;
  String smsCode;
  String verificationId;
  bool codeSent;

  pushMessagingToken() async {
    String currentUserId = await UserID().functionUserId();
    print(currentUserId);

    _firebaseMessaging.getToken().then((token) => {
          print("your token is $token"),
          setState(() {
            global.laborToken = token;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: Form(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Text.rich(TextSpan(
                text: "Enter Your Mobile Number",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.5,
                ))),
            SizedBox(height: 5.0),
            Padding(
              padding: EdgeInsets.only(top: 5.0, left: 20.0),
              child: Text(
                "Enter your mobile number,to create account or login",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0, left: 15.0, right: 20.0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "+92 3xx xxxxxxx",
                  icon: Icon(Icons.phone),
                ),
                onChanged: (value) {
                  if (!mounted) return;
                  setState(() {
                    this.phoneNo = value;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10.5),
              child: ButtonTheme(
                minWidth: 300.5,
                height: 40.5,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.5,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    verifyPhone().then((value) => pushMessagingToken());
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print("Verified : " + phoneAuthCredential.toString());
            signIn(phoneAuthCredential);
            //RNavigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen()),);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      print(e);
      //handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsCode = value;
                  },
                ),
                // (errorMessage != ''
                //     ? Text(
                //         errorMessage,
                //         style: TextStyle(color: Colors.red),
                //       )
                //     : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      //Navigator.of(context).pushReplacementNamed('/home');
                      Navigator.of(context)
                          .pushReplacementNamed('/UserLocation');
                    } else {
                      signInWithOTP(smsCode, verificationId);
                      //signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn(AuthCredential credential) async {
    global.sharedUserData = await SharedPreferences.getInstance();
    try {
      AuthResult authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      print(" Cureent user $currentUser");
      print("I am here");
      if (authResult.additionalUserInfo.isNewUser) {
        if (!mounted) return;
        setState(() {
          global.laborId = user.uid;
          global.laborPhoneNumber = this.phoneNo;
          global.sharedUserData.setString("currentUserId", user.uid);
        });
        // Firestore.instance.collection("Users_Info").document(user.uid).setData({
        //   "userPhone": userPhoneNumber,
        //   "userId": userId,
        // });

        //UserServices().addPhoneNumbertoFirestoreCollection(context);
        print("Created");
        Navigator.of(context).pushReplacementNamed('/Registration');
      } else {
        print("Out");
        Navigator.of(context).pop();
        //Navigator.of(context).pushReplacementNamed('/home');
        Navigator.of(context).pushReplacementNamed('/UserLocation');
      }
    } catch (e) {
      print(e);
      //handleError(e);
    }
  }

// old otp
  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    print("otp");
    signIn(authCreds);
  }
}
