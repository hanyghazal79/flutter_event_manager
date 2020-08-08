import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_event_manager/global.dart';
import 'package:flutter_event_manager/models/database_helper.dart';
import 'package:flutter_event_manager/models/user.dart';
import 'package:flutter_event_manager/widgets/home.dart';
import 'package:flutter_event_manager/widgets/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  TextEditingController cEmail;
  TextEditingController cPassword;
  String token = "";
//  List<dynamic> userInfo;
  User user;
//  String _currentUserKey;
  @override
   initState(){
    // TODO: implement initState
    super.initState();
//    SharedPreferences.getInstance().then((sp){
//      Set<String> keys = sp.getKeys().toSet();
//      for(String key in keys){
//        if(key.contains(".com")){
//          userInfo = sp.get(key);
//        }
//      }
//    });
//    Global.currentUser = new User(
//        userInfo.elementAt(0), userInfo.elementAt(1), userInfo.elementAt(2), userInfo.elementAt(3));
//    if(Global.currentUser.getEmail() != null){
//      Navigator.of(context).pushNamed('home');
//    }
    //    checkUser().then((result){
//      setState(() {
//        Global.currentUser = result;
//      });
//    });
//    if(Global.currentUser !=null){
//      Navigator.of(context).pushNamed('home');
//    }
    cEmail = new TextEditingController();
    cPassword = new TextEditingController();
//    print("Current User = "+Global.currentUser.getEmail());

  }
//  Future<User> checkUser()async{
//    SharedPreferences sp = await SharedPreferences.getInstance();
//    var data = sp.getKeys().toList();
//    String key;
//    for(int i = 0; i < data.length; i++){
//      if(data.elementAt(i).endsWith('.com')){
//        key = data.elementAt(i);
//      }
//    }
//    List<dynamic> userInfo = sp.get(key);
//    Global.currentUser = new User(userInfo.elementAt(0), userInfo.elementAt(1), userInfo.elementAt(2), userInfo.elementAt(3));
//    return Global.currentUser;
//  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Login Page'),
      ),
      body: new Center(
        child: new Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 150.0, horizontal: 20.0),
          child: new ListView(
            children: <Widget>[
              TextField(
                controller: cEmail,
                decoration: InputDecoration(hintText: 'Email'),
              ),
              TextField(
                controller: cPassword,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () async {
                      login();
//                      getUserData(cEmail.text);
                    },
                    child: Text('Login'),
                    color: Colors.deepPurple,
                  ),
                  RaisedButton(
                      onPressed: register,
                      child: Text('Register'),
                      color: Colors.blue,
//                      padding: EdgeInsets.only(right: 300.0)
                  )
                ],
              ),

              Text('$token')
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    DatabaseHelper helper = new DatabaseHelper();
    await helper.login(cEmail.text, cPassword.text).then((result) {
      setState(() {
        token = result['token'];
      });
    });
    SharedPreferences sp = await SharedPreferences.getInstance();
    for(String key in sp.getKeys()){
      if(cEmail.text == key){
        List<String> data = sp.getStringList(key);
        sp.setStringList(Global.CURRENT_USER_KEY, data);
        Global.currentUser = new User(int.parse(data[0]), data[1], data[2], data[3], data[4]);
      }
    }

    Navigator.of(context).pushNamed('home');
  }


  void register() {
    Navigator.of(context).pushNamed('register');
  }
//  void getUserData(String email)async{
//    DatabaseHelper helper = new DatabaseHelper();
//    await helper.getUserData(cEmail.text).then((result){
//      setState(() {
//        print(result);
//      });
//    });
//  }
}
