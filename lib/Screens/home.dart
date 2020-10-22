import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:labors/Services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Gvariable.dart' as global;

class CustomMap extends StatefulWidget {
  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  SharedPreferences sharedUserData;
  String phoneNumber;
  String uid;
  void callNumber(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'could not call $phoneNumber';
    }
  }

  getUid() async {
    sharedUserData = await SharedPreferences.getInstance();
    setState(() {
      uid = sharedUserData.get("currentUserId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance
              .collection("Accepted Request")
              .where("laborId", isEqualTo: uid)
              .snapshots(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot allUser = snapshot.data.documents[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Color(0xFFFBDC2A),
                    elevation: 10.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            radius: 50.0,
                            backgroundColor: Colors.blueGrey,
                            child: ClipOval(
                              child: SizedBox(
                                width: 60.0,
                                height: 100.0,
                                child: Image.network(
                                  allUser["userImage"],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            allUser["userName"],
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            allUser["userPhone"],
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          isThreeLine: true,
                          //dense: true,
                        ),
                        ButtonBar(
                          children: <Widget>[
                            Ink(
                              decoration: const ShapeDecoration(
                                shape: CircleBorder(),
                                color: Colors.blue,
                              ),
                              child: IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.message),
                                onPressed: () async {
                                  setState(() {
                                    phoneNumber = "sms:" + allUser["userPhone"];
                                  });
                                  callNumber(phoneNumber);
                                },
                              ),
                            ),
                            Ink(
                              decoration: const ShapeDecoration(
                                shape: CircleBorder(),
                                color: Colors.blue,
                              ),
                              child: IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.call),
                                onPressed: () async {
                                  setState(() {
                                    phoneNumber =
                                        "tel://" + allUser["userPhone"];
                                  });
                                  callNumber(phoneNumber);
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            }
            return CircularProgressIndicator(
              backgroundColor: Colors.blue,
            );
          }),
    );
  }
}

// Stack(
//       children: <Widget>[

//         Center(
//           child: Container(
//             child: RaisedButton(
//               onPressed: () {
//                 UserServices().signOut();
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                     '/SignIn', (Route<dynamic> route) => false);
//               },
//               color: Colors.yellow,
//               child: Text("SignOut"),
//             ),
//           ),
//         )
//       ],
//     );

//........................................................................//

// For getting device Location
// Geolocator geolocator;
// Position positions;
// StreamSubscription _positioStream;

// // Google Map
// GoogleMapController mapController;
// //Placemark place;
// static LatLng initialPosition;
// LatLng lastPosition = initialPosition;
// String presentAddress;
// List<Placemark> placemark;

// Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

// // method get position
// void _getlocation() {
//   geolocator = Geolocator()..forceAndroidLocationManager;
//   LocationOptions locationOptions =
//       LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
//   _positioStream = geolocator
//       .getPositionStream(locationOptions)
//       .listen((Position position) async {
//     placemark = await geolocator.placemarkFromCoordinates(
//         position.latitude, position.longitude);
//     setState(() {
//       positions = position;
//       initialPosition = LatLng(positions.latitude, positions.longitude);

//       presentAddress = placemark[0].name.toString() +
//           ", " +
//           placemark[0].locality.toString() +
//           ", Postal Code:" +
//           placemark[0].postalCode.toString();
//       global.laborAddress = presentAddress.toString();
//       global.laborLatitude = position.latitude;
//       global.laborLongitude = position.longitude;
//       //UserServices().userLocationStore();
//     });
//   });
//   //UserServices().userLocationStore();
// }

// void onCreated(GoogleMapController controller) {
//   setState(() {
//     mapController = controller;
//   });
// }

// void onCameraMove(CameraPosition position) {
//   setState(() {
//     lastPosition = position.target;
//   });
// }

// // Add Marker

// populateClient() {
//   Firestore.instance.collection("Users_Info").getDocuments().then((docs) {
//     if (docs.documents.isNotEmpty) {
//       for (int i = 0; i < docs.documents.length; i++) {
//         initMarker(docs.documents[i].data, docs.documents[i].documentID);
//       }
//     } else {
//       print("Docments have no data hhahahahaha");
//     }
//   });
//   print("BBBBBBB");
// }

//  populateLabor(){
//     return StreamBuilder (
//       stream:  Firestore.instance.collection("Users_Info").snapshots(),
//       builder: (context, snapshot){
//         if(!snapshot.hasData) {
//           return Text("Loading... Plese wait",style: TextStyle( fontSize: 20.0),);
//         }else {
//            for(int i = 0; i < snapshot.data.documents.length; i++){
//             DocumentSnapshot labors = snapshot.data.document[i];

//              initMarker(labors.data[i],labors.documentID[i]);
//           }
//         }
//       });
//   }

// void initMarker(request, requestId) {
//   var markerIdVal = requestId;
//   final MarkerId markerId = MarkerId(markerIdVal);
//   //Creating a new Marker
//   final Marker marker = Marker(
//       markerId: markerId,
//       position: LatLng(request["userLatitude"], request["userLongitude"]),
//       infoWindow: InfoWindow(
//         title: request["userName"],
//         snippet: request["userAddress"].toString(),
//       ));
//   setState(() {
//     markers[markerId] = marker;
//     print(markerId);
//   });
// }
