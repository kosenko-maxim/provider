import 'package:flutter/material.dart';
import '../../models/screen/components/note_model.dart' show NoteModel;

class Note extends StatelessWidget {
  Note(this.note)
      : id = note.id,
        color = note.color;

  final NoteModel note;
  final String id;
  final String color;

  static const int HIGHLIGHT_COLOR = 0xFFdeff0000;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 54.0,
      padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 6.0),
      child: Text(
        note.value,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
      decoration: BoxDecoration(
        color: color is String ? Color(int.parse(color)) : null,
        border: const Border(
          left: BorderSide(
            color: Color(0xFFd24444),
            width: 4.0,
          ),
          bottom: BorderSide(
            color: Color(0xFFecc3c3),
            width: 1.0,
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF40000000),
            spreadRadius: 4.0,
            blurRadius: 5.0,
          ),
        ],
      ),
    );
  }
}
