/// Kelas utilitas untuk validasi input form dan sanitasi karakter berbahaya.
class Validators {
  /// Validasi judul catatan: min 3 karakter, maks 50 karakter.
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul catatan tidak boleh kosong';
    }
    if (value.length < 5) {
      return 'Judul minimal harus 5 karakter';
    }
    if (value.length > 50) {
      return 'Judul maksimal 50 karakter';
    }
    return null;
  }

  /// Validasi isi catatan: min 10 karakter, maks 1000 karakter.
  static String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Isi catatan tidak boleh kosong';
    }
    if (value.length < 10) {
      return 'Isi catatan minimal harus 10 karakter';
    }
    if (value.length > 1000) {
      return 'Isi catatan maksimal 1000 karakter';
    }
    return null;
  }

  /// Memvalidasi format email umum (wajib mengandung karakter '@')
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    return null;
  }

  /// Menyaring karakter berbahaya untuk mencegah injeksi sederhana/XSS dasar.
  static String sanitize(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
  }
}
