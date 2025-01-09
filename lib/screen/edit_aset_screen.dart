import 'package:flutter/material.dart';

class EditAsetScreen extends StatefulWidget {
  final Map<String, dynamic> aset; // Terima data aset sebagai parameter

  const EditAsetScreen({Key? key, required this.aset}) : super(key: key);

  @override
  State<EditAsetScreen> createState() => _EditAsetScreenState();
}

class _EditAsetScreenState extends State<EditAsetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _kategoriController;
  late TextEditingController _lokasiController;
  late TextEditingController _kondisiController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data aset
    _namaController = TextEditingController(text: widget.aset['nama']);
    _kategoriController = TextEditingController(text: widget.aset['kategori']);
    _lokasiController = TextEditingController(text: widget.aset['lokasi']);
    _kondisiController = TextEditingController(text: widget.aset['kondisi']);
    _deskripsiController = TextEditingController(text: widget.aset['deskripsi']);
  }

  @override
  void dispose() {
    // Dispose controller saat widget di-dispose
    _namaController.dispose();
    _kategoriController.dispose();
    _lokasiController.dispose();
    _kondisiController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Aset'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Aset',
                  hintText: 'Masukkan nama aset',
                  prefixIcon: Icon(Icons.inventory_2),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama aset tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  hintText: 'Masukkan kategori aset',
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _lokasiController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  hintText: 'Masukkan lokasi aset',
                  prefixIcon: Icon(Icons.location_pin),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _kondisiController,
                decoration: const InputDecoration(
                  labelText: 'Kondisi',
                  hintText: 'Masukkan kondisi aset',
                  prefixIcon: Icon(Icons.check_circle),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kondisi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _deskripsiController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Masukkan deskripsi aset',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Proses penyimpanan data aset yang telah diedit
                    // ...
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}