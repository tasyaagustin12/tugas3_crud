// lib/widgets/kartu_mahasiswa.dart
import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';

class KartuMahasiswa extends StatelessWidget {
  final Mahasiswa mahasiswa;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const KartuMahasiswa({
    super.key,
    required this.mahasiswa,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(child: Text(mahasiswa.nama[0].toUpperCase())),
        title: Text(mahasiswa.nama, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('NIM: ${mahasiswa.nim} • Sem. ${mahasiswa.semester}\n${mahasiswa.prodi}'),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.teal),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}