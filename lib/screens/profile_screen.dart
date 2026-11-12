import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:io';

import '../providers/app_provider.dart';
import '../config/app_config.dart';
import '../models/student.dart';
import '../widgets/profile_card.dart';
import '../utils/validators.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nimController;
  late TextEditingController _prodiController;
  late TextEditingController _emailController;
  bool _isInitialized = false;

  List<dynamic> _apiPosts = [];
  bool _isLoadingApi = true;
  String _apiError = '';

  @override
  void initState() {
    super.initState();
    _fetchApiData();
  }

  Future<void> _fetchApiData() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/posts?_limit=3'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() {
          _apiPosts = jsonDecode(response.body);
          _isLoadingApi = false;
        });
      } else {
        setState(() {
          _apiError = 'Gagal memuat data dari server.';
          _isLoadingApi = false;
        });
      }
    } on SocketException {
      setState(() {
        _apiError = 'Tidak ada koneksi internet.';
        _isLoadingApi = false;
      });
    } catch (e) {
      setState(() {
        _apiError = 'Terjadi kesalahan sistem.';
        _isLoadingApi = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final student = AppProvider.of(context).student;
      _nameController = TextEditingController(text: student.name);
      _nimController = TextEditingController(text: student.nim);
      _prodiController = TextEditingController(text: student.programStudi);
      _emailController = TextEditingController(text: student.email);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _prodiController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.blue.shade900,
        title: const Text(
          'Profil Mahasiswa & Info Akademik',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ProfileCard(student: provider.student),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nimController,
                decoration: InputDecoration(
                  labelText: 'NIM',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'NIM tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prodiController,
                decoration: InputDecoration(
                  labelText: 'Program Studi',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Program Studi tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                  ),
                ),
                validator: Validators
                    .validateEmail, // Hanya mengecek agar tidak kosong
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
                  'Simpan Perubahan Profil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updated = Student(
                      name: _nameController.text.trim(),
                      nim: _nimController.text.trim(),
                      programStudi: _prodiController.text.trim(),
                      email: _emailController.text.trim(),
                    );
                    provider.updateStudent(updated);
                    Navigator.pop(context, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profil berhasil diperbarui!'),
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 40),
              const Text(
                'Info Akademik (API Publik)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _isLoadingApi
                  ? const Center(child: CircularProgressIndicator())
                  : _apiError.isNotEmpty
                  ? Center(
                      child: Text(
                        _apiError,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _apiPosts.length,
                      itemBuilder: (context, index) {
                        final post = _apiPosts[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 6),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.article_outlined,
                              color: Colors.blue,
                            ),
                            title: Text(
                              post['title'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              post['body'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
