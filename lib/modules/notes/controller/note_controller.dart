// note_controller.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class NoteController extends GetxController {
  RxList<Map<String, dynamic>> allNotes = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredNotes = <Map<String, dynamic>>[].obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notesData = prefs.getString('notes');
    if (notesData != null) {
      List<dynamic> decodedData = json.decode(notesData);
      allNotes.assignAll(decodedData.map((item) => Map<String, dynamic>.from(item)).toList());
      filteredNotes.assignAll(allNotes);
    }
  }

  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(allNotes);
    await prefs.setString('notes', encodedData);
  }

  void addOrUpdateNote({
    required String title,
    required String content,
    required Color color,
    int? index,
  }) {
    if (index != null) {
      allNotes[index]['title'] = title;
      allNotes[index]['content'] = content;
      allNotes[index]['color'] = color.value;
    } else {
      allNotes.add({
        'title': title,
        'content': content,
        'color': color.value,
        'date': DateTime.now().toIso8601String(),
      });
    }
    filteredNotes.assignAll(allNotes);
    _saveNotes();
  }

  void deleteNote(int index) {
    allNotes.removeAt(index);
    filteredNotes.assignAll(allNotes);
    _saveNotes();
  }

  void filterNotes(String query) {
    if (query.isEmpty) {
      filteredNotes.assignAll(allNotes);
    } else {
      filteredNotes.assignAll(allNotes.where((note) {
        String title = note['title'].toLowerCase();
        String content = note['content'].toLowerCase();
        return title.contains(query.toLowerCase()) || content.contains(query.toLowerCase());
      }).toList());
    }
  }

  void copyToClipboard(BuildContext context, String content) {
    Clipboard.setData(ClipboardData(text: content)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Copied to Clipboard")),
      );
    });
  }
}
