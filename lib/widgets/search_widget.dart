//import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
//class SearchWidget extends StatelessWidget{
////  final performSearch;
////  const SearchWidget({Key key, @required this.performSearch}) : super(key: key);
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return new Card(
//      elevation: 3.0,
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.all(Radius.circular(2.0))
//      ),
//      child: Padding(
//        padding: EdgeInsets.symmetric(horizontal: 15.0),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            GestureDetector(
//              child: Icon(Icons.search, color: Colors.black54,),
//              onTap: (){},
//            ),
//            SizedBox(width: 10.0,),
//            Expanded(
//                child: TextField(
//                  decoration: InputDecoration(
//                    border: InputBorder.none, hintText: 'Search...',
//                  ),
//                  onSubmitted: (String location){
////                    performSearch(location);
//                  },
//                )
//            ),
//            InkWell(
//              child: Icon(FontAwesomeIcons.slidersH, color: Colors.black54,),
//              onTap: (){},
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//}