import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data_service.dart';
import '../utilis/api_config.dart';

class TambahAsetScreen extends StatefulWidget {
  const TambahAsetScreen({super.key});

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
  final _syaratKetentuanController = TextEditingController();
  DataService dataService = DataService();
  PlatformFile? _pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Aset'),
        centerTitle: true,
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
              GestureDetector(
                onTap: _pickImage, // Panggil _pickImage saat area di-tap
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _pickedFile != null
                      ? Image.file(File(_pickedFile!.path!))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported_outlined, size: 48),
                            const SizedBox(height: 8),
                            const Text('Tambah Gambar'),
                          ],
                        ),
                ),
              ),
              //Menambahkan Nama Aset
              SizedBox(height: 10),
              Text(
                "Nama",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama aset',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Ubah warna border menjadi biru
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama aset tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              //Menambahkan Nama Kategori
              Text(
                "Kategori",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _kategoriController,
                decoration: InputDecoration(
                  hintText: 'Masukkan kategori aset',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Ubah warna border menjadi biru
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              //Menambahkan Nama Lokasi
              Text(
                "Lokasi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _lokasiController,
                decoration: InputDecoration(
                  hintText: 'Masukkan lokasi aset',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Ubah warna border menjadi biru
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              //Menambahkan Nama Kondisi
              Text(
                "Kondisi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _kondisiController,
                decoration: InputDecoration(
                  hintText: 'Masukkan kondisi aset',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Ubah warna border menjadi biru
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kondisi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              //Menambahkan Nama Kondisi
              Text(
                "Deskripsi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 5,
                controller: _deskripsiController,
                decoration: InputDecoration(
                  hintText: 'Masukkan deskripsi aset',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Ubah warna border menjadi biru
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              //Menambahkan Nama Syarat dan Ketentuan
              Text(
                "Syarat dan Ketentuan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _syaratKetentuanController,
                decoration: InputDecoration(
                  hintText: 'Masukkan syarat dan ketentuan',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Ubah warna border menjadi biru
                  ),
                ),
                maxLines: 5,
                // Atur jumlah baris sesuai kebutuhan
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Syarat dan ketentuan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      String nama = _namaController.text;
                      String kategori = _kategoriController.text;
                      String lokasi = _lokasiController.text;
                      String kondisi = _kondisiController.text;
                      String deskripsi = _deskripsiController.text;
                      String syaratKetentuan = _syaratKetentuanController.text;

                      // Pastikan gambar sudah dipilih
                      if (_pickedFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Pilih gambar terlebih dahulu.')),
                        );
                        return;
                      }

                      // Upload gambar ke API
                      var responseUpload = await dataService
                          .upload(
                            token,
                            project,
                            _pickedFile!.bytes!,
                            _pickedFile!.extension.toString(),
                          )
                          .then((value) => jsonDecode(value));

                      _imageUrl = responseUpload['file_name'];

                      // Panggil fungsi insertAset dan simpan ID yang dikembalikan
                      var responseInsert = await dataService
                          .insertAset(appId, nama, kategori, lokasi, kondisi,
                              deskripsi, _imageUrl!, syaratKetentuan)
                          .then((value) => jsonDecode(value));

                      // Panggil fungsi updateId (jika diperlukan)
                      var responseUpdate = await dataService.updateId(
                          'gambar',
                          _imageUrl!,
                          token,
                          project,
                          collection,
                          appId,
                          responseInsert[0]['_id']);

                      // Tampilkan pesan sukses
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Aset berhasil ditambahkan!')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      // Tangani error
                      print('Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Terjadi error.')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  // Warna latar belakang
                  foregroundColor: Colors.white,
                  // Warna teks
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('SIMPAN'),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? _imageUrl;

  Future<void> _pickImage() async {
    try {
      var picked = await FilePicker.platform.pickFiles(withData: true);

      if (picked != null) {
        // Simpan data gambar di state
        setState(() {
          _pickedFile = picked.files.first;
        });

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil dipilih!')),
        );
      }
    } on PlatformException catch (e) {
      // Tangani error
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memilih gambar.')),
      );
    }
  }
}
