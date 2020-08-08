import 'dart:convert';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_event_manager/global.dart';
import 'package:flutter_event_manager/models/user.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
class DatabaseHelper {

  final staticUrl = "http://events.inativecoder.com/api";
  String token;
  bool isError;
  static List<int>cityIDs  = new List();
  static Map<String, dynamic> data = new Map();
  final StorageReference _storageReference = FirebaseStorage.instance.ref().child('User Images');
  String _imageName;
  //==================

   Future<Map<String, dynamic>> login(String email, String password)async{
    String url = "$staticUrl/login";
    http.Response response = await http.post(
        url,
        body: {
         "email":"$email",
         "password":"$password"
    });
    var data = json.decode(response.body);
    token = data['token'];
    saveToken(token);
    print(token);
    return data;
  }

  Future<void> register(String name, String email, String password, File image)async{
     try{
       String url = "$staticUrl/register";
       http.Response response = await http.post(
           url,
           body: {
             "name":"$name",
             "email":"$email",
             "password":"$password",
           }
       );
       var data = json.decode(response.body);
       if(response.statusCode == 400){
         print(data);
       }else{
         token = data['token'];
         print(data);
//    Map<String, dynamic> userInfo = data['user'];
         saveToken(token);
         String dateFormatStr = formatDate(DateTime.now(), [yyyy,'-',mm,'-',dd,'-', hh,mm,ss]);
         _imageName = dateFormatStr + basename(image.path);
         await _storageReference.child(email).child(_imageName).putFile(image).onComplete.then((snapshot)async{
           var downloadUrl =  await snapshot.ref.getDownloadURL();
           Global.currentUser = new User(data['user']['id'], name, email, password, downloadUrl);
           updateUsersData(Global.currentUser);
//      updateGlobalUsersData(Global.currentUser);
           print("\n================= Download URL = "+downloadUrl);
         });
       }
     }catch(e){
       print('===> ERROR: ${e.toString()}');
     }
}

void updateUsersData(User user) async{
     SharedPreferences sp = await SharedPreferences.getInstance();
     List<String> userData = [user.getId().toString(), user.getName(), user.getEmail(), user.getPassword(), user.getImageUrl()];
     sp.setStringList('${Global.CURRENT_USER_KEY}', userData);
     sp.setStringList(user.getEmail(), userData);
}
void saveToken(String token) async{
     SharedPreferences sp = await SharedPreferences.getInstance();
     sp.setString("token", token);
  }
  //============================
  Future<void> updateUserProfile(int id, String name, String email, String password)async{
    String loginUrl = "$staticUrl/login";
    http.Response response = await http.post(
        loginUrl,
        body: {
          "email":"$email",
          "password":"$password"
        });
    var data = json.decode(response.body);
    var token = data['token'];
    saveToken(token);
     String url = "$staticUrl/users/$id";
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     final token = sp.get("token") ?? 0;
     await http.put(
         url,
         headers: {"Accept":"application/json",  "Authorization":"Bearer $token"},
         body: {
           'name':'$name',
           'email':'$email',
           'password':'$password'
         }
     ).then((response){
       print("Response Status: ${response.statusCode}");
       print("Response body: ${response.body}");
     });
  }

