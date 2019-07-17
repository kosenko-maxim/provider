//import 'package:flutter/material.dart';
//import '../../../constants/layout.dart' show standardPadding;
//
//class PageTemplate extends StatelessWidget {
//  static const Color color = Color(0xFF585555);
//  static const double height = 64.0;
//
//  final String title;
//  final String note;
//  final Widget body;
//  final Function goBack;
//  final bool padding;
//
//  PageTemplate({
//    this.title,
//    this.note,
//    this.body,
//    this.goBack,
//    this.padding = false,
//  });
//
//  @override
//  Widget build(BuildContext context) {
//    double horizontalPadding = padding ? standardPadding : 0.0;
//    return Scaffold(
//      appBar: AppBar(
//        automaticallyImplyLeading: false,
//        backgroundColor: Color(0xFFe9e7e7),
//        bottom: (note is String)
//            ? PreferredSize(
//                preferredSize: Size.fromHeight(54.0),
//                child: Container(
//                  decoration: BoxDecoration(
//                    color: Color(0xFFb5ffc5c5),
//                    border: Border.all(
//                      color: Color(0xFFecc3c3),
//                      width: 1.0,
//                    ),
//                  ),
//                  width: double.infinity,
//                  height: 54.0,
//                  padding: EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 30.0),
//                  child: Text(
//                    'Note',
//                    style: TextStyle(
//                      fontSize: 16.0,
//                      color: Color(0xFFdeff0000),
//                    ),
//                  ),
//                ),
//              )
//            : null,
//        iconTheme: IconThemeData(color: color),
//        leading: IconButton(
//          color: color,
//          icon: Icon(Icons.arrow_back_ios),
//          onPressed: () {
//            if (goBack is Function) {
//              goBack();
//            } else {
//              if (Navigator.canPop(context)) {
//                Navigator.pop(context);
//              } else {
//                Navigator.pushReplacementNamed(context, '/');
//              }
//            }
//          },
//          tooltip: 'go back',
//        ),
//        centerTitle: true,
//        title: Text(title, style: TextStyle(color: color, fontSize: 20.0)),
//      ),
//      body: Container(
////        padding: EdgeInsets.symmetric(vertical: standardPadding, horizontal: padding ? standardPadding : 0.0),
//        padding: EdgeInsets.fromLTRB(
//            horizontalPadding, 0.0, horizontalPadding, standardPadding),
//        child: body,
//      ),
//    );
//  }
//}
