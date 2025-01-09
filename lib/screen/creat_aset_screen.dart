import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manajemen_aset/screen/detail_aset_screen.dart';
import '../data_service.dart';

class TambahAsetScreen extends StatefulWidget {
  const TambahAsetScreen({Key? key}) : super(key: key);

  @override
  State<TambahAsetScreen> createState() => _TambahAsetScreenState();
}

class _TambahAsetScreenState extends State<TambahAsetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _kondisiController = TextEditingController();
  final _deskripsiController = TextEditingController();

  DataService dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Aset'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                  prefixIcon: Icon(Icons.inventory_2), // Ikon untuk nama aset
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
                  prefixIcon: Icon(Icons.category), // Ikon untuk kategori
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
                  prefixIcon: Icon(Icons.location_pin), // Ikon untuk lokasi
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
                  prefixIcon: Icon(Icons.check_circle), // Ikon untuk kondisi
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
                maxLines: 5,
                controller: _deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Masukkan deskripsi aset',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description), // Ikon untuk deskripsi
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => pickImage(),
                // Ganti 'id_aset' dengan ID aset yang sesuai
                child: const Text('Pilih Gambar'),
              ),

              const SizedBox(height: 32.0),
              // Di dalam _TambahAsetScreenState
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Ambil data dari formulir
                    String appid = '677a3903f853312de5509e51';
                    String nama = _namaController.text;
                    String kategori = _kategoriController.text;
                    String lokasi = _lokasiController.text;
                    String kondisi = _kondisiController.text;
                    String deskripsi = _deskripsiController.text;

                    // Panggil fungsi insertAset
                    var response = await dataService.insertAset(
                        appid, nama, kategori, lokasi, kondisi, deskripsi, "d");

                    // Tampilkan pesan sukses atau error berdasarkan response
                    if (response != '[]') {
                      // Data berhasil disimpan
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Aset berhasil ditambahkan!')),
                      );
                      // Navigasi kembali ke halaman sebelumnya atau bersihkan formulir
                      // ...
                    } else {
                      // Terjadi error saat menyimpan data
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Gagal menambahkan aset.')),
                      );
                    }
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

  Future<File?> pickImage() async {
    try {
      var result = await FilePicker.platform.pickFiles(withData: true);

      if (result != null) {
        return File(result.files.single.path!);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}

