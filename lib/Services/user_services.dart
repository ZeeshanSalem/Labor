import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Gvariable.dart' as global;

class UserServices{
  SharedPreferences sharedUserData;

  //CurrentUser
  FirebaseUser user;

  Future<String> currentUser() async{
    user = await FirebaseAuth.instance.currentUser();
    return user != null? user.uid : null;
  }

  addPhoneNumbertoFirestoreCollection(BuildContext context) async{
    sharedUserData = await SharedPreferences.getInstance();
    String currentUserId = sharedUserData.get("currentUserId");

    Firestore.instance.collection("Labors_Info").document(currentUserId).setData({
      "laborPhoneNumber" : global.laborPhoneNumber,
      "laborId" : global.laborId,
      "laborName" : global.laborName,
      "laborImage" : global.laborImage,
      "laborAge" : global.laborAge,
      "laborType" : global.labortype,
      
    },
    merge: true,
    ).then((val){
      print("Created on database");
      //Navigator.of(context).pushReplacementNamed('/home');
      Navigator.of(context).pushReplacementNamed('/UserLocation');
    });
  }

  //add User location to Firestore
  Future userLocationStore() async{
    sharedUserData = await SharedPreferences.getInstance();
    String currentUserId = await sharedUserData.get("currentUserId");
    Firestore.instance.collection("Labors_Info").document(currentUserId).setData({
      "laborAddress" : global.laborAddress,
      "laborLatitude" : global.laborLatitude,
      "laborLongitude" : global.laborLongitude,
    },
    merge: true,
    );
  }

  //uploadProfile Pic
  // addProfileImage(String urlOfImage) async{
  //    String currentUserId = await UserID().functionUserId();
  //    Firestore.instance.collection("Users_Info").document(currentUserId).setData({
  //      "userImage" : userImage,
  //    },
  //    merge: true,
  //    ).then((value) => {
  //      print("Uploaded"),
  //    });
  // }

  //Update Profile PIC
  updateProfilePic(picUrl) async{
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;
    var auth = await FirebaseAuth.instance.currentUser(); 
    auth.updateProfile(userInfo).then((value){
      FirebaseAuth.instance.currentUser().then((user) {
        Firestore.instance.collection("Users_Info")
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((doc) {
          Firestore.instance.document("/Users_Info/${doc.documents[0].documentID}")
          .updateData({'userImage' : picUrl}).then((value) {
            print("Updated pic");
          }).catchError((onError){
            print("$onError");
          });
        })
        .catchError((e){
          print("$e");
        });
      })
      .catchError((onError){
        print("$onError");
      });
    }).catchError((onError){
      print("$onError");
    });
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  // //SignIn
  // signIn(AuthCredential authCreds) {
  //   FirebaseAuth.instance.signInWithCredential(authCreds);
  //   print("I called");
  // }

  // signInWithOTP(smsCode, verId) {
  //   AuthCredential authCreds = PhoneAuthProvider.getCredential(
  //       verificationId: verId, smsCode: smsCode);
  //   signIn(authCreds);
  // }

  // facebook authentication
  final FirebaseAuth auth = FirebaseAuth.instance;
  
}