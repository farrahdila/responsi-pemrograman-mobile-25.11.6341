import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import '../services/secure_storage_service.dart';

/// Repository untuk mengelola akses data catatan kuliah (Metadata & Konten Aman).
class NoteRepository {
  static const String _notesKey = 'saved_notes_metadata';
  final SecureStorageService _secureStorageService = SecureStorageService();

  /// Mengambil daftar seluruh metadata catatan.
  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString(_notesKey);
    if (notesJson == null) return [];

    final List<dynamic> decodedList = jsonDecode(notesJson);
    return decodedList.map((item) => Note.fromJson(item)).toList();
  }

  /// Menyimpan catatan baru (metadata ke SharedPreferences, konten ke SecureStorage).
  Future<void> saveNote(Note note, String content) async {
    final prefs = await SharedPreferences.getInstance();
    List<Note> notes = await getNotes();

    notes.add(note);
    await prefs.setString(
      _notesKey,
      jsonEncode(notes.map((n) => n.toJson()).toList()),
    );
    await _secureStorageService.saveContent(note.id, content);
  }

  /// Menghapus catatan berdasarkan ID.
  Future<void> deleteNote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<Note> notes = await getNotes();

    notes.removeWhere((note) => note.id == id);
    await prefs.setString(
      _notesKey,
      jsonEncode(notes.map((n) => n.toJson()).toList()),
    );
    await _secureStorageService.deleteContent(id);
  }

  /// Mengambil isi lengkap catatan (termasuk konten terenkripsi).
  Future<String?> getNoteContent(String id) async {
    return await _secureStorageService.getContent(id);
  }
}
