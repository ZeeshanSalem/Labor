import 'package:flutter/material.dart';

class ClientRequest extends StatefulWidget {
  @override
  _ClientRequestState createState() => _ClientRequestState();
}

class _ClientRequestState extends State<ClientRequest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "No Request",
          style: TextStyle(fontSize: 50.0),
        ),
      ),
    );
  }
}
