import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/note_controller.dart';

class NoteDetailsPage extends StatefulWidget {
  final int? index;

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
        title: Text(widget.index == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 10,
            ),
            const SizedBox(height: 10),
            const Text('Select Color:'),
            Wrap(
              spacing: 8.0,
              children: colors.map((color) {
                return ChoiceChip(
                  selected: selectedColor == color,
                  selectedColor: color.withOpacity(0.6),
                  backgroundColor: color,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedColor = isSelected ? color : selectedColor;
                    });
                  },
                  label: const Text(''),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Save Note'),
            ),
          ],
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

    Get.back();
  }
}
