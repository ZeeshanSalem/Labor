import 'package:shared_preferences/shared_preferences.dart';

class UserID {
  SharedPreferences sharedUserData;

  functionUserId() async {
    sharedUserData = await SharedPreferences.getInstance();
    String currentUserId = sharedUserData.get("currentUserId");
    return currentUserId;
  }
}
