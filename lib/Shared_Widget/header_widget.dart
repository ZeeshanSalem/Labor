import 'package:flutter/material.dart';

AppBar header(context, { bool isAppTitle = false, String strTitle, disappearedBackButton = false})
 {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.black,
       ),
       automaticallyImplyLeading: disappearedBackButton ? false : true,
       title: Text(
         isAppTitle ? " MAZDOOR " : strTitle,
         style: TextStyle(
           fontFamily: isAppTitle ? "Signatra" : "",
           fontSize: isAppTitle ? 45.0 : 25.0,  
         ),
         overflow: TextOverflow.ellipsis,
       ),
       centerTitle: true,
       backgroundColor: Theme.of(context).primaryColor,
  );
}