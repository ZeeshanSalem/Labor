import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:labors/Services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Gvariable.dart' as global;

class UserLocation extends StatefulWidget {
  @override
  _UserLocationState createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  Geolocator _geolocator;
  Position _position;
  StreamSubscription _positionStream;

  GoogleMapController mapController;
  SharedPreferences sharedUserData;
  Placemark place;
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  String presentAddress;
  String laborName;
  List<Placemark> placemark;
  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  Set<Marker> _addmarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId(
              LatLng(_position.latitude, _position.longitude).toString()),
          position: LatLng(_position.latitude, _position.longitude),
          infoWindow: InfoWindow(
            title: "Your are Here",
            snippet: presentAddress,
          ))
    ].toSet();
  }

  void _getLocation() {
    _geolocator = Geolocator()..forceAndroidLocationManager;
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _positionStream = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) async {
      //List<Placemark> placemark =  Geolocator().placemarkFromPosition(position) as List<Placemark>;
      //placemark = await _geolocator.placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        _position = position;
        _initialPosition = LatLng(position.latitude, position.longitude);
        // presentAddress = placemark[0].name.toString() + ", " +
        //  placemark[0].locality.toString() +
        //  ", Postal Code:" + placemark[0].postalCode.toString();
        // global.laborAddress = presentAddress.toString();
        //presentAddress = placemark[0].subLocality.toString();
        global.laborLatitude = position.latitude;
        global.laborLongitude = position.longitude;
      });
    });
  }

  readData() async {
    sharedUserData = await SharedPreferences.getInstance();
    setState(() {
      laborName = sharedUserData.get("laborName");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
    readData();

    //_addmarker();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 60),
              Text(
                "Hi, $laborName,",
                style: TextStyle(
                  fontSize: 40.0,
                  color: Theme.of(context).accentColor,
                  fontFamily: "Signatra",
                ),
              ),
              Text(
                "You are here!",
                style: TextStyle(
                  fontSize: 40.0,
                  color: Theme.of(context).accentColor,
                  fontFamily: "Signatra",
                ),
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 150,
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(180.0),
                      child: _initialPosition == null
                          ? _circle()
                          : GoogleMap(
                              onMapCreated: onCreated,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      _position.latitude, _position.longitude),
                                  zoom: 17.0),
                              markers: Set.from(_addmarker()),
                              onCameraMove: _onCameraMove,
                              compassEnabled: true,
                            ),
                    )),
              ),
              SizedBox(height: 60.0),
              Center(
                  child: ButtonTheme(
                      height: 50.0,
                      minWidth: MediaQuery.of(context).size.width - 80,
                      buttonColor: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: RaisedButton(
                        onPressed: () {
                          UserServices().userLocationStore().then((value) => {
                                print("Stored location"),
                                Navigator.of(context)
                                    .pushReplacementNamed('/home'),
                              });
                        },
                        child: Text("Continue",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                        textColor: Colors.white,
                      )))
            ],
          ),
        ),
      ),
    );
  }

  Widget _circle() {
    return Center(
      child: Container(
          color: Colors.white,
          child: Text(" Please wait Your location is Loading",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 30.0,
                fontFamily: "Signatra",
              ))),
    );
  }
}
