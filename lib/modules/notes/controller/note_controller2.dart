import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteController extends GetxController {
  // List to store all notes
  var allNotes = <Map<String, dynamic>>[].obs;

  // Function to add or update a note
  void addOrUpdateNote({
    required String title,
    required String content,
    required Color color,
    int? index,
  }) {
    final currentTime = DateTime.now();

    if (index == null) {
      // Add a new note with timestamp
      allNotes.add({
        'title': title,
        'content': content,
        'color': color.value,
        'createdAt': currentTime.toString(), // Store timestamp as a string
      });
    } else {
      // Update an existing note (retain original timestamp)
      allNotes[index] = {
        'title': title,
        'content': content,
        'color': color.value,
        'createdAt': allNotes[index]['createdAt'] ?? currentTime.toString(),
      };
    }
  }
}
