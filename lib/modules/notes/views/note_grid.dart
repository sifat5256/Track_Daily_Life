import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_daily_life/modules/notes/views/note_view_screen.dart';
import '../controller/note_controller.dart';
import 'add_note_screen.dart';

class NoteGridPage extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  NoteGridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Get.to(() => NoteDetailsPage());
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
      ),
      body: Obx(
            () => noteController.filteredNotes.isEmpty
            ? const Center(child: Text('No notes found'))
            : GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3 / 2,
          ),
          itemCount: noteController.filteredNotes.length,
          itemBuilder: (context, index) {
            var note = noteController.filteredNotes[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => NoteDetailsPage(index: index));
              },
              child: Card(
                color: Color(note['color']),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note['title'],
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            note['content'],
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Text(
                            _formatDate(note['date']),
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,

                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.black, size: 20),
                            onPressed: () => noteController.copyToClipboard(
                              context,
                              note['content'],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye, color: Colors.black, size: 20),
                            onPressed: () => Get.to(() => NoteViewPage(note: note)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black, size: 20),
                            onPressed: () => _deleteNoteConfirmation(context, index),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _deleteNoteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              noteController.deleteNote(index);
              Get.back();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Search Notes'),
          content: TextField(
            controller: noteController.searchController,
            decoration: const InputDecoration(hintText: 'Enter search query'),
            onChanged: (value) => noteController.filterNotes(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
