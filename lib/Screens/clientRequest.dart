import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labors/Gvariable.dart' as globals;

class ClientRequest extends StatefulWidget {
  @override
  _ClientRequestState createState() => _ClientRequestState();
}

class _ClientRequestState extends State<ClientRequest> {
  SharedPreferences sharedUserData;
  String uid;
  Firestore _firestore = Firestore.instance;
  var requestId;
  bool accepted = false;

  @override
  void initState() {
    // TODO: implement initState
    getUid();
    super.initState();

    //getId();
  }

  getUid() async {
    sharedUserData = await SharedPreferences.getInstance();
    setState(() {
      uid = sharedUserData.get("currentUserId");
    });
  }

  getId() async {
    _firestore
        .collection("Labor_Requests")
        .where("laborType", isEqualTo: globals.labortype)
        .where("laborId", isEqualTo: uid)
        .getDocuments()
        .then((QuerySnapshot snapshot) => {
              snapshot.documents.forEach((DocumentSnapshot data) {
                print("XYZZZZZZZZZ    ${data.documentID}");
                print("${data["laborName"]}");
                setState(() {
                  requestId = data.documentID;
                });
              })
            });
  }

  Future addData(
      String parentDocuemntId,
      String pCollectionName,
      String laborImg,
      String laborName,
      String laborphoneNumber,
      String laborId,
      String laborToken,
      String id) async {
    return await Firestore.instance
        .collection("Accepted Request")
        .document(parentDocuemntId)
        .setData({
      "laborid": laborId,
      "laborName": laborName,
      "laborImg": laborImg,
      "laborPhoneNumber": laborphoneNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream _stream = Firestore.instance
        .collection("Labor_Requests")
        .where("laborId", isEqualTo: "$uid")
        .snapshots();
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _stream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print("labor id $uid");
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    "You Have no Request Kindly Stay online For Request",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 20.0,
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.yellow,
                    value: 20.0,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Somethiing Wrong ..."),
                );
              }

              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ldata = snapshot.data.documents[index];
                    print("user dou Id ${ldata.documentID}");

                    return StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("Labor_Requests")
                            .document(ldata.documentID)
                            .collection("From_User")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> userSnapshot) {
                          print(" assdad    ${ldata.documentID}");
                          //

                          if (!userSnapshot.hasData) {
                            return CircularProgressIndicator(
                              backgroundColor: Colors.pink,
                            );
                          }

                          return new ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: userSnapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot dutu =
                                    userSnapshot.data.documents[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.yellow,
                                  elevation: 10.0,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 50.0,
                                          backgroundColor: Colors.blue,
                                          child: ClipOval(
                                            child: SizedBox(
                                              width: 60.0,
                                              height: 100.0,
                                              child: Image.network(
                                                dutu["userImage"].toString(),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          dutu.data["userName"],
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          dutu.data["userPhone"],
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      ButtonBar(
                                        children: <Widget>[
                                          ButtonTheme(
                                            //shape: CircleBorder(),
                                            child: RaisedButton(
                                              child: Text(
                                                "Reject",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                Firestore.instance
                                                    .collection(
                                                        "Labor_Requests")
                                                    .document(ldata.documentID)
                                                    .delete();
                                              },
                                            ),
                                          ),
                                          ButtonTheme(
                                            child: RaisedButton(
                                              child: Text(
                                                "Accept",
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () {
                                                Firestore.instance
                                                    .collection(
                                                        "Accepted Request")
                                                    .document(ldata.documentID)
                                                    .setData({
                                                  'requestId':
                                                      ldata["laborRequestId"],
                                                  'laborName':
                                                      ldata["laborName"],
                                                  'laborId': ldata["laborId"],
                                                  'laborImage':
                                                      ldata["laborImage"],
                                                  'laborPhone':
                                                      ldata["laborPhone"],
                                                  'laborToken':
                                                      ldata["laborToken"],
                                                  'laborType':
                                                      ldata["laborType"],
                                                  'userName': dutu["userName"],
                                                  'userImage':
                                                      dutu["userImage"],
                                                  'userPhone':
                                                      dutu["userPhone"],
                                                  'userToken':
                                                      dutu["userToken"],
                                                  'userId': dutu["userId"],
                                                }).whenComplete(() => Firestore
                                                        .instance
                                                        .collection(
                                                            "Labor_Requests")
                                                        .document(
                                                            ldata.documentID)
                                                        .delete());
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                        });
                  });
            }));
  }
}
