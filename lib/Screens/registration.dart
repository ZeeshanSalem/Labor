import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:labors/Services/user_services.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Gvariable.dart' as global;

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber;
  String name;
  String laborImageUrl;
  String age;
  //PickedFile _profileImage;
  File _profileImage;
  String laborCategory;
  SharedPreferences sharedUserData;
  var imagePicker = ImagePicker();

  Future getImage() async {
    var image = await imagePicker.getImage(source: ImageSource.gallery);
    //var image = await ImagePicker(source: ImageSource.gallery);
    setState(() {
      _profileImage = File(image.path);
    });
  }

  Future uploadPic() async {
    String fileName = basename(_profileImage.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask task = firebaseStorageRef.putFile(_profileImage);

    StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
    var imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

    setState(() {
      global.laborImage = imageUrl.toString();
      this.laborImageUrl = imageUrl.toString();
    });
    //UserServices().addProfileImage(userImageUrl);
    // //userImageUrl = await (await task.onComplete).ref.getDownloadURL();
    // setState(() {
    //   userImageUrl = imageUrl.toString();
    // });
    //this.userImageUrl = imageUrl.toString();
  }

  _validityState() async {
    sharedUserData = await SharedPreferences.getInstance();
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (!mounted) return;
      setState(() {
        sharedUserData.setString("laborName", name);
        global.laborName = name;
        global.laborPhoneNumber = phoneNumber;
        global.laborAge = age;
        global.labortype = laborCategory;
      });
    } else {
      return "Please fill the Form Correctly";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Registration Form",
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 40.0,
                fontStyle: FontStyle.normal,
                color: Colors.black,
                //fontWeight: FontWeight.bold
              )),
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              ClipPath(
                child: Container(
                  width: double.infinity,
                  height: 300,
                  color: Theme.of(context).primaryColor,
                  child: Align(
                    alignment: Alignment.lerp(
                        Alignment.topCenter, Alignment.bottomCenter, 0.2),
                    child: Stack(children: <Widget>[
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.blue[200],
                        child: ClipOval(
                            child: SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: (_profileImage != null)
                              ? Image.file(
                                  _profileImage,
                                  fit: BoxFit.fill,
                                )
                              : Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 100,
                                ),
                        )),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 05,
                        child: ClipOval(
                          child: Material(
                            color: Colors.blue[200], // button color
                            child: InkWell(
                              splashColor: Colors.black, // inkwell color
                              child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 30,
                                  )),
                              onTap: () {
                                getImage();
                              },
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                clipper: MyClipper(),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        //style: TextStyle(),
                        //keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val.trim().length < 5 || val.isEmpty) {
                            return " Name is too Short";
                          } else if (val.trim().length > 15) {
                            return " name is too Long";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => {
                          this.name = val,
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          labelText: "Username",
                          labelStyle:
                              TextStyle(fontSize: 20.0, color: Colors.black),
                          hintText: "Please Enter Your Name",
                          hintStyle:
                              TextStyle(color: Colors.black87, fontSize: 20.0),
                          filled: true,
                          fillColor: Colors.blue[100],
                          prefixIcon: Icon(Icons.person_pin,
                              color: Colors.blue, size: 40.0),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        //style: TextStyle(),
                        validator: (val) {
                          if (val.trim().length < 11 || val.isEmpty) {
                            return " Phone Number is to short";
                          } else if (val.trim().length > 13) {
                            return " Phone Number is too Long";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => this.phoneNumber = val,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          labelText: "Phone Number",
                          labelStyle:
                              TextStyle(fontSize: 20.0, color: Colors.black),
                          hintText: "+923321991684",
                          hintStyle:
                              TextStyle(color: Colors.black87, fontSize: 20.0),
                          filled: true,
                          fillColor: Colors.blue[100],
                          prefixIcon:
                              Icon(Icons.phone, color: Colors.blue, size: 40.0),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        //style: TextStyle(),
                        validator: (val) {
                          if (val.isEmpty) {
                            return " Plese Enter age";
                          } else if (val.trim().length > 60) {
                            return " yor are old";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => this.age = val,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          labelText: "Please Enter Your Age",
                          labelStyle:
                              TextStyle(fontSize: 20.0, color: Colors.black),
                          hintText: "Must be 18 or above",
                          hintStyle:
                              TextStyle(color: Colors.black87, fontSize: 20.0),
                          filled: true,
                          fillColor: Colors.blue[100],
                          prefixIcon:
                              Icon(Icons.phone, color: Colors.blue, size: 40.0),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("All_Engineering")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              const Text("Loading.....");
                            } else {
                              List<DropdownMenuItem> category = [];
                              for (int i = 0;
                                  i < snapshot.data.documents.length;
                                  i++) {
                                DocumentSnapshot type =
                                    snapshot.data.documents[i];
                                category.add(
                                  DropdownMenuItem(
                                    child: Text(
                                      type.documentID,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    value: "${type.documentID}",
                                  ),
                                );
                              }

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                //color: Colors.blue[100],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.list,
                                      size: 40.0,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 50.0),
                                    DropdownButton(
                                      icon: Icon(Icons.arrow_drop_down_circle),
                                      iconSize: 35.0,
                                      iconEnabledColor: Colors.blue,
                                      iconDisabledColor: Colors.blue[100],
                                      items: category,
                                      onChanged: (category) {
                                        setState(() {
                                          laborCategory = category;
                                        });
                                        final snackBar = SnackBar(
                                          content: Text(
                                            'Selected Category is $laborCategory',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 20.0,
                                              //fontFamily: "Signatra"
                                            ),
                                          ),
                                        );
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                      },
                                      value: laborCategory,
                                      isExpanded: false,
                                      hint: Text(
                                        "Choose Your Category",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                      SizedBox(height: 20.0),
                      Center(
                          child: ButtonTheme(
                              height: 50.0,
                              minWidth: 250.0,
                              buttonColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: RaisedButton(
                                onPressed: () {
                                  _validityState();
                                  uploadPic()
                                      // // // .then((value) => {
                                      // // // setState(() {
                                      // // //   global.userImage = userImageUrl;
                                      // // // }),
                                      // // // print("SetState"),
                                      // // // })
                                      .then((value) => {
                                            UserServices()
                                                .addPhoneNumbertoFirestoreCollection(
                                                    context),
                                            print("UserServices")
                                          });
                                },
                                child: Text("Continue",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                                textColor: Colors.black,
                              )))
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 100);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 100,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
