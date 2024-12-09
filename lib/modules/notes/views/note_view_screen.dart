import 'package:flutter/material.dart';

class NoteViewPage extends StatelessWidget {
  final Map<String, dynamic> note;

  const NoteViewPage({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(note['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            note['content'],
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
