import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_event_manager/global.dart';
import 'package:flutter_event_manager/models/database_helper.dart';
import 'package:flutter_event_manager/models/user.dart';
import 'package:flutter_event_manager/widgets/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RegisterState();
  }
}

class RegisterState extends State<Register>{
  TextEditingController _cTxtName;
  TextEditingController _cTxtEmail;
  TextEditingController _cTxtPassword;
  TextEditingController _cTxtConfirmPassword;
  File _imageFile;
  String _imageName;
  DatabaseHelper _helper;

  var downloadUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cTxtName = new TextEditingController();
    _cTxtEmail = new TextEditingController();
    _cTxtPassword = new TextEditingController();
    _cTxtConfirmPassword = new TextEditingController();
    _helper = new DatabaseHelper();
  }
  void openImagePickerModal(BuildContext context){
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    getImage(context, ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    getImage(context, ImageSource.gallery);

                  },
                ),

              ],
            ),
          );
        }
    );
  }
  void getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
    _imageFile = image;
    });
    // Closes the bottom sheet
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(title: Text('Register'),),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0, bottom: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                Padding(padding: EdgeInsets.only(left: 20.0)),
                _imageFile == null ?
                CircleAvatar(
                  backgroundImage: AssetImage('assets/blank-profile-picture.png') ,
//                  radius: 30,
                  backgroundColor: Colors.grey,
                )
                    : Image.file(_imageFile, width: 100, height: 125, fit: BoxFit.cover),
                IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: (){
                      openImagePickerModal(context);
                    }
                )
              ],
            ),
            Expanded(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    TextField(
                      controller: _cTxtName,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'User Name',
                      ),
                    ),
                    TextField(
                      controller: _cTxtEmail,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      controller: _cTxtPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    TextField(
                      controller: _cTxtConfirmPassword,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                            child: Text('Register'),
                            onPressed: ()async{
                              print('===============REGISTER BUTTON PRESSED ===================');
                              await _helper.register(_cTxtName.text, _cTxtEmail.text, _cTxtPassword.text, _imageFile);
//                              if(Global.currentUser.getImageUrl() != null){
                              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=> new Home()));
//                              }
                            }
                        ),
                        RaisedButton(
                            child: Text('Cancel'),
                            onPressed: (){}
                        )
                      ],
                    ),
                    Text(_imageFile.toString())
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}