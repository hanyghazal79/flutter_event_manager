import 'package:flutter/material.dart';
import 'package:flutter_event_manager/global.dart';
import 'package:flutter_event_manager/models/database_helper.dart';
import 'package:flutter_event_manager/widgets/options_dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Home extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomeState();
  }
}

class HomeState extends State<Home>{
  DatabaseHelper _helper;
  Map<String, dynamic> resultMap;
  List<dynamic> events;
  Widget appBarStateWidget;
  Icon customIcon;
  bool isSearch = false;
//  static List<dynamic> locations;
  //===
  List<dynamic> _cities;
  static List<String> allCitiesNames;
  Map<String, int> _citiesMapNameID;
  List<String> _selectedCities = [];
  //===
  Widget _widget = new Container();
  TextEditingController _typeAheadController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
//    defineEventList();
    getAllCities();
  }
  init(){
    isSearch = false;
    customIcon = new Icon(Icons.search);
    appBarStateWidget = new Text('All events');
    _helper = new DatabaseHelper();
    resultMap = new Map();
    resultMap.clear();
//    locations = new List();
    //===
    _cities = new List();
    allCitiesNames = new List();
    _citiesMapNameID = new Map();
    //===
    events = new List();
    _typeAheadController.addListener(listenToSuggestion);

  }

  void updateInherited(String name){
    setState(() {
      _widget = dataWidget(name);
    });
  }
  void listenToSuggestion(){
    setState(() {
      updateInherited(_typeAheadController.text);
    });
  }
  void getAllEvents(){
    resultMap.clear();
    events.clear();
    _helper.getEvents().then((result){
      setState(() {
        resultMap.addAll(result);
        events.addAll(resultMap['data']);
      });
    });
  }
  void getSelectedCityEvents(String cityName){
    resultMap.clear();
    events.clear();
    _helper.getSelectedCityEvents(cityName).then((result){
      setState(() {
        resultMap.addAll(result);
        events.addAll(resultMap['data']);
      });
    });
  }

  void getAllCities(){
    _helper.getCities().then((result){
      setState(() {
        resultMap.addAll(result);
        _cities.addAll(resultMap['data']);
        for(int i = 0; i<_cities.length; i++){
          allCitiesNames.add(_cities[i]['city_name_en']);
          _citiesMapNameID.addAll({'${_cities[i]['city_name_en']}' : _cities[i]['id']});
        }
      });
    });
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

  Widget dataWidget(String entry){
    if(entry == ""){
      _helper.getEvents().then((result){
        setState(() {
          resultMap.addAll(result);
          events.clear();
          events.addAll(resultMap['data']);
        });
      });
    }else{
      _helper.getSelectedCityEvents(entry).then((result){
        setState(() {
          resultMap.addAll(result);
          events.clear();
          events.addAll(resultMap['data']);
        });
      });
    }
    return new ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: events.length,
      itemBuilder: (context, index){
        return new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.event),
              ),
              title: Text('${events.elementAt(index)['title']}'),
              subtitle: Text('${events.elementAt(index)['details']}'),
            )
          ],
        );
      },
    );
  }
  List<String> getSuggestions(String query){
    List<String> matches = new List();
    matches.addAll(allCitiesNames);
    matches.retainWhere((test)=> test.toLowerCase().startsWith(query.toLowerCase()));
    return matches;
  }
  @override
  Widget build(BuildContext context) { // ===> Start of build ===>
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: this.isSearch ? searchWidget() : Text('All events'),
        leading: Builder(
            builder: (context)=>IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){Scaffold.of(context).openDrawer();},
            )
        ),
        actions: <Widget>[
          IconButton(
              icon: this.isSearch ? Icon(Icons.close) : Icon(Icons.search),
              onPressed: (){
                setState(() {
                  this.isSearch = this.isSearch ? this.isSearch = false : this.isSearch = true;
                });
              }
          ),
          PopupMenuButton(
            onSelected: onPopupMenuItemSelected,
              itemBuilder: (BuildContext context){
              return Global.homePopupMenuItems.map((String choice){
                return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                );
              }).toList();}
              )
        ],
      ),
      body:new Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 10, bottom: 10, right: 16, left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(child:  _widget)
          ],
        ),
      ),
      drawer: new Drawer(
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(Global.currentUser.getImageUrl()),
                      radius: 60.0,
                    ),
                    Text(Global.currentUser.getEmail(), style: TextStyle(color:  Colors.white),)
                  ],
                )
              ),
              ListTile(
                title: Text('              All events'),
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                    _typeAheadController.clear();
                    _widget = new Container();
                    _widget = dataWidget("");
                  });
                },
              ),
              ListTile(
                title: Text('              My events'),
                onTap: (){
                setState(() {
                  Navigator.pop(context);
                  // code getting current user events //
                });
                },
              ),
              ListTile(
                title: Text('              My profile'),
                onTap: (){
                  setState(() {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('profile');
                  });
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: goToAddEvent,
        child: Icon(Icons.add),
      ),
    );
  }

  void goToAddEvent() {
    Navigator.of(context).pushNamed('add');
  }

  void onPopupMenuItemSelected(String choice) {
    if(choice == Global.SETTINGS){
      Navigator.of(context).pushNamed('settings');
    }
    else if(choice == Global.LOGOUT){
      logout();
    }
  }

  Widget searchWidget(){
    return new TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
          autofocus: true,
          cursorColor: Colors.white,
          controller: _typeAheadController,
          style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic, color: Colors.white),
          decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.white)
          )
      ),
      suggestionsCallback: (pattern){
        return getSuggestions(pattern);
      },
      itemBuilder: (context, suggestion){
        String searched = _typeAheadController.text;
        return searched == "" ? null : ListTile(
          title: Text(suggestion),
          onTap: (){
            setState(() {
              _typeAheadController.text = suggestion;
              _widget = new Container();
              _widget = dataWidget(suggestion);
            });
          },
        );
      },
      onSuggestionSelected: (suggestion){
        setState(() {
          _typeAheadController.text = suggestion;
          _widget = new Container();
          _widget = dataWidget(suggestion);
        });
      },

    );
  }

  void logout() async{
    bool isRemoved;
    await SharedPreferences.getInstance().then((sp){
      setState(() {
        sp.remove(Global.CURRENT_USER_KEY).then((result){
          setState(() {
            isRemoved = result;
          });
        });
      });
    });
    if(isRemoved){
      Navigator.of(context).pushNamed('login');
    }
  }

  void setTitle() {

  }
}
