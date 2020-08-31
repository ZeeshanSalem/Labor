import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:labors/Services/user_services.dart';
import '../Gvariable.dart' as global;

class CustomMap extends StatefulWidget {
  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  // For getting device Location
  Geolocator geolocator;
  Position positions;
  StreamSubscription _positioStream;

  // Google Map
  GoogleMapController mapController;
  //Placemark place;
  static LatLng initialPosition;
  LatLng lastPosition = initialPosition;
  String presentAddress;
  List<Placemark> placemark;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  // method get position
  void _getlocation() {
    geolocator = Geolocator()..forceAndroidLocationManager;
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _positioStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) async {
      placemark = await geolocator.placemarkFromCoordinates(
          position.latitude, position.longitude);
      setState(() {
        positions = position;
        initialPosition = LatLng(positions.latitude, positions.longitude);

        presentAddress = placemark[0].name.toString() +
            ", " +
            placemark[0].locality.toString() +
            ", Postal Code:" +
            placemark[0].postalCode.toString();
        global.laborAddress = presentAddress.toString();
        global.laborLatitude = position.latitude;
        global.laborLongitude = position.longitude;
        //UserServices().userLocationStore();
      });
    });
    //UserServices().userLocationStore();
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void onCameraMove(CameraPosition position) {
    setState(() {
      lastPosition = position.target;
    });
  }

  // Add Marker

  populateClient() {
    Firestore.instance.collection("Users_Info").getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      } else {
        print("Docments have no data hhahahahaha");
      }
    });
    print("BBBBBBB");
  }

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

  void initMarker(request, requestId) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    //Creating a new Marker
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(request["userLatitude"], request["userLongitude"]),
        infoWindow: InfoWindow(
          title: request["userName"],
          snippet: request["userAddress"].toString(),
        ));
    setState(() {
      markers[markerId] = marker;
      print(markerId);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //_getlocation();
    //populateLabor();
    //populateClient();
    super.initState();
  }

  @override
  void dispose() {
    _positioStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Container(
        //   child: initialPosition == null? Center(
        //     heightFactor: 100.0,
        //     widthFactor: 100.0,
        //     child: CircularProgressIndicator(
        //       value: 50.0,
        //       backgroundColor: Colors.white,//Theme.of(context).primaryColor,

        //     ),
        //   ): GoogleMap(
        //     onMapCreated: onCreated,
        //     initialCameraPosition: CameraPosition(
        //       target: LatLng(positions.latitude, positions.longitude),
        //       zoom: 16.0,
        //       ),
        //       onCameraMove: onCameraMove,
        //       compassEnabled: true,
        //       myLocationEnabled: true,
        //       markers: Set<Marker>.of(markers.values),
        //       ),
        // ),
        //  Align(
        //    alignment:Alignment.bottomCenter,
        //    child: FlatButton(
        //      onPressed: () => UserServices().userLocationStore(),
        //      child: Text("Proceed"))
        //  )
        Center(
          child: Container(
            child: RaisedButton(
              onPressed: () {
                UserServices().signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/SignIn', (Route<dynamic> route) => false);
              },
              color: Colors.yellow,
              child: Text("SignOut"),
            ),
          ),
        )
      ],
    );
  }
}
