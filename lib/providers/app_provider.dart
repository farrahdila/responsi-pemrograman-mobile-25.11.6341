import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan import ini

import '../models/student.dart';
import '../models/note.dart';
import '../repositories/note_repository.dart';

class AppProvider extends InheritedWidget {
  final Student student;
  final List<Note> notes;
  final Function(Student) updateStudent;
  final Future<void> Function(Note, String) addNote;
  final Future<void> Function(String) deleteNote;
  final Future<String?> Function(String) getNoteContent;

  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required this.getNoteContent,
    required super.child,
  });

  static AppProvider of(BuildContext context) {
    final AppProvider? result = context
        .dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(result != null, 'No AppProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return student != oldWidget.student || notes != oldWidget.notes;
  }
}

class AppProviderWrapper extends StatefulWidget {
  final Widget child;
  const AppProviderWrapper({super.key, required this.child});

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  final NoteRepository _noteRepository = NoteRepository();

  Student _student = Student(
    name: 'Mahasiswa Amikom',
    nim: '22.11.1234',
    programStudi: 'S1 Informatika',
    email: 'mahasiswa@students.amikom.ac.id',
  );

  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// Memuat data mahasiswa dan catatan dari SharedPreferences saat aplikasi pertama dibuka
  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil data profil tersimpan jika ada
    final savedName = prefs.getString('student_name');
    final savedNim = prefs.getString('student_nim');
    final savedProdi = prefs.getString('student_prodi');
    final savedEmail = prefs.getString('student_email');

    if (savedName != null && savedNim != null) {
      setState(() {
        _student = Student(
          name: savedName,
          nim: savedNim,
          programStudi: savedProdi ?? 'S1 Informatika',
          email: savedEmail ?? 'mahasiswa@students.amikom.ac.id',
        );
      });
    }

    final loadedNotes = await _noteRepository.getNotes();
    setState(() {
      _notes = loadedNotes;
    });
  }

  /// Menyimpan perubahan profil ke SharedPreferences agar permanen
  Future<void> _updateStudent(Student newStudent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_name', newStudent.name);
    await prefs.setString('student_nim', newStudent.nim);
    await prefs.setString('student_prodi', newStudent.programStudi);
    await prefs.setString('student_email', newStudent.email);

    setState(() {
      _student = newStudent;
    });
  }

  Future<void> _addNote(Note note, String content) async {
    await _noteRepository.saveNote(note, content);
    final loadedNotes = await _noteRepository.getNotes();
    setState(() {
      _notes = loadedNotes;
    });
  }

  Future<void> _deleteNote(String id) async {
    await _noteRepository.deleteNote(id);
    final loadedNotes = await _noteRepository.getNotes();
    setState(() {
      _notes = loadedNotes;
    });
  }

  Future<String?> _getNoteContent(String id) async {
    return await _noteRepository.getNoteContent(id);
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      getNoteContent: _getNoteContent,
      child: widget.child,
    );
  }
}
