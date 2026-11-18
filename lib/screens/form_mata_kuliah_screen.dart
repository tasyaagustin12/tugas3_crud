// lib/screens/form_mata_kuliah_screen.dart
import 'package:flutter/material.dart';
import '../models/mata_kuliah.dart';

class FormMataKuliahScreen extends StatefulWidget {
  final MataKuliah? mataKuliahEdit;

  const FormMataKuliahScreen({super.key, this.mataKuliahEdit});

  @override
  State<FormMataKuliahScreen> createState() => _FormMataKuliahScreenState();
}

class _FormMataKuliahScreenState extends State<FormMataKuliahScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _kode;
  late String _namaMk;
  late int _sks;
  late int _semester;

  @override
  void initState() {
    super.initState();
    _kode = widget.mataKuliahEdit?.kode ?? '';
    _namaMk = widget.mataKuliahEdit?.namaMk ?? '';
    _sks = widget.mataKuliahEdit?.sks ?? 3;
    _semester = widget.mataKuliahEdit?.semester ?? 1;
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final mkBaru = MataKuliah(
        id: widget.mataKuliahEdit?.id ?? DateTime.now().toString(),
        kode: _kode,
        namaMk: _namaMk,
        sks: _sks,
        semester: _semester,
      );
      Navigator.pop(context, mkBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mataKuliahEdit == null ? 'Tambah Mata Kuliah' : 'Edit Mata Kuliah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _kode,
                decoration: const InputDecoration(labelText: 'Kode Mata Kuliah'),
                validator: (val) => val == null || val.isEmpty ? 'Kode tidak boleh kosong' : null,
                onSaved: (val) => _kode = val!,
              ),
              TextFormField(
                initialValue: _namaMk,
                decoration: const InputDecoration(labelText: 'Nama Mata Kuliah'),
                validator: (val) => val == null || val.isEmpty ? 'Nama tidak boleh kosong' : null,
                onSaved: (val) => _namaMk = val!,
              ),
              TextFormField(
                initialValue: _sks.toString(),
                decoration: const InputDecoration(labelText: 'SKS'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'SKS tidak boleh kosong';
                  if (int.tryParse(val) == null) return 'SKS harus berupa angka';
                  return null;
                },
                onSaved: (val) => _sks = int.parse(val!),
              ),
              TextFormField(
                initialValue: _semester.toString(),
                decoration: const InputDecoration(labelText: 'Semester'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Semester tidak boleh kosong';
                  if (int.tryParse(val) == null) return 'Semester harus berupa angka';
                  return null;
                },
                onSaved: (val) => _semester = int.parse(val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpan,
                child: Text(widget.mataKuliahEdit == null ? 'Simpan' : 'Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}