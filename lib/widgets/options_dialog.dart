import 'package:flutter/material.dart';

 class OptionsDialog extends StatefulWidget{
   OptionsDialog({
     this.cities,
     this.selectedCities,
     this.onSelectedCitiesListChanged
   });
   final List<String> cities;
   final List<String> selectedCities;
   final ValueChanged<List<String>> onSelectedCitiesListChanged;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new OptionsDialogState();
  }
 }

class OptionsDialogState extends State<OptionsDialog>{
   List<String> _tempSelectedCities = [];
   @override
  void initState() {
    // TODO: implement initState
     _tempSelectedCities = widget.selectedCities;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      child: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'ALL CITIES',
                  style: TextStyle(
                      fontSize: 18.0, color: Colors.black, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: (){
                    Navigator.pop(context);
                    },
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            new Expanded(
                child: ListView.builder(
                    itemCount: widget.cities.length,
                    itemBuilder: (BuildContext context, int index){
                      final cityName = widget.cities[index];
                      return Container(
                        child: CheckboxListTile(
                          title: Text(cityName),
                          value: _tempSelectedCities.contains(cityName),
                          onChanged: (bool value){
                            if(value){
                              if( ! _tempSelectedCities.contains(cityName)){
                                setState(() {
                                  _tempSelectedCities.add(cityName);
                                });
                              }
                            }else{
                              if(_tempSelectedCities.contains(cityName)){
                                setState(() {
                                  _tempSelectedCities.removeWhere((String city)=> city == cityName);
                                });
                              }
                            }
                            widget.onSelectedCitiesListChanged(_tempSelectedCities);
                          },
                        ),
                      );
                    }
                )
            )
          ],
        ),
      ),
    );
  }
}