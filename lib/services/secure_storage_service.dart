import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Layanan untuk mengelola penyimpanan data sensitif secara aman dengan enkripsi.
class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Menyimpan isi catatan secara terenkripsi berdasarkan ID catatan.
  Future<void> saveContent(String noteId, String content) async {
    await _secureStorage.write(key: 'note_content_$noteId', value: content);
  }

  /// Membaca isi catatan terenkripsi berdasarkan ID catatan.
  Future<String?> getContent(String noteId) async {
    return await _secureStorage.read(key: 'note_content_$noteId');
  }

  /// Menghapus isi catatan terenkripsi berdasarkan ID catatan.
  Future<void> deleteContent(String noteId) async {
    await _secureStorage.delete(key: 'note_content_$noteId');
  }
}
