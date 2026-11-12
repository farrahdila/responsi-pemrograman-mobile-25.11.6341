import 'package:flutter/material.dart';

import '../providers/app_provider.dart';
import '../models/note.dart';
import '../utils/validators.dart';

/// Halaman form untuk menambahkan catatan kuliah baru dengan validasi dan sanitasi.
class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final rawTitle = _titleController.text;
      final rawContent = _contentController.text;

      final sanitizedTitle = Validators.sanitize(rawTitle);
      final sanitizedContent = Validators.sanitize(rawContent);

      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: sanitizedTitle,
        date: DateTime.now(),
      );

      final provider = AppProvider.of(context);
      await provider.addNote(newNote, sanitizedContent);

      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil disimpan secara aman!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.blue.shade900,
        title: const Text(
          'Tambah Catatan Kuliah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Catatan',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  hintText: 'Contoh: Pemrograman Mobile Pertemuan 1',
                ),
                validator: Validators.validateTitle,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Isi Catatan',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  hintText: 'Tuliskan ringkasan materi kuliah di sini...',
                ),
                validator: Validators.validateContent,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.save),
                label: const Text(
                  'Simpan Catatan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
