import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_event_manager/global.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SettingsState();
  }
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        leading: Builder(
            builder: (context) =>
                IconButton(icon: Icon(Icons.settings), onPressed: () {})),
        title: Text(Global.SETTINGS),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed('profile');
              },

              highlightColor: Colors.grey,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(width: 35,height: 35, color: Colors.black,
                    child: Icon(Icons.account_circle, color: Colors.white,),
                  ),
//                  CircleAvatar(
//                    backgroundImage:
//                        AssetImage('assets/blank-profile-picture.png'),
//                    radius: 40,
//                  ),

                  Text(
                    'Profile',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 125.0),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey,)
                ],
              ),

            ),
            Padding(padding: EdgeInsets.only(top: 10.0, bottom: 10.0)),
            Container(
              height: 5,
              color: Color.fromRGBO(225, 225, 225, 100),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0, bottom: 10.0)),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 35,height: 35,color: Colors.yellow,
                    child: Icon(Icons.notifications, color: Colors.red, size: 30,),
                  ),
                  Text('Notifications', style: TextStyle(fontSize: 16.0), ),
                  Padding(padding: EdgeInsets.only(right: 80)),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey,),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
