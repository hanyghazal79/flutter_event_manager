import 'package:flutter/material.dart';
import 'package:flutter_event_manager/global.dart';
import 'package:flutter_event_manager/models/user.dart';
import 'package:flutter_event_manager/widgets/home.dart';
import 'package:flutter_event_manager/widgets/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Director extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new DirectorState();
  }

}

class DirectorState extends State<Director>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    checkUser().then((result){
//      setState(() {
//        Global.currentUser = result;
//      });
//    });
//    if(Global.currentUser !=null){
//      Navigator.of(context).pushNamed('home');
//    }

  }
  Future<User> checkUser()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = sp.getKeys().toList();
    String key;
    for(int i = 0; i < data.length; i++){
      if(data[i].endsWith('.com')){
        key = data[i];
      }
    }
    List<dynamic> userInfo = sp.get(key);
    Global.currentUser = new User(userInfo[0], userInfo[1], userInfo[2], userInfo[3], userInfo[4]);
    return Global.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    Widget widget = Global.currentUser == null? Login():Home();
    return Home();
  }
}