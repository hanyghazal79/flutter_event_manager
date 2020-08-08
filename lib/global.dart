

import 'package:flutter_event_manager/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  List<dynamic> dataList = new List();
  static User currentUser;
//  static List<SharedPreferences> users = new List();

  static const String SETTINGS = "Settings";
  static const String LOGOUT = "Logout";
  static const List<String> homePopupMenuItems = <String>[SETTINGS, LOGOUT];
  static const String CURRENT_USER_KEY = "CURRENT_USER_KEY";

}
