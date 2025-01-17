import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/utilis/api_config.dart';

import '../data_service.dart';
import '../models/maintenance_schedule.dart';

class PerawatanScren extends StatefulWidget {
  final MaintenanceScheduleModel jadwal;
  final String asetId;

  const PerawatanScren({super.key, required this.jadwal, required this.asetId});

  @override
  State<PerawatanScren> createState() => _PerawatanScrenState();
}

class _PerawatanScrenState extends State<PerawatanScren> {
  DataService dataService = DataService();

  final _formKey = GlobalKey<FormState>();
  final _biayaController = TextEditingController();
  final _keteranganController = TextEditingController();
  final _kondisiController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _tanggalSelesaiController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalSelesaiController.text = DateFormat('yyyy-MM-dd')
            .format(picked); // Format tanggal dan update controller
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perawatan'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Menambahkan Biaya
              Text(
                "Biaya",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _biayaController,
                decoration: InputDecoration(
                  hintText: 'Masukan biaya',
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
                keyboardType: TextInputType.number,
              ),

              //Menambahkan Keterangan
              SizedBox(height: 10),
              Text(
                "Keterangan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(
                  hintText: 'Masukan Keterangan',
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
              ),

              //Menambahkan Pilih Tanggal
              SizedBox(height: 10),
              Text(
                "Pilih Tanggal",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _tanggalSelesaiController,
                decoration: InputDecoration(
                    hintText: 'Masukan Tanggal Selesai',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.blue), // Ubah warna border menjadi biru
                    )),
                onTap: () => _selectDate(context),
              ),

              //Menambahkan Kondisi
              SizedBox(height: 10),
              Text(
                "Kondisi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _kondisiController,
                decoration: InputDecoration(
                  hintText: 'Masukan kondisi',
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
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Ambil data dari form
                    String scheduleid =
                        widget.jadwal.id; // ID dari MaintenanceScheduleModel
                    String biaya = _biayaController.text;
                    String keterangan = _keteranganController.text;
                    String tanggalSelesai = _tanggalSelesaiController.text;

                    String asetId = widget.asetId;
                    String kondisi = _kondisiController.text;

                    // Panggil fungsi insertMaintenanceHistory
                    var response = await dataService.insertMaintenanceHistory(
                      appId, // Ganti dengan appid yang sesuai
                      scheduleid,
                      biaya,
                      keterangan,
                      tanggalSelesai,
                    );

                    var responseUpdate = await dataService.updateId(
                      'kondisi',
                      kondisi,
                      token,
                      project,
                      collection,
                      appId, asetId
                    );
                    // Handle response
                    if (response != '[]') {
                      // Data berhasil disimpan
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Data berhasil disimpan!')),
                      );
                      // Navigasi kembali ke halaman sebelumnya
                      Navigator.pop(context);
                    } else {
                      // Terjadi error saat menyimpan data
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal menyimpan data.')),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
