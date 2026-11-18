// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';
import '../models/mata_kuliah.dart';
import 'form_mahasiswa_screen.dart';
import 'form_mata_kuliah_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Mahasiswa> _daftarMahasiswa = [];
  final List<MataKuliah> _daftarMataKuliah = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // CRUD Mahasiswa
  Future<void> _bukaFormMahasiswa({Mahasiswa? mhsEdit}) async {
    final hasil = await Navigator.push<Mahasiswa>(
      context,
      MaterialPageRoute(
        builder: (context) => FormMahasiswaScreen(mahasiswaEdit: mhsEdit),
      ),
    );

    if (hasil != null) {
      setState(() {
        if (mhsEdit == null) {
          _daftarMahasiswa.add(hasil);
        } else {
          final idx = _daftarMahasiswa.indexWhere((m) => m.id == hasil.id);
          if (idx != -1) _daftarMahasiswa[idx] = hasil;
        }
      });
    }
  }

  Future<void> _konfirmasiHapusMahasiswa(Mahasiswa mhs) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Mahasiswa?'),
        content: Text('Yakin ingin menghapus "${mhs.nama}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      setState(() {
        _daftarMahasiswa.removeWhere((item) => item.id == mhs.id);
      });
    }
  }

  // CRUD Mata Kuliah
  Future<void> _bukaFormMataKuliah({MataKuliah? mkEdit}) async {
    final hasil = await Navigator.push<MataKuliah>(
      context,
      MaterialPageRoute(
        builder: (context) => FormMataKuliahScreen(mataKuliahEdit: mkEdit),
      ),
    );

    if (hasil != null) {
      setState(() {
        if (mkEdit == null) {
          _daftarMataKuliah.add(hasil);
        } else {
          final idx = _daftarMataKuliah.indexWhere((m) => m.id == hasil.id);
          if (idx != -1) _daftarMataKuliah[idx] = hasil;
        }
      });
    }
  }

  Future<void> _konfirmasiHapusMataKuliah(MataKuliah mk) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Mata Kuliah?'),
        content: Text('Yakin ingin menghapus "${mk.namaMk}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      setState(() {
        _daftarMataKuliah.removeWhere((item) => item.id == mk.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Akademik'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Mahasiswa'),
            Tab(icon: Icon(Icons.book), text: 'Mata Kuliah'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Mahasiswa
          _daftarMahasiswa.isEmpty
              ? const Center(child: Text('Belum ada data mahasiswa.'))
              : ListView.builder(
                  itemCount: _daftarMahasiswa.length,
                  itemBuilder: (context, index) {
                    final mhs = _daftarMahasiswa[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(mhs.nama),
                        subtitle: Text('NIM: ${mhs.nim} | Prodi: ${mhs.prodi}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _bukaFormMahasiswa(mhsEdit: mhs),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _konfirmasiHapusMahasiswa(mhs),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

          // Tab 2: Mata Kuliah
          _daftarMataKuliah.isEmpty
              ? const Center(child: Text('Belum ada data mata kuliah.'))
              : ListView.builder(
                  itemCount: _daftarMataKuliah.length,
                  itemBuilder: (context, index) {
                    final mk = _daftarMataKuliah[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(mk.namaMk), // Diubah dari mk.nama menjadi mk.namaMk
                        subtitle: Text('Kode: ${mk.kode} | SKS: ${mk.sks} | Sem: ${mk.semester}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _bukaFormMataKuliah(mkEdit: mk),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _konfirmasiHapusMataKuliah(mk),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            _bukaFormMahasiswa();
          } else {
            _bukaFormMataKuliah();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}