// note_details_page.dart


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/note_controller.dart';



class NoteDetailsPage extends StatefulWidget {
  final int? index; // Index of the note in the list, null if adding a new note

  NoteDetailsPage({Key? key, this.index}) : super(key: key);

  @override
  _NoteDetailsPageState createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  final NoteController noteController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  Color selectedColor = Colors.red;

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      var note = noteController.allNotes[widget.index!];
      titleController.text = note['title'];
      contentController.text = note['content'];
      selectedColor = Color(note['color']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [

      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.white,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.index == null ? 'Add Note' : 'Edit Note', style: TextStyle(
            color: Colors.white,fontSize: 22,fontWeight: FontWeight.w600
        ),),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(

                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 15,
              ),
              const SizedBox(height: 20),
              const Text('Select Color:'),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: colors.map((color) {
                  return ChoiceChip(
                    selectedColor: color.withOpacity(0.6),
                    backgroundColor: color,
                    selected: selectedColor == color,
                    onSelected: (isSelected) {
                      setState(() {
                        selectedColor = isSelected ? color : selectedColor;
                      });
                    },
                    label: const Text(""),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: _saveNote,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green
                  ),
                  child: const Center(child: Text("Save Note",

                    style: TextStyle(
                    color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600
                  ),)),
                ),
              ),
              // ElevatedButton(
              //   onPressed: _saveNote,
              //   child: const Text("Save"),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.green,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    noteController.addOrUpdateNote(
      title: titleController.text.trim(),
      content: contentController.text.trim(),
      color: selectedColor,
      index: widget.index,
    );

    Get.back(); // Close the page
  }
}
