import 'package:flutter/material.dart';

/// Widget untuk menampilkan keadaan kosong (empty state) saat belum ada catatan.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Belum ada catatan kuliah',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tekan tombol tambah (+) untuk membuat catatan baru.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
