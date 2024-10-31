// search_results_page.dart


import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:intl/intl.dart';

import '../controller/note_controller.dart';
import 'note_details_screen.dart';


class SearchResultsPage extends StatelessWidget {
  final NoteController noteController = Get.find();

  SearchResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredNotes = noteController.filteredNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: Obx(() => filteredNotes.isEmpty
          ? const Center(child: Text('No notes found.'))
          : ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final note = filteredNotes[index];
          Color noteColor = Color(note['color']);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: noteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                note['title'],
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
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
              trailing: IconButton(
                icon: const Icon(Icons.copy, color: Colors.black),
                onPressed: () {
                  noteController.copyToClipboard(context, note['content']);
                },
              ),
              onTap: () {
                // Navigate to NoteDetailsPage to view/edit the note
                Get.to(() => NoteDetailsPage(index: noteController.allNotes.indexOf(note)));
              },
            ),
          );
        },
      )),
    );
  }
}