  //============================
  getToken()async{
     SharedPreferences sp = await SharedPreferences.getInstance();
     final value = sp.get("token") ?? 0;
     return value;
  }
  Future<Map<String, dynamic>> getEvents()async{
     String url = "$staticUrl/events";
     SharedPreferences sp = await SharedPreferences.getInstance();
     final token = sp.get("token") ?? 0;
     http.Response response = await http.get(url, headers: {
       "Accept":"application/json",
       "Authorization":"Bearer $token"
     });
     return json.decode(response.body);
  }
  Future<Map<String, dynamic>> getSelectedCityEvents(String cityName)async{
    String url = "$staticUrl/events/$cityName";
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.get("token") ?? 0;
    http.Response response = await http.get(url, headers: {
      "Accept":"application/json",
      "Authorization":"Bearer $token"
    });
    return json.decode(response.body);
  }
  Future<Map<String, dynamic>> getCities()async{
    String url = "$staticUrl/cities";
//    SharedPreferences sp = await SharedPreferences.getInstance();
//    final token = sp.get("token") ?? 0;
//    http.Response response = await http.get(url, headers: {
//      "Accept":"application/json",
//      "Authorization":"Bearer $token"
//    });
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }
  Future<int>getCityID(String cityName) async{
    String url = "$staticUrl/cities";
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.get("token") ?? 0;
    http.Response response = await http.get(url, headers: {
      "Accept":"application/json",
      "Authorization":"Bearer $token"
    });
    return response.body as int;
  }
  Future<Map<String, dynamic>> addEvent(String title, String details, DateTime eventDateTime, int minAge, int maxAge)async{
     //refreshtoken
    String newToken;
    String refreshUrl = "$staticUrl/login";
    await http.post(
        refreshUrl,
        body: {
          "email":"${Global.currentUser.getEmail()}",
          "password":"${Global.currentUser.getPassword()}"
        }).then((response){
          newToken = json.decode(response.body)['token'];
        });
    String url = "$staticUrl/events";
//    SharedPreferences sp = await SharedPreferences.getInstance();
//    final token = sp.get("token") ?? 0;
    http.Response response = await http.post(
    url,
    headers: {
    "Accept":"application/json",
    "Authorization":"Bearer $newToken"

    },
     body: {
        "title":"$title",
        "details":"$details",
        "date_time":"$eventDateTime",
        "min_age":"$minAge",
        "max_age":"$maxAge"
    });
    Map<String, dynamic> dataMap = new Map();
    var eventData = json.decode(response.body);
    dataMap.addAll(eventData);
    if(dataMap.length > 0){
      for(int i = 0; i < dataMap.length; i++){
        await addEventLocation(dataMap['data'][i]['id'], DatabaseHelper.cityIDs[i]);
      }
    }
    return eventData;//json.decode(response.body);
  }

  Future<Map<String, dynamic>> getEventLocations()async{
    String url = "$staticUrl/event_locations";
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.get("token") ?? 0;
    http.Response response = await http.get(url, headers: {
      "Accept":"application/json",
      "Authorization":"Bearer $token"
    });
    return json.decode(response.body);
  }
  Future<void> addEventLocation(int eventID, int cityID)async{
     String url = "$staticUrl/event_locations";
     SharedPreferences sp = await SharedPreferences.getInstance();
     final token = sp.get("token") ?? 0;
     await http.post(
         url,
         headers: {"Accept":"application/json",  "Authorization":"Bearer $token"},
         body: {'event_id':'$eventID', 'city_id':'$cityID'}
         ).then((response){
       print("Response Status: ${response.statusCode}");
       print("Response body: ${response.body}");
     });
  }
  void editEventLocation(int id, int eventID, int cityID)async{
    String url = "$staticUrl/event_locations/$id";
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.get("token") ?? 0;
    await http.post(
        url,
        headers: {"Accept":"application/json",  "Authorization":"Bearer $token"},
        body: {'event_id':'$eventID', 'city_id':'$cityID'}
    ).then((response){
      print("Response Status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });
  }
  void deleteEvent(int id)async{
    String url = "$staticUrl/events/$id";
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.get("token") ?? 0;
    await http.post(
        url,
        headers: {
          "Accept":"application/json",
          "Authorization":"Bearer $token"
        }).then((response){
      print("Response Status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });
  }
  void deleteEventLocation(int id)async{
    String url = "$staticUrl/event_locations/$id";
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.get("token") ?? 0;
    await http.post(
        url,
        headers: {
          "Accept":"application/json",
          "Authorization":"Bearer $token"
        }).then((response){
      print("Response Status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });
  }
  void editEvent(int id, String title, String details, DateTime eventDateTime, int minAge, int maxAge)async{
    String url = "$staticUrl/events/$id";
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.get("token") ?? 0;
    await http.post(
        url,
        headers: {
          "Accept":"application/json",
          "Authorization":"Bearer $token"
        },
        body: {
          "title":"$title",
          "details":"$details",
          "date_time":"$eventDateTime",
          "min_age":"$minAge",
          "max_age":"$maxAge"
        }).then((response){
      print("Response Status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });
  }
}