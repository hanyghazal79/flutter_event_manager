import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_event_manager/global.dart';
import 'package:flutter_event_manager/models/user.dart';
import 'package:flutter_event_manager/widgets/add_event.dart';
import 'package:flutter_event_manager/widgets/director.dart';
import 'package:flutter_event_manager/widgets/home.dart';
import 'package:flutter_event_manager/widgets/login.dart';
import 'package:flutter_event_manager/widgets/profile.dart';
import 'package:flutter_event_manager/widgets/register.dart';
import 'package:flutter_event_manager/widgets/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:http/http.dart' as http;
void main()async{

  runApp(new MaterialApp(
    home:  EventManager(),
    routes: <String, WidgetBuilder>{
         'home':(BuildContext context)=>new Home(),
         'login':(BuildContext context)=>new Login(),
         'register':(BuildContext context)=>new Register(),
         'add':(BuildContext context)=>new NewEvent(),
         'profile':(BuildContext context)=>new Profile(),
         'settings':(BuildContext context)=>new Settings(),
         'director': (BuildContext context)=>new Director()
    },
    ));
}

class EventManager extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new EventManagerState();
  }

}
class EventManagerState extends State<EventManager>{
  Widget _nextWidget = new Login();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser().then((user){
      setState(() {
        if(user != null){
          Global.currentUser = user;
          _nextWidget = new Home();
        }
      });
    });
  }

  Future<User> checkUser()async{
    User user;
    List<dynamic> data;
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      data = sp.get(Global.CURRENT_USER_KEY);
      if(data != null){
        user = new User(int.parse(data[0]), data[1], data[2], data[3], data[4]);
      }else{
        user = null;
      }
    });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SplashScreen(
        seconds: 14,
        navigateAfterSeconds: _nextWidget,
        title: new Text('Welcome In SplashScreen',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),),
        image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: ()=>print("Flutter Egypt"),
        loaderColor: Colors.red
    );
  }
}

//class AfterSplash extends StatelessWidget{
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return null;
//  }
//}