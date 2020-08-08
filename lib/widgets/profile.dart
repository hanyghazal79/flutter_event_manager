import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_event_manager/global.dart';
import 'package:flutter_event_manager/models/database_helper.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ProfileState();
  }
}

class ProfileState extends State<Profile> {
  TextEditingController _cUserName;
  TextEditingController _cUserEmail;
  TextEditingController _cPassword;
  bool _nameReadOnlyState, _emailReadOnlyState, _passwordReadOnlyState;
  bool _nameAutoFocus, _emailAutoFocus, _passwordAutoFocus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  void init(){
    _cUserName = new TextEditingController(text: Global.currentUser.getName());
    _cUserEmail = new TextEditingController(text: Global.currentUser.getEmail());
    _cPassword = new TextEditingController(text: Global.currentUser.getPassword());

    _nameReadOnlyState = true;
    _emailReadOnlyState = true;
    _passwordReadOnlyState = true;

    _nameAutoFocus = false;
    _emailAutoFocus = false;
    _passwordAutoFocus = false;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding:
            EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 30.0)),
                CircleAvatar(
                  backgroundImage: NetworkImage(Global.currentUser.getImageUrl()),
                  radius: 80,
                ),
                IconButton(icon: Icon(Icons.camera_alt), onPressed: () {})
              ],
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      autofocus: _nameAutoFocus,
                      readOnly: _nameReadOnlyState,
                      controller: _cUserName,
                      decoration: InputDecoration(labelText: 'Name', focusColor: Colors.blueAccent),
                    )
                ),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _nameReadOnlyState = false;
                        _nameAutoFocus = true;
                      });
                    })
              ],
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      readOnly: _emailReadOnlyState,
                      controller: _cUserEmail,
                      decoration: InputDecoration(labelText: 'Email'),
                    )
                ),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _emailReadOnlyState = false;
                        _emailAutoFocus = true;
                      });
                    })
              ],
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      readOnly: _passwordReadOnlyState,
                      controller: _cPassword,
                      decoration: InputDecoration(labelText: 'Password'),
                    )
                ),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _passwordReadOnlyState = false;
                        _passwordAutoFocus = true;
                      });
                    })
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: (){
             DatabaseHelper _helper = new DatabaseHelper();
             _helper.updateUserProfile(Global.currentUser.getId(), _cUserName.text, _cUserEmail.text, _cPassword.text);
             //UPDATE CURRENT USER:

          }),
    );
  }
}
