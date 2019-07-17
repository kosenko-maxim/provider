import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../components/styled/styled_circular_progress.dart'
    show StyledCircularProgress;

class PageTemplate extends StatelessWidget {
  const PageTemplate(
      {this.title,
      this.note,
      this.body,
      this.goBack,
      this.drawer,
      this.loading = false,
      this.padding = false,
      this.actions});

  static const Color color = Color(0xFF585555);
  static const double height = 68.0;

  final String title;
  final String note;
  final Widget body;
  final Function goBack;
  final Widget drawer;
  final bool loading;
  final bool padding;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color(0xFFe9e7e7),
          iconTheme: const IconThemeData(color: color),
          leading: loading
              ? Container()
              : drawer == null
                  ? IconButton(
                      color: color,
                      tooltip: 'go back',
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        if (goBack is Function) {
                          goBack();
                        } else if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      })
                  : null,
          centerTitle: true,
          title:
              Text(title, style: const TextStyle(color: color, fontSize: 20.0)),
          actions: actions),
      drawer: drawer,
      body: Container(
        child: body,
      ),
    );
  }
}
