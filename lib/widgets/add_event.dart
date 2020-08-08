import 'package:flutter/material.dart';
import 'package:flutter_event_manager/global.dart';
import 'package:flutter_event_manager/models/database_helper.dart';
import 'package:flutter_event_manager/widgets/options_dialog.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
class NewEvent extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new NewEventState();
  }

}

class NewEventState extends State<NewEvent>{
   DateTime _dateTimeValue;
   int _minAge = 20;
   int _maxAge = 40;
  TextEditingController _cEventTitle;
  TextEditingController _cEventDetails;
  
  List<dynamic> _cities;
  List<String> allCities;
  List<String> selectedCities = [];
  DatabaseHelper _helper;
  Map<String, int> mapNameID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  void init(){
    _cEventTitle = new TextEditingController();
    _cEventDetails = new TextEditingController();
    _cities = new List();
    allCities = new List();
    mapNameID = new Map();
    _cities.clear();
    DatabaseHelper.cityIDs.clear();
    _helper = new DatabaseHelper();
    getAllCities();
  }
  void getAllCities()async{
//    await _helper.login(Global.currentUser.getEmail(), Global.currentUser.getPassword());
    await _helper.getCities().then((result){
      setState(() {
        _cities.addAll(result['data']);
        for(int i = 0; i<_cities.length; i++){
          allCities.add(_cities[i]['city_name_en']);
          mapNameID.addAll({'${_cities[i]['city_name_en']}' : _cities[i]['id']});
        }
      });
    });
  }
  Future viewMinAgeDialog() async{
    await showDialog<int>(
        context: context,
        builder: (BuildContext context){
          return new NumberPickerDialog.integer(
              minValue: 1,
              maxValue: 100,
              initialIntegerValue: _minAge,
              step: 1,
          );
        }
    ).then((value){
      if(value != null){
        setState(() {
          _minAge = value;
        });
      }
    });
  }
  Future viewMaxAgeDialog() async{
    await showDialog<int>(
        context: context,
        builder: (BuildContext context){
          return new NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 100,
            initialIntegerValue: _maxAge,
            step: 1,
          );
        }
    ).then((value){
      if(value != null){
        setState(() {
          _maxAge = value;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(title: Text('New Event..'),),
      body: new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Center(
          
          child: new ListView(
            children: <Widget>[
//              Text('${DatabaseHelper.data['data']['id']}'),
              TextField(
                controller: _cEventTitle,
                decoration: InputDecoration(
                    hintText: 'title',
                  icon: Icon(Icons.title)
                ),
              ),
              TextField(
                controller: _cEventDetails,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: 'details',
                  icon: Icon(Icons.details)
                ),
              ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Text('Date and time : ${formatDateTime()}'),
                 IconButton(
                     icon: Icon(Icons.edit),
                     onPressed: showDateTimePicker)
               ],
             ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Event Locations'),
                      IconButton(
                        icon: Icon(Icons.edit_location, color: Colors.deepPurple),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder:(context){
                                return OptionsDialog(
                                  cities: allCities,
                                  selectedCities: selectedCities,
                                  onSelectedCitiesListChanged: (cities){
                                    setState(() {
                                      selectedCities = cities;
                                      DatabaseHelper.cityIDs = getCityIDs(selectedCities, mapNameID);
                                    });
                                  },
                                );
                              }
                          );
                        }
                      )
                    ],
                  ),
                  citiesWidget()
                ],
              ),
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Text('Min. Age :'),
                     Text('$_minAge'),
                     IconButton(
                         icon: Icon(Icons.edit),
                         onPressed: (){
                           viewMinAgeDialog();
                         }
                     )
                   ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Text('Max. Age :'),
                     Text('$_maxAge'),
                     IconButton(
                         icon: Icon(Icons.edit),
                         onPressed: (){
                           viewMaxAgeDialog();
                         }
                     )
                   ],
                 ),
                 Row(mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     FlatButton(
                         onPressed: (){
                           saveEvent();
                         },
                         child: Text('Save', style: TextStyle(color: Colors.white),),
                         color: Colors.deepPurple,
                         padding: EdgeInsets.only(left: 150, right: 150),
                     )
                   ],
                 )
               ],
             ),
            ],
          ),
        ),
      ),
    );
  }
  Widget citiesWidget(){
    String names = "";
    for(String cityName in selectedCities){
      names += cityName + ", ";
    }
    return Text(names, style: TextStyle(fontStyle: FontStyle.italic),);
  }
  void saveEvent() async{

    List<dynamic> dataList = new List();
//    try{
      await _helper.addEvent(
          _cEventTitle.text,
          _cEventDetails.text,
          _dateTimeValue,
          _minAge,
          _maxAge
      );
//          .then((data){
//        setState(() {
//          DatabaseHelper.data.addAll(data);
//          dataList.add(DatabaseHelper.data['data']);
//          print('DATADATADATA = ${DatabaseHelper.data.toString()}');
//        });
////        if(dataList.length > 0){
////          for(int i = 0; i < dataList.length; i++){
////            _helper.addEventLocation(dataList.elementAt(i)['id'], DatabaseHelper.cityIDs[i]);
////          }
////          Navigator.of(context).pushNamed('home');
////        }
//      }
//      );
      Navigator.of(context).pushNamed('home');

//    }catch(e){
//      print('===> ERROR: $e');
//    }


  }


Future<DateTime> showDateTimePicker() async {
   return await DatePicker.showDateTimePicker(
       context,
       showTitleActions: true,
       minTime: new DateTime(1960),
       maxTime: new DateTime(2050),
       currentTime: new DateTime.now(),
       onConfirm: (dateTimeValue){
         setState(() {
           _dateTimeValue = dateTimeValue;
         });
     }
   );
}
String formatDateTime(){
    String dateTimeString;
    if(_dateTimeValue == null){
      dateTimeString = "Define date and time";
    }else{
      DateFormat dateFormat = new DateFormat('yyyy-MM-dd   h:mma');
      dateTimeString = dateFormat.format(_dateTimeValue);
    }
    return dateTimeString;
}

List<int> getCityIDs(List<String> list, Map<String, int> map){
    List<int> idList = [];
    for(int i = 0; i < list.length; i++){
      map.forEach((key, value){
        if(key == list[i]){
          idList.add(value);
        }
      }
      );
    }
    return idList;
}

}

