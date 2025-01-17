import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manajemen_aset/data_service.dart';
import 'package:manajemen_aset/utilis/api_config.dart';

class EditAsetScreen extends StatefulWidget {
  final Map<String, dynamic> aset; // Terima data aset sebagai parameter

  const EditAsetScreen({super.key, required this.aset});

  @override
  State<EditAsetScreen> createState() => _EditAsetScreenState();
}

class _EditAsetScreenState extends State<EditAsetScreen> {
  DataService dataService = DataService();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _kategoriController;
  late TextEditingController _lokasiController;
  late TextEditingController _kondisiController;
  late TextEditingController _deskripsiController;
  late TextEditingController _syaratKetentuanController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data aset
    _namaController = TextEditingController(text: widget.aset['nama']);
    _kategoriController = TextEditingController(text: widget.aset['kategori']);
    _lokasiController = TextEditingController(text: widget.aset['lokasi']);
    _kondisiController = TextEditingController(text: widget.aset['kondisi']);
    _deskripsiController =
        TextEditingController(text: widget.aset['deskripsi']);
    _syaratKetentuanController =
        TextEditingController(text: widget.aset['syarat_ketentuan']);
  }

  @override
  void dispose() {
    // Dispose controller saat widget di-dispose
    _namaController.dispose();
    _kategoriController.dispose();
    _lokasiController.dispose();
    _kondisiController.dispose();
    _deskripsiController.dispose();
    _syaratKetentuanController.dispose();
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
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      fileUri + widget.aset['gambar'],
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Tampilkan widget alternatif jika gambar kosong atau tidak valid
                        return const SizedBox(
                          width: 200,
                          height: 200,
                          child: Icon(Icons.image_not_supported_outlined),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          disabledForegroundColor:
                              Colors.grey.withOpacity(0.38),
                          disabledBackgroundColor:
                              Colors.grey.withOpacity(0.12),
                          shape: const CircleBorder(),
                        ),
                        onPressed: () => _pickImage(),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 1. Ambil nilai dari TextEditingController
                    String nama = _namaController.text;
                    String kategori = _kategoriController.text;
                    String lokasi = _lokasiController.text;
                    String kondisi = _kondisiController.text;
                    String deskripsi = _deskripsiController.text;
                    String syaratKetentuan = _syaratKetentuanController.text;

                    // 2. Gabungkan nama field dan nilai field
                    String updateFields =
                        'nama~kategori~lokasi~kondisi~deskripsi~syarat_ketentuan';
                    String updateValues =
                        '$nama~$kategori~$lokasi~$kondisi~$deskripsi~$syaratKetentuan';

                    // 3. Panggil fungsi updateId
                    dataService
                        .updateId(
                      updateFields,
                      updateValues,
                      token,
                      'manajemen_aset',
                      'aset',
                      appId,
                      widget.aset['_id'], // Ganti dengan ID aset
                    )
                        .then((value) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }).catchError((error) {
                      print('Error updating data: $error');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Gagal menyimpan data. Silakan coba lagi.'),
                      ));
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      var picked = await FilePicker.platform.pickFiles(withData: true);

      if (picked != null) {
        // Upload gambar ke API
        var response = await dataService
            .upload(
              token,
              project,
              picked.files.first.bytes!,
              picked.files.first.extension.toString(),
            )
            .then((value) => jsonDecode(value));

        String imageUrl = response['file_name'];

        // Update data gambar di database
        bool success = await dataService.updateId(
          'gambar',
          imageUrl,
          token,
          project,
          'aset',
          appId,
          widget.aset['_id'],
        );

        if (success) {
          setState(() {
            widget.aset['gambar'] = imageUrl;
          });

          // Tampilkan pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gambar berhasil diupdate!')),
          );
        } else {
          // Tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengupdate gambar.')),
          );
        }
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
