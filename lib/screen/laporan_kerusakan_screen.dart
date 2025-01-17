import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/data_service.dart';
import 'package:manajemen_aset/utilis/api_config.dart';

class LaporKerusakanScreen extends StatefulWidget {
  final String asetId;

  const LaporKerusakanScreen({Key? key, required this.asetId}) : super(key: key);

  @override
  State<LaporKerusakanScreen> createState() => _LaporKerusakanScreenState();
}

class _LaporKerusakanScreenState extends State<LaporKerusakanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();
  PlatformFile? _pickedFile;
  String? _imageUrl;

  DataService dataService = DataService();

  Future<void> _pickImage() async {
    try {
      var picked = await FilePicker.platform.pickFiles(withData: true);

      if (picked != null) {
        setState(() {
          _pickedFile = picked.files.first;
        });
      }
    } on PlatformException catch (e) {
      // Tangani error
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memilih gambar.')),
      );
    }
  }

  Future<void> _submitLaporan() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Jika ada gambar yang dipilih, upload gambar
        if (_pickedFile != null) {
          // Upload gambar ke API
          var response = await dataService.upload(
            token,
            project,
            _pickedFile!.bytes!,
            _pickedFile!.extension.toString(),
          ).then((value) => jsonDecode(value));

          _imageUrl = response['file_name'];
        }

        // Simpan laporan kerusakan ke database
        var response = await dataService.insertLaporanKerusakan(
          appId,
          widget.asetId,
          _imageUrl ?? '-',
          DateFormat('dd-MM-yyyy').format(DateTime.now()), // Tanggal laporan
          _keteranganController.text,
        );

        if (response != '[]') {
          // Laporan berhasil disimpan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Laporan kerusakan berhasil disimpan!')),
          );
          Navigator.pop(context);
        } else {
          // Laporan gagal disimpan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menyimpan laporan kerusakan.')),
          );
        }
      } catch (e) {
        // Tangani error
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi error.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lapor Kerusakan Aset'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Area untuk menampilkan gambar atau ikon
              GestureDetector(
                onTap: _pickImage,
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
              const SizedBox(height: 16),

              //Menambahkan Nama Keterangan
              Text(
                "Keterangan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _keteranganController,
                decoration:  InputDecoration(
                  hintText: 'Jelaskan kerusakan yang terjadi',alignLabelWithHint: true,
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
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Tombol Kirim
              ElevatedButton(
                onPressed: _submitLaporan,
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
                child: const Text('Kirim Laporan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}