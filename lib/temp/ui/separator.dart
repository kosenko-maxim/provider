//import 'package:flutter/material.dart';
//
//import '../../constants/layout.dart' show screenHorizontalPadding;
//
//class Separator extends StatelessWidget {
//	final SeparatorModel separator;
//
//	Separator(this.separator);
//
//  @override
//  Widget build(BuildContext context) {
//  	switch (separator.type) {
//		  case 'text': return buildText(separator.key);
//		  case 'line': return buildLine();
//		  default: return Container();
//	  }
//  }
//
//  buildText(String key) {
//	  return LayoutBuilder(
//		  builder: (BuildContext context, BoxConstraints viewportConstraints) {
//				return Container(
//					padding: EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
//					height: 30.0,
//					child: Text(
//						key,
//						style: Theme.of(context).textTheme.title,
//					),
//				);
//		  },
//	  );
//  }
//
//  buildLine() {
//  	return Container(
//		  height: 4.0,
//		  color: Color(0xFFE3E3E3),
//	  );
//  }
//}
