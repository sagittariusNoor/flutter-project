import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> fetchNotes(String userId) async {
    var snapshot = await _db.collection('notes').where('userId', isEqualTo: userId).get();
    _notes = snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> addNote(String userId, String title, String content) async {
    var newNote = await _db.collection('notes').add({
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': Timestamp.now(),
    });

    _notes.add(Note(id: newNote.id, title: title, content: content));
    notifyListeners();
  }

  Future<void> updateNote(String noteId, String title, String content) async {
    await _db.collection('notes').doc(noteId).update({'title': title, 'content': content});
    _notes.firstWhere((note) => note.id == noteId)
      ..title = title
      ..content = content;
    notifyListeners();
  }

  Future<void> deleteNote(String noteId) async {
    await _db.collection('notes').doc(noteId).delete();
    _notes.removeWhere((note) => note.id == noteId);
    notifyListeners();
  }
}
