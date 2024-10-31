// notes_home_page.dart


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/note_controller.dart';
import 'note_details_screen.dart';
import 'search_result_screen.dart';



class NotesHomePage extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearchBar(context);
            },
          ),
        ],
      ),
      body: Obx(() => noteController.allNotes.isEmpty
          ? const Center(child: Text('No notes available.'))
          : ListView.builder(
        itemCount: noteController.allNotes.length,
        itemBuilder: (context, index) {
          final note = noteController.allNotes[index];
          Color noteColor = Color(note['color']);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: noteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    note['title'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.content_copy, color: Colors.black),
                        onPressed: () {
                          noteController.copyToClipboard(context, note['content']);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () {
                          noteController.deleteNote(index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Created: ${DateFormat.yMMMd().add_jm().format(DateTime.parse(note['date']))}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note['content'],
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              onTap: () {
                Get.to(() => NoteDetailsPage(index: index));
              },
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => NoteDetailsPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showSearchBar(BuildContext context) {
    noteController.searchController.clear();

    Get.dialog(
      AlertDialog(
        title: TextField(
          controller: noteController.searchController,
          decoration: InputDecoration(
            hintText: 'Search notes...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (query) {
            noteController.filterNotes(query);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (noteController.searchController.text.isNotEmpty) {
                Get.back();
                Get.to(() => SearchResultsPage());
              } else {
                noteController.filterNotes('');
                Get.back();
              }
            },
            child: const Text('Search'),
          ),
          TextButton(
            onPressed: () {
              noteController.searchController.clear();
              noteController.filterNotes('');
              Get.back();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
